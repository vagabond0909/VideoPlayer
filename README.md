# iOS Video Player

A custom video player implementation inspired by the Apple TV iOS app, built using SwiftUI and AVKit.

## Features

- **Video Playback Controls**
  - Play/Pause functionality
  - 10-second forward/backward skip
  - Seek bar with time indicators
  - Volume control
  - Playback speed control (0.5x to 2.0x)

- **Smart Controls**
  - Auto-hiding controls during playback
  - Tap to show/hide controls
  - Automatic full-screen mode on play
  - Picture-in-Picture support (ready for implementation)

- **Information Display**
  - Video title and episode name
  - Duration and progress
  - Custom Info panel with video details
  - InSight feature for scene-specific information

- **User Interface**
  - Portrait-oriented player screen
  - Responsive design for different screen sizes
  - Smooth transitions and animations
  - Dark mode optimized

- **Additional Features**
  - Continue Watching functionality
  - Play from Beginning option
  - Details view support
  - Custom seek bar with loading state

## Setup Instructions

1. **Requirements**
   - Xcode 15.0 or later
   - iOS 16.0 or later
   - Swift 5.9 or later

2. **Installation**
   ```bash
   git clone [repository-url]
   cd VideoPlayer
   open VideoPlayer.xcodeproj
   ```

3. **Video Source Configuration**
   - Add your video files to the project's assets
   - Update the `Video.swift` model's `sampleVideo` with your video URL
   - Supports both local and remote video URLs

## Project Structure

- **Models**
  - `Video.swift`: Data model for video content

- **ViewModels**
  - `VideoPlayerViewModel.swift`: Manages video playback and state

- **Views**
  - `ContentView.swift`: Main player view
  - `InfoView.swift`: Video information panel
  - `InSightView.swift`: Scene-specific information
  - Custom components for controls and seek bar

## Implementation Notes

- Built using MVVM architecture
- Uses SwiftUI for UI components
- Leverages AVKit for video playback
- Implements KVO for video player state management
- Handles various video states (loading, playing, paused)
- Manages memory efficiently with proper cleanup

## Usage

The player supports various gestures and interactions:
- Tap video to toggle controls
- Tap while playing to enter full-screen mode
- Use the seek bar to navigate through the video
- Access additional information through Info and InSight buttons
- Control playback speed through the options menu

## Known Limitations

- Picture-in-Picture functionality needs implementation
- Details view implementation pending
- Currently supports single video playback

## Future Enhancements

- Playlist support
- Custom video thumbnails
- Advanced playback settings
- Subtitle support
- Chromecast integration
- Multiple audio track support
