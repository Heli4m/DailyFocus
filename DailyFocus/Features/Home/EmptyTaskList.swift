//
//  EmptyTaskList.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import SwiftUI

struct EmptyTaskList: View {
    @State var sparklePulse: Bool
    
    var body: some View {
        VStack { // no tasks view
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundStyle(Config.accentColor)
                .padding(.bottom)
                .scaleEffect(sparklePulse ? 1.1 : 1)
                .opacity(sparklePulse ? 1 : 0.7)
                .animation (
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: sparklePulse
                )
                .onAppear {
                    sparklePulse = true
                }
                
            
            LexendMediumText(text: "Tap the '+' to add your first focus task!", size: 28)
                .foregroundStyle(Config.primaryText)
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .padding(.top)
        }
    }
}
