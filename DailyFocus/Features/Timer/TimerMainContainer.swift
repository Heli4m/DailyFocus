// Created by Liam Ngo on 13/2/26.
// Purpose: Primary container for timer.

import SwiftUI

struct TimerMainContainer: View {
    @Binding var appState: AppState?
    @Binding var selectedMinutes: Int
    @Binding var pauseCount: Int
    @Binding var timerModel: TimerViewModel
    @Binding var completionPages: TaskCompletePages?
    
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
                        completionPages = .summary
                    },
                    onCancel: {
                        appState = .finishingTask
                        completionPages = .summary
                    },
                    pauseCount: $pauseCount
                ) // Convert to seconds
            } else {
                TimerNotSelectedView()
            }
        }
    }
}
