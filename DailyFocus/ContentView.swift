//
//  ContentView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                
                Image("layeredWavesbg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(minWidth: 0)
                
                VStack {
                    NewTaskButton()
                        .position(x: geometry.size.width - 75, y: geometry.size.height - 50)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
