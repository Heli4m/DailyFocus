//
//  Task.swift
//  DailyFocus
//
//  Created by Liam Ngo on 21/1/26.
//

import SwiftUI

struct Task: View {
    let width: CGFloat
    let data: TaskData
    
    var body: some View {
        Button {
            
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: width, height: 100)
                .foregroundStyle(Color(Config.itemColor))
                .overlay (
                    HStack {
                        VStack (alignment: .leading) {
                            LexendMediumText(text: data.name, size: 20)
                                .foregroundStyle(Config.primaryText)
                            
                            LexendMediumText(text: "\(data.time) minutes", size: 15)
                                .foregroundStyle(Config.secondaryText)
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    Task(width: 350, data: TaskData(
        name: "Mock Task",
        time: 10,
        priority: 2
    ))
}
