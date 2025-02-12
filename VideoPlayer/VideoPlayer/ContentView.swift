//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Mohit JyotiKumar on 12/02/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var viewModel = VideoPlayerViewModel(video: Video.sampleVideo)
    @State private var showControls = true
    @State private var showInfo = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.isFullScreenPlayer {
                    // Full Screen Player
                    VideoPlayer(player: viewModel.player)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showControls.toggle()
                                if showControls && viewModel.isPlaying {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            if viewModel.isPlaying {
                                                showControls = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .overlay {
                            if showControls {
                                // Full Screen Controls
                                VStack {
                                    // Top bar
                                    HStack {
                                        Button {
                                            withAnimation(.spring()) {
                                                viewModel.isFullScreenPlayer = false
                                                viewModel.isPlaying = false
                                                viewModel.player?.pause()
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .padding()
                                        }
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                    // Center Controls
                                    HStack(spacing: 60) {
                                        Button(action: { viewModel.skipBackward() }) {
                                            Image(systemName: "gobackward.10")
                                                .font(.title)
                                        }
                                        
                                        Button(action: { viewModel.togglePlayPause() }) {
                                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                                .font(.system(size: 45))
                                        }
                                        
                                        Button(action: { viewModel.skipForward() }) {
                                            Image(systemName: "goforward.10")
                                                .font(.title)
                                        }
                                    }
                                    .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    // Bottom Controls
                                    VStack(spacing: 12) {
                                        // Playback Controls
                                        CustomSeekBar(value: $viewModel.currentTime, duration: viewModel.duration, viewModel: viewModel)
                                            .padding(.horizontal)
                                        
                                        HStack {
                                            // Time labels
                                            Text(viewModel.formatTime(viewModel.currentTime))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            // Playback Speed Menu
                                            Menu {
                                                Button("0.5x") { viewModel.setPlaybackSpeed(0.5) }
                                                Button("1.0x") { viewModel.setPlaybackSpeed(1.0) }
                                                Button("1.5x") { viewModel.setPlaybackSpeed(1.5) }
                                                Button("2.0x") { viewModel.setPlaybackSpeed(2.0) }
                                            } label: {
                                                Image(systemName: "ellipsis.circle")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.bottom)
                                }
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.black.opacity(0.8), .clear, .black.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                } else {
                    // Regular Player View (existing code)
                    VStack(spacing: 0) {
                        // Video Player Container
                        VideoPlayer(player: viewModel.player)
                            .frame(height: viewModel.showingInSight || showInfo ? geometry.size.height * 0.4 : geometry.size.height)
                            .overlay {
                                if showControls {
                                    PlayerControlsOverlay(viewModel: viewModel, showInfo: $showInfo)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    if !viewModel.showingInSight && !showInfo {
                                        if viewModel.isPlaying {
                                            viewModel.continueWatching()
                                        } else {
                                            showControls.toggle()
                                        }
                                        
                                        // Auto-hide controls after 3 seconds if video is playing
                                        if showControls && viewModel.isPlaying {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                withAnimation {
                                                    if viewModel.isPlaying {
                                                        showControls = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        
                        // InSight View
                        if viewModel.showingInSight {
                            InSightView(video: viewModel.video, isShowing: $viewModel.showingInSight)
                                .transition(.move(edge: .bottom))
                        }
                        
                        // Info View
                        if showInfo {
                            VStack(alignment: .leading, spacing: 16) {
                                // Title
                                Text(viewModel.video.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                // Description
                                Text(viewModel.video.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                // Metadata
                                HStack {
                                    Text(viewModel.video.genre)
                                    if !viewModel.formattedDuration().isEmpty {
                                        Text("•")
                                        Text(viewModel.formattedDuration())
                                    }
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                
                                // Action Buttons
                                HStack(spacing: 12) {
                                    Button {
                                        viewModel.playFromBeginning()
                                        showInfo = false
                                    } label: {
                                        HStack {
                                            Image(systemName: "play.fill")
                                            Text("From Beginning")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(8)
                                    }
                                    
                                    Button {
                                        viewModel.showDetails()
                                    } label: {
                                        Text("Details")
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(8)
                                    }
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            }
                            .padding()
                            .background(Color.black)
                            .transition(.move(edge: .bottom))
                        }
                    }
                }
            }
            .statusBar(hidden: true)
        }
    }
}

// Extracted Controls Overlay View
struct PlayerControlsOverlay: View {
    @ObservedObject var viewModel: VideoPlayerViewModel
    @Binding var showInfo: Bool
    
    var body: some View {
        VStack {
            // Top Controls
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .font(.title3)
                }
                
                Button(action: { viewModel.togglePictureInPicture() }) {
                    Image(systemName: "rectangle.inset.filled")
                        .font(.title3)
                }
                
                Button(action: { viewModel.toggleFullScreen() }) {
                    Image(systemName: "tv")
                        .font(.title3)
                }
                
                Spacer()
                
                Button(action: { viewModel.toggleMute() }) {
                    Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.title3)
                }
            }
            .padding()
            
            Spacer()
            
            // Center Controls
            HStack(spacing: 60) {
                Button(action: { viewModel.skipBackward() }) {
                    Image(systemName: "gobackward.10")
                        .font(.title)
                }
                
                Button(action: { viewModel.togglePlayPause() }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 45))
                }
                
                Button(action: { viewModel.skipForward() }) {
                    Image(systemName: "goforward.10")
                        .font(.title)
                }
            }
            
            Spacer()
            
            // Bottom Controls
            VStack(spacing: 12) {
                // Progress Bar
                CustomSeekBar(value: $viewModel.currentTime, duration: viewModel.duration, viewModel: viewModel)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button {
                        withAnimation(.spring()) {
                            showInfo.toggle()
                            if showInfo {
                                viewModel.hideInsight()
                            }
                        }
                    } label: {
                        Text("Info")
                            .font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                    }
                    
                    Button {
                        withAnimation(.spring()) {
                            viewModel.showingInSight.toggle()
                            if viewModel.showingInSight {
                                showInfo = false
                            }
                        }
                    } label: {
                        Text("InSight")
                            .font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                    }
                    
                    Button("Continue Watching") {
                        viewModel.continueWatching()
                    }
                    
                    Spacer()
                    
                    // More options button without action
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                }
                .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .foregroundColor(.white)
    }
}

struct CustomSeekBar: View {
    @Binding var value: Double
    let duration: Double
    @ObservedObject var viewModel: VideoPlayerViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            if duration > 0 {
                Slider(value: $value, in: 0...max(duration, 0.01))
                    .accentColor(.white)
                
                HStack {
                    Text(viewModel.formatTime(value))
                    Spacer()
                    Text("-\(viewModel.formatTime(max(duration - value, 0)))")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            } else {
                // Show loading state
                HStack {
                    Text("--:--")
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.7)
                    Spacer()
                    Text("--:--")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
}
