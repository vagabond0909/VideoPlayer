import SwiftUI

struct InfoView: View {
    let video: Video
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Description
            Text(video.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(video.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Metadata
            HStack {
                Text(video.genre)
                Text("•")
                Text("\(Int(video.duration / 60))hr \(Int(video.duration.truncatingRemainder(dividingBy: 60)))min")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    // Implement play from beginning
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
                    // Implement details action
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
    }
}

#Preview {
    InfoView(video: Video.sampleVideo)
} 