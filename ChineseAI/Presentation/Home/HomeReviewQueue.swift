import SwiftUI

@available(iOS 16.0, *)
struct HomeReviewQueue: View {
    var dueCount: Int = 12
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Cards due today")
                    .font(.rubik(size: 15, weight: .medium))
                    .foregroundColor(.homeText)
                Text("Complete your daily review")
                    .font(.rubik(size: 13))
                    .foregroundColor(.homeGray)
            }
            Spacer()
            Button(action: {}) {
                Text("Start Review")
                    .font(.rubik(size: 15, weight: .bold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            if dueCount > 0 {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 24, height: 24)
                    Text("\(dueCount)")
                        .font(.rubik(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: 8, y: -24)
            }
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
