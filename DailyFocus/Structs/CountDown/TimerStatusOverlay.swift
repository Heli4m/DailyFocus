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
    var body: some View {
        if timeModel.timerState == .paused {
            PauseTimer {
                timeModel.resume()
                Haptics.trigger(.light)
            }
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
