//
//  PriorityDot.swift
//  DailyFocus
//
//  Created by Liam Ngo on 21/1/26.
//

import SwiftUI

struct PriorityDotMainView: View {
    @Binding var selectedButton: Int
    @Namespace private var animation
    
    var body: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 80)
                .foregroundStyle(Color(Config.itemColor))
            HStack (alignment: .center, spacing: 0) {
                ForEach(1...3, id: \.self) { index in
                    Button {
                        withAnimation {
                            selectedButton = index
                        }
                        Haptics.trigger(.light)
                    } label: {
                        ZStack {
                            Color.clear
                            PriorityDotButton(index: index, selectedButton: $selectedButton)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selectedButton == index {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Config.secondaryText)
                                .frame(width: 115, height: 40)
                                .padding()
                                .matchedGeometryEffect(id: "slider", in: animation)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct PriorityDotButton: View {
    let index: Int
    @Binding var selectedButton: Int
    
    var body: some View {
        ZStack {            
            HStack {
                ForEach (0..<index, id: \.self) { _ in
                    PriorityDot(id: index, selectedButton: $selectedButton)
                }
            }
        }
        .frame(maxWidth: .infinity)
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
