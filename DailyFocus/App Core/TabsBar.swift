//
//  TabsBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 16/2/26.
//

import SwiftUI

struct TabsBar: View {
    @Binding var currentTab: TabEnum
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: geometry.size.width, height: 60)
                    .foregroundStyle(Config.itemColor)
                
                HStack (spacing: 0){
                    IndividualTabButton(
                        tab: .timer,
                        systemImageName: "timer.circle",
                        selectedImageName: "timer.circle.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .home,
                        systemImageName: "house",
                        selectedImageName: "house.fill",
                        currentTab: $currentTab
                    )
                    
                    IndividualTabButton(
                        tab: .timer,
                        systemImageName: "timer.circle",
                        selectedImageName: "timer.circle.fill",
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
                .font(.system(size: 20))
                .foregroundStyle(Config.secondaryText)
            
            Button {
                withAnimation (.easeInOut) {
                    currentTab = tab
                }
            } label: {
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Config.secondaryText.opacity(0.01))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
