//
//  TimerMainContainer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 13/2/26.
//

import SwiftUI

struct TimerMainContainer: View {
    @Binding var appState: AppState?
    @Binding var selectedMinutes: Int
    
    var body: some View {
        ZStack {
            if appState == .runningTask {
                CountDownTimer (
                    seconds: selectedMinutes, // reset this to selectedMinutes * 60 once testing is complete
                    onReturn: {
                        appState = nil
                    }
                ) // Convert to seconds
            } else {
                TimerNotSelectedView()
            }
        }
    }
}
