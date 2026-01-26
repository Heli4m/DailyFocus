//
//  PauseShapes.swift
//  DailyFocus
//
//  Created by Liam Ngo on 25/1/26.
//

import SwiftUI

// Designed with the same "smoothness" as Lexend Medium
struct LexendPlayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // We use a rounded path approach to avoid sharp points
        let width = rect.width
        let height = rect.height
        
        // Defining the triangle points with a slight inset for the "Lexend" curve
        let p1 = CGPoint(x: width * 0.15, y: 0)
        let p2 = CGPoint(x: width * 0.15, y: height)
        let p3 = CGPoint(x: width, y: height * 0.5)
        
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
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

