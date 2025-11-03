# Japanese Walking App - Design Document

## 1. Overview

### 1.1 Concept
Japanese Walking is an interval walking training method that alternates between fast-paced and moderate-paced walking. This Flutter application will guide users through their walking sessions with a beautiful, minimalist Japanese-inspired interface.

### 1.2 Core Features
- Interval timer with audio/haptic feedback
- Session scheduling and reminders
- Progress tracking and statistics
- Customizable interval durations
- Japanese aesthetic design language

---

## 2. User Experience Design

### 2.1 Design Language
**Japanese Minimalism (Kanso - 簡素)**
- Clean, uncluttered interfaces
- Generous white space
- Subtle animations inspired by nature
- Color palette: Deep reds (#DC143C), blacks (#1A1A1A), whites (#FFFFFF), and soft grays
- Typography: Clean sans-serif for readability, possibly Noto Sans JP for Japanese characters

**Animation Philosophy**
- Smooth, purposeful transitions
- Nature-inspired movements (falling leaves, flowing water)
- Subtle micro-interactions that feel organic

### 2.2 Color Schemes
**Light Mode:**
- Background: #FAFAFA (Off-white)
- Primary: #DC143C (Crimson red - Japanese flag)
- Secondary: #2C2C2C (Deep charcoal)
- Accent: #FF6B6B (Coral red)
- Success/Complete: #4CAF50 (Japanese green - for completed walks)
- Text: #1A1A1A, #666666

**Dark Mode:**
- Background: #1A1A1A
- Primary: #FF4444
- Secondary: #ECECEC
- Accent: #FF8080
- Success/Complete: #66BB6A (Lighter green for dark mode)
- Text: #FFFFFF, #CCCCCC

---

## 3. User Flow (Användarflöde)

### 3.1 First Launch Experience

```
Splash Screen (2-3s)
    ↓
[Japanese Flag Animation]
- Circle expands from center
- Subtle fade-in effect
- Optional: Ripple effect
    ↓
Onboarding (3 screens, swipeable)
    ↓
Screen 1: Welcome
- "Welcome to Japanese Walking"
- Brief explanation of interval walking
- Beautiful illustration
    ↓
Screen 2: How It Works
- Fast interval (3 min default)
- Slow interval (3 min default)
- Visual representation
    ↓
Screen 3: Permissions
- Notification permission request
- Optional: Fitness tracking
    ↓
Main Dashboard
```

### 3.2 Main Application Flow

```
Main Dashboard
├── Start Walk (Large CTA button)
├── Schedule (Calendar icon)
├── Statistics (Graph icon)
└── Settings (Gear icon)

Start Walk Flow:
Main Dashboard → Pre-Walk Setup → Active Session → Session Complete → Statistics

Schedule Flow:
Main Dashboard → Schedule Screen → Add/Edit Schedule → Confirmation → Main Dashboard

Statistics Flow:
Main Dashboard → Statistics Screen → Detailed View → Main Dashboard

Settings Flow:
Main Dashboard → Settings → Edit → Save → Main Dashboard
```

### 3.3 Detailed Screen Flow

#### A. Splash Screen (2-3 seconds)
- Animated Japanese flag
- App name fade-in
- Smooth transition to onboarding or main screen

#### B. Onboarding (First-time users only)
- Swipeable 3-screen carousel
- Skip button in top-right
- Progress indicators at bottom
- "Get Started" on final screen

#### C. Main Dashboard
**Top Section:**
- Greeting based on time of day
- Today's scheduled walk (if any)
- Quick stats (weekly streak, total walks)

**Center Section:**
- Large circular "Start Walk" button
- Visual state: Ready / In Progress / Complete

**Bottom Navigation:**
- Home (Dashboard)
- Schedule (Calendar)
- Stats (Graph)
- Settings (Gear)

#### D. Pre-Walk Setup Screen
- Interval duration sliders
  - Fast interval: 1-10 min (default 3)
  - Slow interval: 1-10 min (default 3)
  - Number of cycles: 1-10 (default 5)
- Total estimated time display
- Voice guidance toggle
- Music integration toggle
- "Start Walking" button

#### E. Active Session Screen
**Minimalist full-screen timer:**
- Large circular progress indicator
- Current interval type (FAST / SLOW) in Japanese and English
  - 速い (Hayai) / Fast
  - ゆっくり (Yukkuri) / Slow
- Time remaining in current interval
- Current interval number (e.g., "3 of 5")
- Total session time elapsed
- Pause button (centered bottom)
- Stop button (small, top-right)

**Animations during session:**
- Circle fills/empties based on interval progress
- Color shifts: Red (fast) ↔ Blue (slow)
- Subtle background color transitions

#### F. Session Complete Screen
- Celebration animation (e.g., sakura petals falling)
- Session summary:
  - Total time
  - Intervals completed
  - Calories estimate (if fitness data available)
- Share button
- "Done" button to return to dashboard

#### G. Schedule Screen
- Calendar view (month)
- Scheduled walks highlighted (red border)
- Completed walks shown with green checkmark/background
- "Add Schedule" FAB (Floating Action Button)
- Tap date to add/edit/view schedule

**Add/Edit Schedule Dialog:**
- Time picker
- Days of week selector
- Notification toggle
- Save/Cancel buttons

#### H. Statistics Screen
- Weekly overview (bar chart)
- Monthly summary
- Total walks completed
- Total time walked
- Current streak
- Personal bests
- Scrollable list of past sessions

#### I. Settings Screen
**Categories:**
- Profile
  - Name
  - Avatar
  - Fitness goals
- Intervals
  - Default fast duration
  - Default slow duration
  - Default cycles
- Notifications
  - Reminder times
  - Sound/Vibration preferences
- Appearance
  - Dark/Light/System theme
  - Language (English/Japanese)
- Data & Privacy
  - Export data
  - Clear history
- About
  - Version
  - Credits
  - Terms & Privacy

---

## 4. Technical Architecture

### 4.1 Technology Stack
- **Framework:** Flutter 3.x (latest stable)
- **Language:** Dart 3.x
- **State Management:** Riverpod 2.x (recommended) or Provider
- **Local Storage:** Hive or Drift (SQLite)
- **Notifications:** flutter_local_notifications
- **Audio:** audioplayers or just_audio
- **Haptic Feedback:** vibration
- **Charts:** fl_chart
- **Date/Time:** intl package
- **Animations:** Flutter's built-in AnimationController + Lottie (optional)

### 4.2 Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── notification_service.dart
│   │   ├── audio_service.dart
│   │   └── haptic_service.dart
│   └── routing/
│       └── app_router.dart
├── features/
│   ├── splash/
│   │   ├── presentation/
│   │   │   └── splash_screen.dart
│   │   └── widgets/
│   │       └── flag_animation.dart
│   ├── onboarding/
│   │   ├── presentation/
│   │   │   └── onboarding_screen.dart
│   │   └── widgets/
│   │       ├── onboarding_page.dart
│   │       └── page_indicator.dart
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── greeting_header.dart
│   │       ├── start_button.dart
│   │       └── quick_stats.dart
│   ├── walking_session/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── walking_session.dart
│   │   │   │   └── interval_config.dart
│   │   │   └── repositories/
│   │   │       └── session_repository.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pre_walk_setup_screen.dart
│   │       ├── active_session_screen.dart
│   │       ├── session_complete_screen.dart
│   │       └── widgets/
│   │           ├── interval_timer.dart
│   │           ├── circular_progress.dart
│   │           └── session_controls.dart
│   ├── schedule/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   └── schedule_screen.dart
│   │   └── widgets/
│   │       ├── calendar_view.dart
│   │       └── schedule_dialog.dart
│   ├── statistics/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   └── statistics_screen.dart
│   │   └── widgets/
│   │       ├── stats_chart.dart
│   │       └── session_list.dart
│   └── settings/
│       ├── data/
│       ├── presentation/
│       │   └── settings_screen.dart
│       └── widgets/
│           └── settings_tile.dart
├── shared/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   └── loading_indicator.dart
│   └── providers/
│       ├── theme_provider.dart
│       └── settings_provider.dart
└── assets/
    ├── images/
    ├── animations/
    └── sounds/
        ├── interval_complete.mp3
        └── session_complete.mp3
```

### 4.3 Data Models

#### WalkingSession
```dart
class WalkingSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int fastIntervalDuration; // seconds
  final int slowIntervalDuration; // seconds
  final int completedCycles;
  final int totalCycles;
  final bool completed;
  final int? caloriesBurned;
}
```

#### IntervalConfig
```dart
class IntervalConfig {
  final int fastDuration; // minutes
  final int slowDuration; // minutes
  final int cycles;
  final bool voiceGuidance;
  final bool musicIntegration;
}
```

#### ScheduledWalk
```dart
class ScheduledWalk {
  final String id;
  final TimeOfDay time;
  final List<int> daysOfWeek; // 1-7 (Mon-Sun)
  final bool enabled;
  final IntervalConfig config;
}
```

### 4.4 State Management Approach (Riverpod)

**Providers Structure:**
```dart
// Session State
final sessionStateProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.read(sessionRepositoryProvider));
});

