import SwiftUI

struct DailyDoseItem: Identifiable {
    let id = UUID()
    let hanzi: String
    let pinyin: String
    let translation: String
    let buttonTitle: String
    let buttonColor: Color
}

@available(iOS 16.0, *)
struct HomeDailyDose: View {
    let items: [DailyDoseItem] = [
        DailyDoseItem(hanzi: "你好", pinyin: "nǐ hǎo", translation: "Hello", buttonTitle: "Listen", buttonColor: .blue),
        DailyDoseItem(hanzi: "谢谢", pinyin: "xiè xie", translation: "Thank you", buttonTitle: "Listen", buttonColor: .blue)
    ]
    var body: some View {
        HStack(spacing: 12) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.hanzi)
                        .font(.rubik(size: 28, weight: .bold))
                        .foregroundColor(.homeText)
                    Text(item.pinyin)
                        .font(.rubik(size: 14, weight: .medium))
                        .foregroundColor(.homeGray)
                    Text(item.translation)
                        .font(.rubik(size: 13))
                        .foregroundColor(.homeGray)
                    Spacer(minLength: 4)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text(item.buttonTitle)
                        }
                        .font(.rubik(size: 13, weight: .medium))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(item.buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(Color.homeBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.homeBorder, lineWidth: 1)
                )
            }
        }
    }
}
