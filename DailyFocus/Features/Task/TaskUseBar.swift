//
//  TaskUseBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI

struct TaskUseBar: View {
    @Binding var isshowingSetUp: Bool
    @State private var selectedMinutes: Int = 25
    
    var onStart: (Int) -> Void
    var onEdit: () -> Void
    
    var body: some View {
        ZStack {
            if !isshowingSetUp {
                Color(Config.bgColor).ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            onEdit()
                        } label: {
                            VStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(Font.system(size: 100))
                                LexendMediumText(text: "Edit", size: 18)
                            }
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                isshowingSetUp = true
                            }
                        } label: {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(Font.system(size: 100))
                                LexendMediumText(text: "Start", size: 18)
                            }
                        }
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading).combined(with: .opacity)))
                    
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    LexendMediumText(text: "Choose Duration", size: 24)
                        .foregroundStyle(Config.primaryText)
                        .padding()
                    
                    HStack(spacing: 12) {
                        ForEach([15, 30, 45, 60], id: \.self) { mins in
                            Button {
                                selectedMinutes = mins
                                Haptics.trigger(.light)
                            } label: {
                                LexendMediumText(text: "\(mins)m", size: 16)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedMinutes == mins ? Config.accentColor : Config.itemColor)
                                    .foregroundStyle(selectedMinutes == mins ? .white : Config.primaryText)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        onStart(selectedMinutes)
                    } label: {
                        LexendMediumText(text: "Begin Focus", size: 24)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Config.accentColor)
                            .foregroundStyle(Config.primaryText)
                            .cornerRadius(20)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    struct TaskUseBarPreview: View {
        @State var isShowingSetup = false
        
        var body: some View {
            ZStack {
                Color(Config.bgColor).ignoresSafeArea()
                
                TaskUseBar(
                    isshowingSetUp: $isShowingSetup,
                    onStart: { mins in print("Started with \(mins) mins") },
                    onEdit: { print("Edit tapped") }
                )
            }
            .frame(height: 300)
        }
    }
    
    return TaskUseBarPreview()
}
