// Created by Liam Ngo on 20/2/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Config.Colors.background
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsView()
}
