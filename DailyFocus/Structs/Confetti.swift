//
//  Confetti.swift
//  DailyFocus
//
//  Created by Liam Ngo on 29/1/26.
//

import Foundation
import SwiftUI
import Combine

struct ConfettiPiece: Identifiable {
    var id: UUID = UUID()
    let color: Color
    var xPos: CGFloat
    var yPos: CGFloat
    let size: CGFloat
    let velocity: CGSize
}

struct Confetti: View {
    @State private var Confettis: [ConfettiPiece] = []
    let containerSize: CGSize
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            ForEach(Confettis) { confetti in
                Rectangle()
                    .fill(confetti.color)
                    .frame(width: confetti.size, height: confetti.size)
                    .position(x: confetti.xPos, y: confetti.yPos)
            }
        }
        .onAppear() {
            spawnConfeti()
        }
        .onReceive(timer) { _ in
            updateConfetti()
        }
    }
    
    func spawnConfeti() {
        for _ in 0...70 {
            let piece = ConfettiPiece(
                color: [.red, .blue, .pink, .purple, .yellow].randomElement()!,
                xPos: CGFloat.random(in: 0...containerSize.width),
                yPos: -50,
                size: CGFloat.random(in: 5...12),
                velocity: CGSize(width: CGFloat.random(in: -2...2), height: CGFloat.random(in: 5...10))
            )
            Confettis.append(piece)
        }
    }
    
    func updateConfetti() {
        Confettis = Confettis.compactMap { piece -> ConfettiPiece? in
            let newY = piece.yPos + piece.velocity.height
            let newX = piece.xPos + piece.velocity.width
            
            if newY > containerSize.height + 100 { return nil }
                    
            return ConfettiPiece(color: piece.color, xPos: newX, yPos: newY, size: piece.size, velocity: piece.velocity)
        }
    }
}
