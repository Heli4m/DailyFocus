//
//  TimerStatusOverlay.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import SwiftUI

struct TimerStatusOverlay: View {
    var timeModel: TimerViewModel
    let containerSize: CGSize
    @Binding var appState: AppState?
    var body: some View {
        if timeModel.timerState == .paused {
            PauseTimer (
                onResume: {
                    timeModel.resume()
                    Haptics.trigger(.light)
                },
                appState: $appState)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                )
            )
        }
        
        if timeModel.showConfetti {
            Confetti(containerSize: containerSize)
                .ignoresSafeArea()
                .zIndex(10)
        }
    }
}
