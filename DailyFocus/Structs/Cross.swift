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
            Rectangle()
                .frame(width: 10, height: 42.5)
                .foregroundStyle(Color(Config.bgColor))
            Rectangle()
                .frame(width: 42.5, height: 10)
                .foregroundStyle(Color(Config.bgColor))
        }
    }
}
