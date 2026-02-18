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
    @Binding var pauseCount: Int
    @Binding var timerModel: TimerViewModel
    
    var body: some View {
        ZStack {
            if appState == .runningTask || appState == .finishingTask {
                CountDownTimer (
                    timeModel: timerModel,
                    onReturn: {
                        appState = nil
                    },
                    onFinish: {
                        appState = .finishingTask
                    },
                    onCancel: {
                        appState = .finishingTask
                    },
                    pauseCount: $pauseCount
                ) // Convert to seconds
            } else {
                TimerNotSelectedView()
            }
        }
    }
}
