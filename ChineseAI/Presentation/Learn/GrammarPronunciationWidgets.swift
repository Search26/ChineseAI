import SwiftUI

struct GrammarAnalysis: Identifiable {
    let id = UUID()
    let literal: String
    let natural: String
}

@available(iOS 16.0, *)
struct GrammarWidget: View {
    let analysis: GrammarAnalysis
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "text.book.closed.fill")
                    .foregroundColor(.blue)
                Text("Grammar Analysis")
                    .font(.rubik(size: 15, weight: .bold))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Literal Translation")
                    .font(.rubik(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                Text(analysis.literal)
                    .font(.rubik(size: 14))
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Text("Natural Translation")
                    .font(.rubik(size: 13, weight: .medium))
                    .foregroundColor(.blue)
                Text(analysis.natural)
                    .font(.rubik(size: 14))
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.homeBorder, lineWidth: 1)
        )
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.05), radius: 2, x: 0, y: 1)
    }
}

@available(iOS 16.0, *)
struct PronunciationWidget: View {
    let chinese: String
    let score: Int
    var onMicTap: () -> Void = {}
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Pronunciation Practice")
                    .font(.rubik(size: 15, weight: .medium))
                Spacer()
                Button(action: onMicTap) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.blue)
                }
            }
            Text(chinese)
                .font(.rubik(size: 18, weight: .bold))
            HStack(spacing: 12) {
                Button(action: onMicTap) {
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Score")
                        .font(.rubik(size: 13))
                        .foregroundColor(.gray)
                    HStack(spacing: 4) {
                        Text("\(score)/100")
                            .font(.rubik(size: 15, weight: .bold))
                        ProgressView(value: Double(score)/100)
                            .accentColor(.green)
                            .frame(width: 80)
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.homeBorder, lineWidth: 1)
        )
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.05), radius: 2, x: 0, y: 1)
    }
}
