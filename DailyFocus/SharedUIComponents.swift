// Created by Liam Ngo on 18/2/26.
// Purpose: A library of reusable custom UI components.

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

// MARK: Confetti
/// > Note: Timer runs every 0.02 seconds to not lag the processing but also provide a smooth animation. This is equivalent to about 50 fps.
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

// MARK: Cross
struct Cross: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 8, height: 35)
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 35, height: 8)
        }
        .foregroundStyle(Color.white)
    }
}

// MARK: LexendTexts

/// Wrapper to ensure LexendRegularText can be used consistently.
struct LexendRegularText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Regular", size: size))
    }
}

/// Wrapper to ensure LexendMediumText can be used consistently.
struct LexendMediumText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Medium", size: size))
    }
}

// MARK: Lexend Pause/Play Shapes
// Designed with the same "smoothness" as Lexend Medium
struct LexendPlayShape: Shape {
    var cornerRadius: CGFloat = 10 // Added a property for flexibility

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Defining the triangle points
        let p1 = CGPoint(x: width * 0.15, y: 0)          // Top Left
        let p2 = CGPoint(x: width * 0.15, y: height)     // Bottom Left
        let p3 = CGPoint(x: width, y: height * 0.5)      // Right Tip
        
        // Start at the midpoint of the left side to ensure corners round correctly
        path.move(to: CGPoint(x: p1.x, y: height * 0.5))
        
        // Rounding each corner using tangents
        path.addArc(tangent1End: p1, tangent2End: p3, radius: cornerRadius)
        path.addArc(tangent1End: p3, tangent2End: p2, radius: cornerRadius)
        path.addArc(tangent1End: p2, tangent2End: p1, radius: cornerRadius)
        
        path.closeSubpath()
        
        return path
    }
}

struct LexendPauseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let barWidth = rect.width * 0.32 // Matches the thickness of Lexend Medium strokes
        
        // Left Bar (Capsule style)
        path.addRoundedRect(
            in: CGRect(x: 0, y: 0, width: barWidth, height: rect.height),
            cornerSize: CGSize(width: barWidth/2, height: barWidth/2)
        )
        
        // Right Bar (Capsule style)
        path.addRoundedRect(
            in: CGRect(x: rect.width - barWidth, y: 0, width: barWidth, height: rect.height),
            cornerSize: CGSize(width: barWidth/2, height: barWidth/2)
        )
        
        return path
    }
}

/// The main view of the priority dot structs, which puts everything together. This is used in TaskEditBar.
///
/// Uses matchedGeometryEffect in order to have a sliding background.
struct PriorityDotMainView: View {
    @Binding var selectedButton: Int
    @Namespace private var animation
    
    var body: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: Config.Layout.mainBigCornerRadius)
                .frame(height: 80)
                .foregroundStyle(Color(Config.Colors.item))
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
                            RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                                .fill(Config.Colors.secondaryText)
                                .frame(width: 115, height: 40)
                                .padding()
                                .matchedGeometryEffect(id: "slider", in: animation)
                        }
                    }
                }
            }
            .padding(.horizontal, Config.Layout.standardPaddingMedium)
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
        id == selectedButton ? Config.Colors.accent : Config.Colors.secondaryText
    }
    
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(dotColor)
    }
}

struct SquishButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

