//
//  SquishButton.swift
//  DailyFocus
//
//  Created by Liam Ngo on 28/1/26.
//

import Foundation
import SwiftUI

struct SquishButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
