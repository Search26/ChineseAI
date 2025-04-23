# ChineseAI – Architecture Rules & Conventions

> This document is the single source of truth for how we structure, name, test and ship code.
> All PRs must comply.

---

## 1. Layered Folder Structure

```
ChineseAI/
│
├─ Presentation/           ← SwiftUI views only (stateless + previews)
│   ├─ Home/
│   ├─ ChatTutor/
│   └─ Shared/
│
├─ Business/
│   ├─ AppState/           ← Centralised, Redux‑like observable state
│   ├─ Interactors/        ← Use‑case / application logic
│   └─ Services/           ← Non‑stateful helpers (Schedulers, Validators)
│
├─ Data/
│   ├─ Repositories/       ← Async CRUD façades (remote + local)
│   ├─ Persistence/        ← CoreData / SwiftData models
│   └─ Networking/         ← API clients, DTOs, HTTP layer
│
├─ Resources/              ← Assets, Localisable strings
├─ Configuration/          ← .swiftlint.yml, XcodeGen, Schemes
└─ Supporting/             ← App entry point, Launch arguments
```

Rules  
1. **No layer references Presentation ▸ Business ▸ Data (one‑way).**  
2. **Repositories exposed only to Interactors**, never to Views.  
3. **View models live in `Interactors/`** (not `Presentation/`). They mutate `AppState` and publish derived bindings.

---

## 2. Dependency Injection

| Concern | Technique | Guideline |
|---------|-----------|-----------|
| App‑wide state | `@EnvironmentObject var store: AppState` | Inject at `ChineseAIApp` root |
| Interactors ↔ Repositories | Initialiser injection | Provide protocols for unit tests |
| One‑off helpers | `@MainActor` singletons (e.g. `AudioPlayback`) | Keep tiny, stateless |
| Scoped values (per View) | `@StateObject` wrappers | Never leak outside view scope |

Example:

```swift
struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = HomeInteractor()
}
```

---

## 3. Swift Package / Module Boundaries

– If a folder passes **10+ Swift files _or_ 500 LOC**, extract into a local Swift Package.  
– Public API = protocols only; concrete types stay `internal`.  
– Target‐level dependencies must respect Presentation → Business → Data direction.

---

## 4. Coding Style & Linting

1. **SwiftLint running in CI; warnings == failures.**  
2. Use [SwiftFormat] locally (pre‑commit) for whitespace / imports.  
3. Follow the project‑wide Swift guidelines (English names, explicit types, ≤ 20 lines per function, SOLID).

Recommended SwiftLint rule overrides:

```yaml
identifier_name:
  min_length: 3
nesting:
  type_level: 2     # Avoid deep nesting
type_body_length:
  warning: 200
  error: 300
```

---

## 5. Continuous Integration

| Stage | Tool | Notes |
|-------|------|-------|
| Build & Test | `xcodebuild -scheme ChineseAI -destination 'platform=iOS Simulator,name=iPhone 15' test` | Fail on warnings |
| Coverage | `llvm-cov export` → Codecov | ≥ 80 % gate |
| Lint | `swiftlint --strict` | Terminates workflow on issues |
| Static Analysis | *SwiftDiagnostics* | Compile with `-warnings-as-errors` |
| Distribution | Fastlane TestFlight | Signed with App Store Connect API key |

CI runs on push & PR to `main`.

---

## 6. Unit & UI Testing

1. Each **Interactor** gets a test suite verifying side‑effects on `AppState`.  
2. **Repository** tests hit mock API / in‑memory DB.  
3. **View** tests via [ViewInspector]. No snapshot tests for now.  
4. Mandatory test target coverage: `Business` and `Data` layers.

---

## 7. Branch & PR Workflow

1. Feature branches: `feature/<ticket‑id>-short-desc`  
2. Conventional commits (`feat:`, `fix:`, `chore:`).  
3. Every PR must:  
   – pass CI ✔️  
   – update `CHANGELOG.md` under “Unreleased”  
   – include at least one test or justify none.

---

## 8. Versioning & Releases

– Semantic Versioning (`MAJOR.MINOR.PATCH`).  
– Tag release in Git once CI passes; Fastlane deploys TestFlight.  
– `main` is always shippable.

---

## 9. Security & Privacy

– Secrets stored in Xcode config files excluded from VCS.  
– Keychain for auth tokens.  
– All network calls force TLS 1.2+.  
– Crash & analytics opt‑in toggles in Settings.

---

**Keep this document updated** whenever architecture or tooling changes.
