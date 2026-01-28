//
//  TaskUseBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI

struct TaskUseBar: View {
    var onStart: () -> Void
    var onEdit: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    Button {
                        onStart()
                        Haptics.trigger(.medium)
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: geometry.size.width - 50, height: 50)
                            .foregroundStyle(Config.itemColor)
                            .overlay {
                                LexendMediumText(text: "Start task", size: 18)
                                    .foregroundStyle(Config.accentColor)
                            }
                    }
                    
                    Button {
                        onEdit()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: geometry.size.width - 50, height: 50)
                            .foregroundStyle(Config.itemColor)
                            .overlay {
                                LexendMediumText(text: "Edit task", size: 18)
                                    .foregroundStyle(Config.accentColor)
                            }
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    TaskUseBar(
        onStart: {
            print("placeholder")
        },
        onEdit: {
            print("placeholder #2")
        }
    )
}
