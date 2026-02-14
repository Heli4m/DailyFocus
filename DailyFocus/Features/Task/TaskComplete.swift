//
//  TaskComplete.swift
//  DailyFocus
//
//  Created by Liam Ngo on 14/2/26.
//

import SwiftUI

struct TaskComplete: View {
    let selectedMinutes: Int
    let pauseCount: Int
    let completionPercentage: Int
    
    let onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Config.bgColor
                    .ignoresSafeArea()
                
                VStack {
                    LexendMediumText(text: "Task Completed!", size: 35)
                        .foregroundStyle(Config.primaryText)
                        .padding(.bottom)
                        .padding(.top, 70)
                    
                    VStack {
                        StatsShape(title: "Time Focused:", number: String(selectedMinutes), type: "minutes", imageName: "stopwatch.fill")
                        StatsShape(title: "Pause Count:", number: String(pauseCount), type: "times", imageName: "pause.circle.fill")
                        customStatsShape(title: "Daily Quota:", number: completionPercentage, type: "", imageName: "chart.line.uptrend.xyaxis.circle.fill")
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        onContinue()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Config.accentColor)
                            .frame(width: max(0, geometry.size.width - 30), height: 40)
                            .overlay {
                                LexendMediumText(text: "Continue", size: 18)
                                    .foregroundStyle(Color(Config.primaryText))
                            }
                    }
                }
            }
        }
    }
}

struct StatsShape: View {
    let title: String
    let number: String
    let type: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Config.itemColor.opacity(0.7))
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .overlay (alignment: .leading) {
                VStack (alignment: .leading, spacing: 0) {
                    LexendMediumText(text: title, size: 15)
                        .foregroundStyle(Config.primaryText)
                    
                    LexendMediumText(text: number, size: 70)
                        .foregroundStyle(Config.primaryText)
                    
                    LexendMediumText(text: type, size: 15)
                        .foregroundStyle(Config.primaryText)
                }
                .padding(.leading, 30)
            }
            .overlay (alignment: .trailing) {
                Image(systemName: imageName)
                    .font(.system(size: 190))
                    .offset(x: 50, y: 30)
                    .rotationEffect(Angle(degrees: 20))
                    .foregroundStyle(Config.secondaryText)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct customStatsShape: View {
    let title: String
    let number: Int
    let type: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Config.itemColor.opacity(0.7))
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .overlay (alignment: .leading) {
                VStack (alignment: .leading, spacing: 0) {
                    LexendMediumText(text: title, size: 15)
                        .foregroundStyle(Config.primaryText)
                    
                    if number == 100 {
                        Image(systemName: "checkmark")
                            .font(.system(size: 70, weight: .bold))
                            .padding(.top)
                            .foregroundStyle(Config.accentColor)
                    } else {
                        LexendMediumText(text: "\(number)%", size: 70)
                            .foregroundStyle(Config.primaryText)
                    }
                    
                    LexendMediumText(text: type, size: 15)
                        .foregroundStyle(Config.primaryText)
                }
                .padding(.leading, 30)
            }
            .overlay (alignment: .trailing) {
                Image(systemName: imageName)
                    .font(.system(size: 190))
                    .offset(x: 50, y: 30)
                    .rotationEffect(Angle(degrees: 20))
                    .foregroundStyle(Config.secondaryText)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TaskComplete(
        selectedMinutes: 30,
        pauseCount: 1,
        completionPercentage: 100,
        onContinue: {
            print("continued")
        }
    )
}
