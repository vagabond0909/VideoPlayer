import SwiftUI

struct InSightView: View {
    let video: Video
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text("Inside This Scene")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Description
            Text("When available, InSight will show you information about the actors or music in a scene.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .font(.body)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
} 