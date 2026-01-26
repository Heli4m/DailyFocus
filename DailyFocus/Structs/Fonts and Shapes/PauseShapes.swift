//
//  PauseShapes.swift
//  DailyFocus
//
//  Created by Liam Ngo on 25/1/26.
//

import SwiftUI

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

