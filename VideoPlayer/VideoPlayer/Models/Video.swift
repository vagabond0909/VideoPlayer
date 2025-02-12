import Foundation

struct Video: Identifiable {
    let id = UUID()
    let title: String
    let episodeName: String
    let description: String
    let thumbnailURL: URL
    let videoURL: URL
    let duration: TimeInterval
    let recommendations: [Video]
    let releaseDate: Date
    let rating: String
    let genre: String
    
    // Static sample data
    static let sampleVideo = Video(
        title: "Freedom Day",
        episodeName: "Silo",
        description: "In this groundbreaking episode, the inhabitants of the silo face unprecedented challenges as they question the very foundations of their underground society. As secrets begin to unravel, the true meaning of Freedom Day takes on a whole new significance.",
        thumbnailURL: URL(string: "https://example.com/thumbnail.jpg")!,
        // Use a valid sample video URL - replace with your actual video URL
        videoURL: Bundle.main.url(forResource: "sample", withExtension: "mp4") ?? URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
        duration: 2400, // 40 minutes
        recommendations: [],
        releaseDate: Date(),
        rating: "TV-MA",
        genre: "Sci-Fi & Fantasy"
    )
} 