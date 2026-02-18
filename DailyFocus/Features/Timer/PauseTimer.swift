//
//  PauseTimer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 25/1/26.
//

import SwiftUI

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
                    .foregroundStyle(Config.bgColor)
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
                                .foregroundStyle(Config.secondaryText)
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

#Preview {
    PauseTimer(onResume: {
        print("resume")
    }, onReturn: {
        print("return")
    }, onCancel: {
        print("cancel")
    })
}
