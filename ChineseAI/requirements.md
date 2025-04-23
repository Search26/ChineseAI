


Chinese‑Learning AI App – Product & Technical Requirements
1. Overview
An iPhone app that helps beginners → intermediate learners master Mandarin through AI‑generated content, adaptive practice, and conversational tutoring.
2. Tech Stack
| Layer | Choice | Notes | |-------|--------|-------| | UI | SwiftUI (iOS 16+) | Declarative views, navigation stack, modifiers | | State | Combine + @StateObject / @EnvironmentObject | Reactive data flow | | DB | CoreData + CloudKit sync (free) | Flashcards, chat history, progress | | AI | • OpenAI gpt‑3.5‑turbo (LLM) • Whisper‑cpp locally (STT) • Google WaveNet TTS (free tier) | Replaceable via Llama‑3 local / other providers | | Networking | URLSession + async‑await | Retry, exponential back‑off | | Auth | FirebaseAuth (Google, Facebook) + Sign in with Apple (AuthenticationServices) | Unified AuthManager | | Analytics | Firebase Analytics (free) | Track retention, funnel | | Image | Core ML MobileNetV2 (on‑device) | Object → vocab |
3. Global UX Principles
• One‑hand, thumb‑reachable UI.
• All Mandarin text tappable to reveal pinyin.
• Dark Mode & Dynamic Type.
• Haptics on success/failure.
• Progress ring on top‑level nav to reinforce streaks.
4. Functional Requirements
4.1 Onboarding & Authentication
| Item | Details | |------|---------| | User Story | As a first‑time user, I pick Google/Facebook/Apple to create an account and see a brief placement test. | | Logic | 1. AuthViewModel.signIn(provider) 2. On success → fetch or create UserProfile in CloudKit 3. If new, push PlacementTestView. | | UI/UX | • Full‑screen pager: choose provider. • Branded buttons (SignInWithAppleButton, GIDSignInButton, FBLoginButton). • Show skeleton loader during network call. |
4.2 Home Dashboard
| Item | Details | |------|---------| | User Story | I open the app and instantly see my Daily Dose cards, streak, and quick actions. | | Logic | HomeViewModel fetches DailyDose & ProgressSummary concurrently via async let. | | UI | • Top progress ring. • Horizontal ScrollView of card previews. • 3 large square buttons: “Chat Tutor”, “Practice”, “Grammar Help”. |
4.3 Daily Dose Flashcards
| Description | Auto‑generated set of 5–10 cards each morning. | | Data Flow | 1. Scheduler triggers 05:00 local. 2. Call LLM with user level → JSON array [word, pinyin, sentence]. 3. Cache in CoreData. | | UI | Swipeable stack (TabView(.page)). Front = character & image; tap to flip → pinyin, translation, audio play button. | | UX Detail | • Show completion confetti on last card. • Long press → “Add to Review Deck”. |
4.4 Interactive Chat Tutor
| Logic | 1. ChatInputView supports voice mic & text. 2. If voice, run Whisper locally → Chinese text. 3. Append to messages; send reduced context to LLM. 4. Receive reply → synthesize TTS async; stream text in. | | UI | WhatsApp‑style bubbles; bubble tap = pinyin overlay. | | Tutor Modes | Immersion (Chinese only) / Mixed / English. Toggle on top bar. |
4.5 Pronunciation Practice
| Flow | 1. Display target sentence w/ play button (TTS). 2. User taps record; capture AVAudioRecorder. 3. Run Whisper; compare tone marks (pitch contour) vs expected. 4. Score 0–100; highlight syllables off‑tone. | | UI | Circular record button, progress waveform, bar chart result. | | UX | Haptic feedback for ≥ 80 score. Retry button. |
4.6 Grammar Helper
| Logic | 1. User pastes / scans sentence. 2. LLM returns JSON: literal, natural, grammar_points, examples. 3. Render sections in List; expandable grammar cards. | | UI | Split “literal vs natural” with color tags. |
4.7 Image ➜ Vocab
| Flow | 1. CameraView → still image. 2. Core ML detects object label. 3. Call LLM: “Give Chinese word, pinyin, sentence.” 4. Offer “Save to Deck”. | | UI | AR overlay of label in Chinese. |
4.8 Review Scheduler (Spaced Repetition)
| Algorithm | SM‑2 (Anki). Store easeFactor, interval, dueDate per card. | | UI | “Review” tab shows count‑badge; cards in queue same layout as Daily Dose but with self‑graded buttons (Fail, Hard, Good, Easy). |
4.9 Profile & Progress
| Content | • Streak days, XP, CEFR estimate. • Graph of last 30 days XP. | | UI | Charts framework line + bar blend. |
4.10 Settings & Subscription
| Items | • Voice engine select (Google / System). • Data export. • Purchase Pro (StoreKit 2). | | UX | Use Form grouped style. |
5. Non‑Functional
• Launch ≤ 2 s cold.
• Offline: flashcards, review, chat history available; AI calls queue until online.
• Accessibility: VoiceOver labels for every Chinese character (speak pinyin).
• Privacy: Only crash logs & analytics; user audio stays on device unless opt‑in.
6. Security & Compliance
• OAuth tokens stored in Keychain.
• App Privacy labels per Apple guidelines.
• COPPA‑friendly; 13+ age gate.
7. Open‑Source Libraries
| Purpose | Library | License | |---------|---------|---------| | Google Sign‑In | GoogleSignInSwift | Apache 2 | | Facebook | facebook-ios-sdk | MIT | | TTS | AudioKit (for playback) | MIT | | Charts | Swift‑Charts (Apple) | – |
8. Milestones
Core Auth + Onboarding (Week 1)
Home + Daily Dose (Week 2)
Chat Tutor MVP (Week 3‑4)
Pronunciation & Grammar Helper (Week 5‑6)
Polishing, TestFlight beta (Week 7)
App Store submission (Week 8)


