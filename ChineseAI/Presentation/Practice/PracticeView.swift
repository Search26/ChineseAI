import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct PracticeView: View {
    @State private var grammarInput: String = ""
    @State private var grammarResult: GrammarAnalysis? = nil
    @State private var image: UIImage? = nil
    @State private var showPhotoPicker = false
    @State private var reviewResult: String? = nil
    @State private var streak: Int = 7
    @State private var xp: Int = 1240
    @State private var cefr: String = "B1"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Pronunciation Widget (simulates scoring)
                PronunciationWidget(
                    chinese: "你好，我是中国人。",
                    score: Int.random(in: 60...100),
                    onMicTap: {
                        // Simulate new score on tap
                        // In real app, start AVAudioRecorder & Whisper
                    }
                )
                // Grammar Helper Widget (simulates analysis)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Grammar Helper")
                        .font(.rubik(size: 15, weight: .bold))
                    TextField("Paste your sentence here...", text: $grammarInput)
                        .font(.rubik(size: 14))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Button("Analyze") {
                        // Simulate grammar analysis
                        grammarResult = GrammarAnalysis(literal: "I am going to the store", natural: "I'm heading to the store")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(grammarInput.isEmpty)
                    if let result = grammarResult {
                        GrammarWidget(analysis: result)
                    }
                }
                // Image to Vocab Widget (uses PhotosPicker)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Image to Vocabulary")
                        .font(.rubik(size: 15, weight: .bold))
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.homeBorder, lineWidth: 1)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        VStack {
                            if let img = image {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.homeGray)
                                Text("Tap to add photo")
                                    .font(.rubik(size: 13))
                                    .foregroundColor(.homeGray)
                            }
                        }
                        .padding(32)
                    }
                    .frame(height: 140)
                    .onTapGesture {
                        showPhotoPicker = true
                    }
                    .photosPicker(isPresented: $showPhotoPicker, selection: .constant(nil), matching: .images, photoLibrary: .shared())
                }
                // Review Queue Widget (simulates grading)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Review Queue")
                            .font(.rubik(size: 15, weight: .bold))
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.15))
                                .frame(height: 24)
                            Text("12 cards")
                                .font(.rubik(size: 13, weight: .bold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                        }
                        .fixedSize()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("你好")
                            .font(.rubik(size: 16, weight: .bold))
                        HStack(spacing: 8) {
                            Button(action: { reviewResult = "Hard" }) {
                                Text("Hard")
                                    .font(.rubik(size: 13, weight: .bold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 18)
                                    .background(Color.red.opacity(0.12))
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            Button(action: { reviewResult = "Easy" }) {
                                Text("Easy")
                                    .font(.rubik(size: 13, weight: .bold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 18)
                                    .background(Color.green.opacity(0.12))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                            }
                        }
                        if let result = reviewResult {
                            Text("You selected: \(result)")
                                .font(.rubik(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                }
                // Progress Widget (can increment streak/xp for demo)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.rubik(size: 15, weight: .bold))
                    HStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Current Streak")
                                .font(.rubik(size: 12))
                                .foregroundColor(.homeGray)
                            HStack {
                                Text("\(streak) days")
                                    .font(.rubik(size: 15, weight: .bold))
                                Button("+") { streak += 1 }
                                    .font(.rubik(size: 13, weight: .bold))
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Total XP")
                                .font(.rubik(size: 12))
                                .foregroundColor(.homeGray)
                            HStack {
                                Text("\(xp)")
                                    .font(.rubik(size: 15, weight: .bold))
                                Button("+") { xp += 10 }
                                    .font(.rubik(size: 13, weight: .bold))
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("CEFR Level")
                                .font(.rubik(size: 12))
                                .foregroundColor(.homeGray)
                            Text(cefr)
                                .font(.rubik(size: 15, weight: .bold))
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("Practice")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    PracticeView()
}
