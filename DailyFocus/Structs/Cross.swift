//
//  Cross.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

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
