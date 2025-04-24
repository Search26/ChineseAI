# Supabase Server-less Backend Guide  
Chinese-Learning iOS App (SwiftUI, iOS 16+)

## 1. Goals
• Secure user authentication (Google, Facebook, Apple, guest).  
• Track lessons & “Daily Dose” progress per user/day.  
• Sync data across devices with zero server maintenance.  
• Enforce privacy with Row Level Security (RLS).

---

## 2. Project Bootstrap

1. Create a project in `https://app.supabase.com`.  
2. Copy **Project URL** & **anon (public) key** → Xcode secret-store.  
3. Add `supabase-swift` via SPM:  
   ```
   https://github.com/supabase-community/supabase-swift
   ```

---

## 3. Auth & User Identification

### 3.1 Providers Enabled
| Provider  | Supabase Auth Setting             |
|-----------|-----------------------------------|
| Apple     | Bundle ID, services configured    |
| Google    | OAuth credentials JSON           |
| Facebook  | App ID + Secret                   |

### 3.2 Swift Sign-In Snippet
```swift
import Supabase
let supabase = SupabaseClient(supabaseURL: Secrets.url,
                              supabaseKey: Secrets.anonKey)

try await supabase.auth.signInWithProvider(.apple)   // .google / .facebook
```

### 3.3 User IDs
| Case        | Identifier                              | Where Stored                     |
|-------------|-----------------------------------------|----------------------------------|
| Auth user   | `supabase.auth.currentUser.id` (UUID)   | Keychain (`userId`), Supabase DB |
| Guest user  | `UUID().uuidString`                     | Keychain (`guestId`)             |

If a guest later signs up, migrate local rows:  
```sql
update lesson_progress
set user_id = :newId
where user_id = :oldGuestId;
```

---

## 4. Database Schema

### 4.1 `users`  (optional extra fields)
```sql
create table users (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamp default now()
);
```

### 4.2 `lesson_progress`
```sql
create extension if not exists "uuid-ossp";

create table lesson_progress (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  lesson_id text not null,            -- "dailyDose_2025-04-24"
  completed boolean default false,
  completed_at timestamp,
  score integer
);

-- Composite uniqueness: each user may have only one row per lesson
create unique index uniq_user_lesson on lesson_progress (user_id, lesson_id);
```

---

## 5. Row-Level Security

```sql
alter table users enable row level security;
alter table lesson_progress enable row level security;

-- Each user accesses only their rows
create policy "Users can view/update own rows"
on lesson_progress
for all
using (auth.uid() = user_id);  -- same for users table
```

---

## 6. Swift Data Model

```swift
struct LessonProgress: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let lessonId: String            // "dailyDose_YYYY-MM-DD"
    var completed: Bool
    var completedAt: Date?
    var score: Int?
}
```

---

## 7. CRUD Operations

### 7.1 Insert / Update (Complete Daily Dose)
```swift
let row: JSON = [
  "user_id": userId.uuidString,
  "lesson_id": "dailyDose_\(today)",
  "completed": true,
  "completed_at": Date()
]

try await supabase
  .from("lesson_progress")
  .upsert(row)        // handles insert or conflict-update
  .execute()
```

### 7.2 Fetch Streak / Calendar
```swift
let result = try await supabase
  .from("lesson_progress")
  .select()
  .eq("user_id", userId)
  .like("lesson_id", "dailyDose_%")
  .order("lesson_id", ascending: false)
  .execute()
```

---

## 8. Offline Strategy

1. Cache `LessonProgress` in CoreData.  
2. Mark rows with `needsSync = true` when offline.  
3. On `NWPathMonitor` → `.satisfied`, iterate unsynced rows and upsert to Supabase.  
4. Use `@AppStorage("userId")` for quick look-up.

---

## 9. Analytics Hook (Optional)

```swift
Analytics.logEvent("daily_dose_completed", parameters: [
  "user_id": userId.uuidString,
  "lesson_id": lessonId
])
```
Use the anonymized Supabase UUID; avoid sending auth tokens.

---

## 10. Example App Flow

1. Launch → check `supabase.auth.session`.  
2. If `nil`, show `AuthView`.  
3. Post-login: save `userId` to Keychain / `@AppStorage`.  
4. Call `DailyDoseService.generateIfNeeded()` (creates lessonId for today).  
5. On completion → `LessonProgressRepository.upsertComplete(for: today)`.  
6. HomeView shows streak by querying the table.  

---

## 11. Useful Links

- Supabase Swift SDK  
  https://github.com/supabase-community/supabase-swift  
- Row Level Security Docs  
  https://supabase.com/docs/guides/auth/row-level-security  
- Auth Provider Setup  
  https://supabase.com/docs/guides/auth/quickstarts

---

_This single document gives your team everything needed to run a 100 % server-less backend on Supabase while safely identifying users and tracking their Mandarin-learning progress._
