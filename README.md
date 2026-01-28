# DailyFocus 

<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-01-28 at 07 44 54" src="https://github.com/user-attachments/assets/3cca9324-ac9a-444c-962b-ede35e2adcb6" />
<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-01-28 at 07 44 07" src="https://github.com/user-attachments/assets/82218060-5f77-4a96-81d6-dabbb63e8436" />

Images of my app ^

⏱️ DailyFocus is a minimalist task management and productivity timer built with SwiftUI. It’s designed to help users prioritize their day and stay focused on one task at a time using an intuitive, gesture-based interface.

I started this project during my sophomore year of high school to explore custom animations, state management, and different frameworks in Swift.

DailyFocus is not yet a complete project, so stay tuned for future updates and releases!

✨ Features:

- Priority-Based Sorting: Automatically organizes tasks by High, Medium, and Low importance so the most critical work stays at the top.

- Persistent Storage: Uses UserDefaults and JSON encoding to make sure tasks actually save to the device and don't disappear when the app is closed.

- Advanced Timer Engine: A countdown system built with Combine that stays accurate even when switching between apps or locking the screen.

- Local Notifications: Integration with the iOS notification system to send a "Time's up!" alert the second the timer hits zero, even if the app isn't open.

- Tactile Haptic Feedback: Physical vibrations using AudioToolbox that give a full alarm buzz when finishing a session.

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

🚀 Roadmap (What I'm Learning Next)
As I continue developing this project, I plan to implement:

- [x] Data Persistence: Implemented local storage using UserDefaults and JSON encoding.

- [x] Swipe-to-Delete: Improving the UX of the task list.

- [x] Haptic Feedback: Integrated the AudioToolbox framework to provide a high-intensity system buzz when the timer finishes.

- [x] Background Notifications: Integrated the UserNotifications framework to schedule local alerts, ensuring the "Time's Up" alarm triggers even if the app is closed or the screen is locked.

- [ ] Checklist Tasks: Adding a simple "To-Do" mode for tasks that don't require a deep-focus timer.

- [ ] Countable Tasks: Implementing a counter system for repetitive tasks or habits that need to be tracked by quantity.

- [ ] Statistics Dashboard: Building a GitHub-style contribution grid to visualize focus minutes and completed tasks over time.

- [ ] Home Screen Widgets: Creating interactive widgets to check timer progress at a glance without opening the app.

- [ ] UI Humanization: Polishing the interface with custom icons, warmer color palettes, and balanced layouts to make the app feel more approachable and less "robotic."

<br>

📱 Installation
Clone the repository: git clone https://github.com/[YourUsername]/DailyFocus.git

Open DailyFocus.xcodeproj in Xcode.

Ensure you have the Lexend font files added to your project (or update LexendTexts.swift to use system fonts).

Build and run on an iPhone Simulator or physical device.

<br>

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

Author: **Liam N.** *High School Student and Developer* [Github](https://github.com/Heli4m) | [Project Link](https://github.com/Heli4m/DailyFocus)
