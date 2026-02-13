//
//  TimerNotSelectedView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 13/2/26.
//

import SwiftUI

struct TimerNotSelectedView: View {
    var body: some View {
        ZStack (alignment: .center) {
            Color(Config.bgColor)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "timer.circle.fill")
                    .foregroundStyle(Config.primaryText)
                    .font(.system(size: 100))
                    .padding(.bottom)
                
                LexendMediumText(text: "You haven't started a task yet!", size: 30)
                    .monospacedDigit()
                    .foregroundStyle(Config.primaryText)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    TimerNotSelectedView()
}
