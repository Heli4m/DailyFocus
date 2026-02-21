// Created by Liam Ngo on 20/2/26.
// Purpose: A celebratory view that provides "Trophies" at the end of each task based on performance.

import SwiftUI

struct TaskCompleteHighlight: View {
    let totalTaskTime: Int
    let completedTaskTime: Int
    let taskPriority: Int
    let pauseCount: Int
    let geometry: GeometryProxy
    
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                LexendMediumText(text: "Your highlight of the task is", size: Config.Layout.standardTitleTextSize)
                    .foregroundColor(Config.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .padding(.top, Config.Layout.standardPaddingExtraLarge)
                
                Spacer()
                
                Button {
                    onContinue()
                    Haptics.success()
                } label: {
                    RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                        .foregroundStyle(Config.Colors.accent)
                        .frame(width: max(0, geometry.size.width - 30), height: 40)
                        .overlay {
                            LexendMediumText(text: "Continue", size: Config.Layout.standardSmallTextSize)
                                .foregroundStyle(Color(Config.Colors.primaryText))
                        }
                }
            }
            
            if pauseCount == 0 && completedTaskTime >= 30 {
                Trophy(
                    iconSystemName: "flame.fill",
                       title: "Unstoppable",
                       descriptionText: "Total flow state! You didn't stop once!",
                       color: Config.Colors.mediumPriority
                )
            } else if completedTaskTime >= 45 {
                Trophy(
                    iconSystemName: "brain.fill",
                       title: "Deep Focus",
                       descriptionText: "A masterclass in concentration. You put in serious work!",
                       color: Config.Colors.accent
                )
            } else if taskPriority == 3 {
                Trophy(
                    iconSystemName: "exclamationmark.shield.fill",
                       title: "High Stakes",
                       descriptionText: "You stepped up and cleared a critical task",
                    color: Config.Colors.highPriority
                )
            } else if Double(completedTaskTime) / Double(totalTaskTime) < 0.8 {
                Trophy(
                    iconSystemName: "bolt.fill",
                       title: "Speed Demon",
                       descriptionText: "Lightning fast! You crushed this ahead of time.",
                    color: .yellow
                )
            } else if completedTaskTime < 15 {
                Trophy(
                    iconSystemName: "figure.run",
                       title: "The Sprint",
                       descriptionText: "A perfect burst of energy to stay productive.",
                    color: .green
                )
            } else {
                Trophy(
                    iconSystemName: "checkmark.seal.text.page.fill",
                       title: "Completionist",
                       descriptionText: "Another win for the day. Keep the momentum!",
                    color: Config.Colors.secondaryText
                )
            }
        }
    }
}

struct Trophy: View {
    let iconSystemName: String
    let title: String
    let descriptionText: String
    let color: Color
    
    @State private var transitionPhases: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                if transitionPhases >= 1 {
                    LexendMediumText(text: title, size: 50)
                        .foregroundStyle(color)
                        .padding(.bottom, Config.Layout.standardPaddingLarge)
                        .shadow(color: color, radius: 10)
                }
                
                if transitionPhases >= 2 {
                    Image(systemName: iconSystemName)
                        .font(.system(size: 250))
                        .foregroundStyle(color)
                        .shadow(color: color, radius: 10)
                }
                
                if transitionPhases == 3 {
                    LexendMediumText(text: descriptionText, size: Config.Layout.standardMediumTextSize)
                        .foregroundStyle(Config.Colors.primaryText)
                        .padding(.top, Config.Layout.standardPaddingLarge)
                        .monospacedDigit()
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            sequentialDisplay()
        }
    }
    
    func sequentialDisplay() {
        for i in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.0) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    transitionPhases = i
                }
                
                switch i {
                case 1: Haptics.trigger(.medium)
                case 2: Haptics.success()
                case 3: Haptics.trigger(.light)
                default: break
                }
            }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        TaskCompleteHighlight(
            totalTaskTime: 10,
            completedTaskTime: 8,
            taskPriority: 1,
            pauseCount: 1,
            geometry: geometry,
            onContinue: {
                print("continued")
            }
        )
    }
}
