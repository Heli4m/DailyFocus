//
//  Task.swift
//  DailyFocus
//
//  Created by Liam Ngo on 21/1/26.
//

import SwiftUI

struct Task: View {
    let width: CGFloat = 300
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: width, height: 100)
            .foregroundStyle(Color(Config.itemColor))
    }
}

#Preview {
    Task()
}