// Timer State
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

// Settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

// Schedule
final scheduleProvider = StateNotifierProvider<ScheduleNotifier, List<ScheduledWalk>>((ref) {
  return ScheduleNotifier(ref.read(scheduleRepositoryProvider));
});

// Statistics
final statsProvider = FutureProvider<Statistics>((ref) async {
  return ref.read(sessionRepositoryProvider).getStatistics();
});
```

### 4.5 Key Services

#### NotificationService
- Schedule notifications for walks
- Show notifications during intervals
- Handle notification actions

#### AudioService
- Play interval transition sounds
- Voice guidance for intervals
- Background audio handling

#### HapticService
- Vibration patterns for interval changes
- Tactile feedback for button presses

#### TimerService
- Accurate countdown timer
- Background timer handling
- State preservation

---

## 5. Implementation Phases

### Phase 1: Core Setup (Week 1)
- [ ] Project initialization
- [ ] Theme setup (colors, typography)
- [ ] Basic navigation structure
- [ ] Splash screen with animation
- [ ] Onboarding flow

### Phase 2: Timer & Session (Week 2)
- [ ] Interval configuration model
- [ ] Timer logic implementation
- [ ] Active session UI
- [ ] Session state management
- [ ] Audio/haptic feedback

### Phase 3: Data & Persistence (Week 3)
- [ ] Database setup (Hive/Drift)
- [ ] Session repository
- [ ] Save/load sessions
- [ ] Statistics calculation
- [ ] Statistics UI

### Phase 4: Scheduling (Week 4)
- [ ] Schedule data model
- [ ] Calendar UI
- [ ] Local notifications
- [ ] Schedule management

### Phase 5: Polish & Features (Week 5)
- [ ] Dark mode
- [ ] Settings screen
- [ ] Data export
- [ ] Animation refinements
- [ ] Performance optimization

### Phase 6: Testing & Release (Week 6)
- [ ] Unit tests
- [ ] Integration tests
- [ ] UI tests
- [ ] Bug fixes
- [ ] App store preparation

---

## 6. Animation Details

### 6.1 Splash Screen Animation
```
Duration: 2000ms
1. Flag circle scales from 0.0 to 1.0 (800ms, Curves.easeOutCubic)
2. App name fades in from 0.0 to 1.0 (600ms, Curves.easeIn, delay: 400ms)
3. Ripple effect expands (1000ms, Curves.easeOut, delay: 800ms)
4. Fade out entire screen (400ms, Curves.easeIn)
```

### 6.2 Session Complete Animation
```
- Sakura petals fall from top (3s loop)
- Success icon scales in with bounce
- Stats counter animates from 0 to final value
```

### 6.3 Interval Transition
```
- Color crossfade (1s)
- Progress circle reset with spring animation
- Text fade out/in (300ms)
- Haptic feedback pulse
```

---

## 7. Accessibility Considerations

- High contrast mode support
- Screen reader compatibility
- Voice guidance for visually impaired
- Large touch targets (minimum 48x48dp)
- Scalable text sizes
- Color-independent information display

---

## 8. Localization

**Supported Languages:**
- English (default)
- Japanese (日本語)

**Key Strings:**
- Interval types (Fast/Slow)
- UI labels
- Onboarding content
- Notifications

---

## 9. Performance Considerations

- Lazy loading for statistics
- Efficient timer implementation (avoid rebuilding entire tree)
- Image optimization
- Database indexing for queries
- Background task handling for timer

---

## 10. Future Enhancements

**Version 2.0:**
- Apple Health / Google Fit integration
- GPS tracking for outdoor walks
- Social features (share achievements)
- Custom interval patterns
- Music player integration
- Weather integration
- Challenges and achievements

**Version 3.0:**
- Apple Watch / Wear OS companion app
- Heart rate monitoring
- AI-powered recommendations
- Community features
- Premium subscription features

---

## 11. Design Assets Needed

- App icon (1024x1024)
- Splash screen Japanese flag illustration
- Onboarding illustrations (3)
- Empty state illustrations
- Success/celebration animations
- Sound effects:
  - Interval start
  - Interval end
  - Session complete
- Navigation icons

---

## 12. Development Guidelines

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Comment complex logic
- Keep widgets small and focused
- Extract reusable components

### Git Workflow
- Main branch: stable releases
- Develop branch: active development
- Feature branches: feature/*
- Commit messages: conventional commits

### Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows
- Aim for >80% coverage

---

## 13. Success Metrics

**User Engagement:**
- Daily active users
- Session completion rate
- Average sessions per week
- User retention (7-day, 30-day)

**App Performance:**
- App launch time < 2s
- Smooth 60fps animations
- Battery usage < 5% per session
- Low crash rate < 0.1%

---

## Summary

This Japanese Walking app combines beautiful Japanese-inspired design with practical interval training functionality. The minimalist interface keeps users focused on their walking sessions, while the comprehensive scheduling and statistics features help them build a consistent walking habit.

The phased implementation approach allows for iterative development and testing, ensuring a polished final product. The architecture is scalable for future enhancements while maintaining clean, maintainable code.

Let's build something beautiful! 🚶‍♂️🇯🇵
