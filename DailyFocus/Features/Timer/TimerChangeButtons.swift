//
//  TimerChangeButtons.swift
//  DailyFocus
//
//  Created by Liam Ngo on 10/2/26.
//

import SwiftUI

struct TimerChangeButtons: View {
    let onReturn: () -> Void
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    onReturn()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Config.accentColor.opacity(0.5))
                }
                .padding(.trailing, 2.5)
                .overlay {
                    LexendMediumText(text: "Return", size: 20)
                        .foregroundStyle(Config.primaryText)
                }
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Config.highPriority.opacity(0.5))
                }
                .padding(.leading, 2.5)
                .overlay {
                    LexendMediumText(text: "Cancel", size: 20)
                        .foregroundStyle(Config.primaryText)
                }
            }
            .frame(height: 75)
            .padding()
        }
    }
}
