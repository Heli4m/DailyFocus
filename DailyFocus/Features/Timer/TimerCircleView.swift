//
//  TimerCircleView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import SwiftUI

struct TimerCircleView: View {
    let secondsRemaining: Int
    let totalSeconds: Int
    var body: some View {
        ZStack {
            Circle()
                .stroke(Config.primaryText.opacity(0.1), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: CGFloat(secondsRemaining) / CGFloat(totalSeconds))
                .stroke(
                    Color(Config.accentColor),
                    style: StrokeStyle(lineWidth: 10)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: secondsRemaining)
        }
        .frame(width: 350, height: 350)
    }
}

#Preview {
    TimerCircleView(secondsRemaining: 5, totalSeconds: 5)
}
