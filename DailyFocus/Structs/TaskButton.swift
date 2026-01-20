//
//  TaskButton.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

struct NewTaskButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .frame(width: 75, height: 75)
                .foregroundStyle(Color(Config.itemColor))
                .overlay {
                    Cross()
                }
                .overlay {
                    Circle()
                        .stroke(Color(Config.bgColor), lineWidth: 5)
                }
        }
    }
}
