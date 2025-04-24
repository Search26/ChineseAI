import SwiftUI

@available(iOS 16.0, *)
struct HomeProfileRow: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.homePrimary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Hello, Sarah")
                    .font(.rubik(size: 18, weight: .bold))
                    .foregroundColor(.homeText)
                HStack(spacing: 4) {
                    Text("Day 45")
                        .font(.rubik(size: 13, weight: .medium))
                        .foregroundColor(.homeGray)
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 13))
                }
            }
            Spacer()
            Image(systemName: "bell")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.homeGray)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}
