//
//  LexendTexts.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import Foundation
import SwiftUI

struct LexendRegularText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Regular", size: size))
    }
}

struct LexendMediumText: View {
    var text: String
    var size: CGFloat
    
    var body: some View {
        Text(text)
            .font(Font.custom("Lexend-Medium", size: size))
    }
}
