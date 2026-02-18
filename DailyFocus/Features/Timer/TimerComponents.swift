//
//  TimerComponents.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/2/26.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

struct CountDownTimer: View {
    @Bindable var timeModel: TimerViewModel
    @Environment(\.scenePhase) var scenePhase
    @State private var lastActiveDate: Date? = nil
    let onReturn: () -> Void
    let onFinish: () -> Void
    let onCancel: () -> Void
    @Binding var pauseCount: Int
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.Colors.background)
                    .ignoresSafeArea()
                    .onTapGesture(count: 2) {
                        guard !timeModel.isProcessingATap else { return }
                        timeModel.isProcessingATap = true
                        
                        Haptics.trigger(.heavy)
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if timeModel.timerState == .running {
                                timeModel.timerState = .paused
                                pauseCount += 1
                                timeModel.notifications.cancelNotifications()
                            } else if timeModel.timerState == .paused {
                                timeModel.resume()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            timeModel.isProcessingATap = false
                        }
                    }
                
                LexendMediumText(text: timeModel.timeString, size: 80)
                    .foregroundStyle(Config.Colors.primaryText)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(timeModel.secondsRemaining)))
                    .animation(.snappy, value: timeModel.secondsRemaining)
                
                TimerCircleView (
                    secondsRemaining: timeModel.secondsRemaining,
                    totalSeconds: timeModel.totalSeconds
                )
                
                TimerStatusOverlay(
                    timeModel: timeModel,
                    containerSize: geometry.size,
                    onReturn: onReturn,
                    onCancel: onCancel
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear() {
                timeModel.notifications.cancelNotifications()
                timeModel.notifications.scheduleNotification(secondsRemaining: timeModel.secondsRemaining)
            }
            .onReceive(timer) { _ in
                timeModel.tic()
                
                if timeModel.timerState == .finished {
                        withAnimation(.spring()) {
                            onFinish()
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if timeModel.timerState == .running {
                if newPhase == .background {
                    lastActiveDate = Date()
                } else if newPhase == .active {
                    if let lastDate = lastActiveDate, timeModel.timerState == .running {
                        let timePassed = Int(Date().timeIntervalSince(lastDate))
                        
                        withAnimation() {
                            timeModel.secondsRemaining -= timePassed
                        }
                        
                        if timeModel.secondsRemaining < 0 {
                            timeModel.secondsRemaining = 0
                            timeModel.timerState = .finished
                            withAnimation() {
                                onFinish()
                            }
                                
                        }
                    }
                }
            }
            
        }
    }
}

struct PauseTimer: View {
    let onResume: () -> Void
    let onReturn: () -> Void
    let onCancel: () -> Void

    @State private var showPlay = false
    @State private var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color.black.opacity(0.5))
                        .ignoresSafeArea()
                    
                    ZStack {
                        if showPlay {
                            LexendPlayShape()
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            LexendPauseShape()
                                .transition(.opacity)
                        }
                    }
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Config.Colors.background)
                    .scaleEffect(scale)
                    
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                        showPlay = true
                        scale = 1.3
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        onResume()
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            onCancel()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Config.Colors.secondaryText)
                                .padding(.vertical, 40)
                                .padding(.horizontal, 35)
                        }
                        .zIndex(10)
                    }
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct TimerStatusOverlay: View {
    var timeModel: TimerViewModel
    let containerSize: CGSize
    let onReturn: () -> Void
    let onCancel: () -> Void
    var body: some View {
        if timeModel.timerState == .paused {
            PauseTimer (
                onResume: {
                    timeModel.resume()
                    Haptics.trigger(.light)
                },
                onReturn: onReturn,
                onCancel: onCancel,
            )
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                )
            )
        }
    }
}

struct TimerCircleView: View {
    let secondsRemaining: Int
    let totalSeconds: Int
    var body: some View {
        ZStack {
            Circle()
                .stroke(Config.Colors.primaryText.opacity(0.1), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: CGFloat(secondsRemaining) / CGFloat(totalSeconds))
                .stroke(
                    Color(Config.Colors.accent),
                    style: StrokeStyle(lineWidth: 10)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: secondsRemaining)
        }
        .frame(width: 350, height: 350)
    }
}

struct TimerNotSelectedView: View {
    var body: some View {
        ZStack (alignment: .center) {
            Color(Config.Colors.background)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "timer.circle.fill")
                    .foregroundStyle(Config.Colors.primaryText)
                    .font(.system(size: 100))
                    .padding(.bottom)
                
                LexendMediumText(text: "You haven't started a task yet!", size: 30)
                    .monospacedDigit()
                    .foregroundStyle(Config.Colors.primaryText)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

