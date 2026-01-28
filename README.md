# DailyFocus 

<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-01-28 at 07 44 54" src="https://github.com/user-attachments/assets/3cca9324-ac9a-444c-962b-ede35e2adcb6" />
<img width="201" height="437" alt="Simulator Screenshot - iPhone 17 - 2026-01-28 at 07 44 07" src="https://github.com/user-attachments/assets/82218060-5f77-4a96-81d6-dabbb63e8436" />

Images of my app ^

⏱️ DailyFocus is a minimalist task management and productivity timer built with SwiftUI. It’s designed to help users prioritize their day and stay focused on one task at a time using an intuitive, gesture-based interface.

I started this project during my sophomore year of high school to explore custom animations, state management, and different frameworks in Swift.


DailyFocus is not yet a complete project, so stay tuned for future updates and releases!

✨ Features: 

- Priority-Based Sorting: Tasks are automatically organized by importance (High, Medium, Low).

- Custom Timer Engine: A precise countdown timer built using Timer.publish and Combine.

- Gesture-Based Interaction: * Double-Tap to pause your focus session.

- Interactive Overlays to resume work.

- Custom UI Components: Unique shapes and buttons designed to match the "Lexend" font aesthetic.

- Dynamic UI: Smooth spring animations and numeric transitions for a premium feel.

<br>

🛠️ Technical Implementation:

This app serves as a deep dive into modern iOS development:

- SwiftUI: 100% programmatic UI using GeometryReader and ZStack for complex layouts.

- State Management: Utilizes @State, @Binding, and @Environment for reactive data flow.

- Custom Shapes: Implementation of the Shape protocol for unique Play/Pause buttons.

- Animations: Use of .contentTransition(.numericText) and custom .spring() animations for tactile feedback.

<br>

🚀 Roadmap (What I'm Learning Next)
As I continue developing this project, I plan to implement:

- [ ] Data Persistence: Moving from @State to SwiftData or UserDefaults so tasks save after closing the app.

- [x] Swipe-to-Delete: Improving the UX of the task list.

- [ ] Haptic Feedback: Adding UIImpactFeedbackGenerator for a more physical feel when buttons are pressed.

- [ ] Other features: Checklist tasks, Pomodoro Technique,...etc

<br>

📱 Installation
Clone the repository: git clone https://github.com/[YourUsername]/DailyFocus.git

Open DailyFocus.xcodeproj in Xcode.

Ensure you have the Lexend font files added to your project (or update LexendTexts.swift to use system fonts).

Build and run on an iPhone Simulator or physical device.

<br>

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

Author: **Liam N.** *High School Student and Developer* [Github](https://github.com/your-username) | [Project Link](https://github.com/your-username/DailyFocus)
