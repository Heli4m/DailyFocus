//
//  PauseTimer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 25/1/26.
//

import SwiftUI

struct PauseTimer: View {
    let onResume: () -> Void

    @State private var showPlay = false
    @State private var scale: CGFloat = 1.0

    var body: some View {
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
    }
}
