//
//  PriorityDot.swift
//  DailyFocus
//
//  Created by Liam Ngo on 21/1/26.
//

import SwiftUI

struct PriorityDotMainView: View {
    let width: CGFloat = 115
    let gap: CGFloat = 2.5
    let leftPadding: CGFloat = 11.25
    @State var sliderXPos: CGFloat = 11.25
    @State var selectedButton: Int = 1
    
    var body: some View {
        ZStack (alignment: .leading) {
            Rectangle()
                .frame(height: 80)
                .foregroundStyle(Color(Config.itemColor))
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 115, height: 40)
                .foregroundStyle(Config.secondaryText)
                .offset(x: sliderXPos)
                .animation(.spring(response: 0.35, dampingFraction: 0.75), value: sliderXPos)
            HStack (spacing: gap) {
                ForEach(1...3, id: \.self) { index in
                    Button {
                        selectedButton = index
                        sliderXPos = leftPadding + CGFloat(index - 1) * (width + gap)
                    } label: {
                        PriorityDotButton(index: index, selectedButton: $selectedButton)
                    }
                }
            }
            .padding(.leading, leftPadding)
        }
    }
}

struct PriorityDotButton: View {
    let width: CGFloat = 115
    let index: Int
    @Binding var selectedButton: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: width, height: 40)
            .foregroundStyle(Config.bgColor.opacity(0.5))
            .overlay(
                HStack {
                    ForEach (0..<index, id: \.self) { _ in
                        PriorityDot(id: index, selectedButton: $selectedButton)
                    }
                }
            )
    }
}

struct PriorityDot: View {
    let id: Int
    @Binding var selectedButton: Int
    
    var dotColor: Color {
        id == selectedButton ? Config.accentColor : Config.secondaryText
    }
    
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(dotColor)
    }
}

#Preview {
    PriorityDotMainView()
}
