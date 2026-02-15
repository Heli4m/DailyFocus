# DailyFocus ⏱️

<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-02-15 at 16 17 21" src="https://github.com/user-attachments/assets/ae312396-cc51-4e68-a750-8c11db3abd9d" />
<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-02-15 at 16 14 38" src="https://github.com/user-attachments/assets/7ffb1dbc-5f8a-4a2f-926f-8a19808b0a6d" />
<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-02-15 at 16 16 56" src="https://github.com/user-attachments/assets/8cbd3490-fd99-4de3-976c-19887dc1dfe1" />



Images of my app ^

⏱️ DailyFocus is a minimalist task management and productivity timer built with SwiftUI. It’s designed to help users prioritize their day and stay focused on one task at a time using an intuitive, gesture-based interface.

I started this project during my sophomore year of high school to explore custom animations, state management, and different frameworks in Swift.

DailyFocus is not yet a complete project, so stay tuned for future updates and releases!

✨ Features:

- Priority-Based Sorting: Automatically organizes tasks by High, Medium, and Low importance so the most critical work stays at the top.

- Persistent Storage: Uses UserDefaults and JSON encoding to make sure tasks actually save to the device and don't disappear when the app is closed.

- Advanced Timer Engine: A countdown system built with Combine that stays accurate even when switching between apps or locking the screen.

- Local Notifications: Integration with the iOS notification system to send a "Time's up!" alert the second the timer hits zero, even if the app isn't open.

- Tactile Haptic Feedback: Physical vibrations using AudioToolbox and UIImpactFeedbackGenerator that give a full alarm buzz when finishing a session and subtle "clicks" during interaction.

- Gesture-Based UI: Clean, button-less timer interface that uses a Double-Tap gesture to pause and resume work.

- Dynamic Animations: Custom .spring() motion and numeric transitions to make the UI feel bouncy and reactive rather than static.

<br>

🛠️ Technical Implementation

- SwiftUI: 100% programmatic layouts using GeometryReader and ZStacks for precise component positioning.

- Framework Integration: Real-world use of UserNotifications for background alerts and AudioServices for system haptics.

- Data Persistence: Implementation of Codable protocols to convert task data into JSON for local storage.

- Custom Drawing: Usage of the Shape protocol to create custom play/pause icons that match the rounded "Lexend" aesthetic.

- State Management: Heavy use of @State, @Binding, and @Environment to pass data smoothly between the task list and the timer.

<br>

### Technical Deep Dive: Choreographed Transitions
To make the app feel premium, I implemented a "Phase-Based" animation system for the end screen. Instead of views appearing at once, they are staggered using `DispatchQueue` to create a waterfall effect.

```swift
// Staggering the entrance of stat cards via a phase state
.onAppear {
    for i in 1...3 {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                transitionPhases = i
            }
            Haptics.trigger(.medium) // Tactile feedback for each card "landing"
        }
    }
}
```

Technical Deep Dive: The Odometer Effect
I built a custom "count-up" logic to animate integers. This transforms static data into a dynamic visual experience as the user sees their completion percentage climb in real-time.

```Swift
func countUp() {
    let duration: Double = 1.0
    let steps = completionPercentage
    let interval = duration / Double(steps)
    
    for i in 0...steps {
        DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * interval)) {
            self.animatedPercentage = i
            // Subtle haptic ticks every 5%
            if i % 5 == 0 { Haptics.trigger(.light) }
        }
    }
}
```

<br>

🚀 Roadmap (What I'm Learning Next)
As I continue developing this project, I plan to implement:

[x] Data Persistence: Implemented local storage using UserDefaults and JSON encoding.

[x] Swipe-to-Delete: Improving the UX of the task list.

[x] Haptic Feedback: Integrated the AudioToolbox framework to provide a high-intensity system buzz when the timer finishes.

[x] Background Notifications: Integrated the UserNotifications framework to schedule local alerts.

[x] UI Humanization: Polishing the interface with custom icons, staggered animations, and an odometer-style celebration screen.

[ ] Checklist Tasks: Adding a simple "To-Do" mode for tasks that don't require a deep-focus timer.

[ ] Countable Tasks: Implementing a counter system for repetitive tasks or habits that need to be tracked by quantity.

[ ] Statistics Dashboard: Building a GitHub-style contribution grid to visualize focus minutes and completed tasks over time.

[ ] Home Screen Widgets: Creating interactive widgets to check timer progress at a glance without opening the app.

<br>

📱 Installation
Clone the repository: git clone https://github.com/Heli4m/DailyFocus.git

Open DailyFocus.xcodeproj in Xcode.

Ensure you have the Lexend font files added to your project (or update LexendTexts.swift to use system fonts).

Build and run on an iPhone Simulator or physical device.

<br>

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

Author: Liam N. High School Student and Developer Github | Project Link
