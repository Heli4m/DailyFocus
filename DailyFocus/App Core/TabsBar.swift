// Created by Liam Ngo on 16/2/26.
// Purpose: Implements the custom navigation bar for the app, allowing for custom icons and a navigator that matches the UI better.

import SwiftUI

struct TabsBar: View {
    @Binding var currentTab: TabEnum
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: Config.Layout.mainBigCornerRadius)
                    .frame(width: geometry.size.width, height: 60)
                    .foregroundStyle(Config.Colors.item)
                
                HStack (spacing: 0){
                    IndividualTabButton(
                        tab: .home,
                        systemImageName: "house.circle",
                        selectedImageName: "house.circle.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .checklist,
                        systemImageName: "checkmark.square",
                        selectedImageName: "checkmark.square.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .timedtasks,
                        systemImageName: "fitness.timer",
                        selectedImageName: "fitness.timer.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .timer,
                        systemImageName: "hourglass.circle",
                        selectedImageName: "hourglass.circle.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .settings,
                        systemImageName: "gearshape",
                        selectedImageName: "gearshape.fill",
                        currentTab: $currentTab
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct IndividualTabButton: View {
    let tab: TabEnum
    let systemImageName: String
    let selectedImageName: String
    @Binding var currentTab: TabEnum
    
    var body: some View {
        ZStack {
            Image(systemName: currentTab == tab ? selectedImageName : systemImageName)
                .font(.system(size: Config.Layout.standardMediumTextSize))
                .foregroundStyle(Config.Colors.secondaryText)
            
            Button {
                withAnimation (.easeInOut) {
                    currentTab = tab
                }
            } label: {
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Config.Colors.secondaryText.opacity(0.01))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
