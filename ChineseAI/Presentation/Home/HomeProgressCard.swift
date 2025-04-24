import SwiftUI

@available(iOS 16.0, *)
struct HomeProgressCard: View {
    var progress: Double = 0.8
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(.rubik(size: 15, weight: .medium))
                    .foregroundColor(.homeText)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.rubik(size: 15, weight: .medium))
                    .foregroundColor(.homePrimary)
            }
            ProgressView(value: progress)
                .accentColor(.homePrimary)
                .frame(height: 8)
                .background(Color.homeBorder)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(16)
        .background(Color.homeBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.homeBorder, lineWidth: 1)
        )
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 2, x: 0, y: 1)
    }
}
