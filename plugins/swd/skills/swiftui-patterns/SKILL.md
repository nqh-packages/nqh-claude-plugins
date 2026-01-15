---
name: swiftui-patterns
description: Modern SwiftUI patterns for iOS 26+/macOS 26+ including Liquid Glass, @Observable, view composition, animations, and preview-driven development. Use when building SwiftUI views, debugging UI issues, or implementing iOS 26 features.
version: 1.0.0
author: nqh
triggers:
  - swiftui
  - liquid glass
  - observable
  - view composition
  - swiftui animation
  - swiftui preview
  - ios 26
  - macos 26
  - view not updating
  - swiftui state
  - binding
---

# SwiftUI Patterns (iOS 26+)

Modern SwiftUI patterns with @Observable, Liquid Glass, and preview-driven development.

## Core Principles

| Principle | Value |
|-----------|-------|
| State ownership | Views own @State, share via @Bindable |
| Observation | @Observable replaces ObservableObject |
| Composition | Small, focused views composed together |
| Preview-first | Iterate in Preview 2-5x before running |

## @Observable (NOT ObservableObject)

```swift
// ✅ MODERN: @Observable
@Observable
final class UserModel {
    var name: String = ""
    var email: String = ""

    var isValid: Bool {
        !name.isEmpty && email.contains("@")
    }
}

// ❌ LEGACY: ObservableObject
class UserViewModel: ObservableObject {
    @Published var name: String = ""
}
```

### Usage in Views

```swift
struct ProfileView: View {
    @State private var model = UserModel()

    var body: some View {
        Form {
            TextField("Name", text: $model.name)
            TextField("Email", text: $model.email)

            Button("Save") { save() }
                .disabled(!model.isValid)
        }
    }
}
```

### Sharing State

```swift
// Parent owns state
struct ParentView: View {
    @State private var model = UserModel()

    var body: some View {
        ChildView(model: model)
    }
}

// Child receives binding
struct ChildView: View {
    @Bindable var model: UserModel

    var body: some View {
        TextField("Name", text: $model.name)
    }
}
```

## Liquid Glass (iOS 26+)

```swift
// Glass material background
struct GlassCard: View {
    var body: some View {
        VStack {
            Text("Content")
        }
        .padding()
        .glassBackgroundEffect()
    }
}

// Glass button style
Button("Action") { }
    .buttonStyle(.glass)

// Navigation with glass
NavigationStack {
    List { }
        .navigationTitle("Items")
}
.glassNavigationBarBackground()
```

## View Composition

### Atomic Design

| Level | Size | Example |
|-------|------|---------|
| Atom | ≤50 LOC | Button, TextField wrapper |
| Molecule | ≤100 LOC | FormField (label + input + error) |
| Organism | ≤200 LOC | LoginForm (molecules + logic) |
| Page | ≤200 LOC | LoginView (orchestrates organisms) |

```swift
// Atom
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(.borderedProminent)
    }
}

// Molecule
struct FormField: View {
    let label: String
    @Binding var text: String
    let error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption)
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
            if let error {
                Text(error)
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
        }
    }
}
```

## Preview-Driven Development

```swift
#Preview("Default") {
    ProfileView()
}

#Preview("With Data") {
    let model = UserModel()
    model.name = "Alice"
    model.email = "alice@example.com"
    return ProfileView(model: model)
}

#Preview("Error State") {
    let model = UserModel()
    model.name = ""  // Invalid
    return ProfileView(model: model)
}

#Preview("Dark Mode") {
    ProfileView()
        .preferredColorScheme(.dark)
}
```

### Preview Tips

1. **Create previews FIRST** before implementing
2. **Cover all states**: empty, loading, error, success
3. **Test edge cases**: long text, RTL, accessibility
4. **Use traits**: `.previewDevice()`, `.preferredColorScheme()`

## Debugging "View Not Updating"

### Decision Tree

```
View not updating?
├── Is @State/@Observable property changing?
│   ├── YES → Check if view body is called
│   └── NO → Fix state mutation
├── Is view body being called?
│   ├── YES → Check rendering (hidden, zero frame)
│   └── NO → Check observation (missing @Observable)
├── Is binding correct?
│   ├── $property for binding
│   └── property for read-only
└── Is parent recreating view?
    └── Check .id() modifier
```

### Debug Helpers

```swift
// Check if body is called
var body: some View {
    let _ = print("ProfileView body called")
    // ...
}

// Check state changes
@Observable
final class Model {
    var name: String = "" {
        didSet { print("name changed: \(name)") }
    }
}
```

## Animations

```swift
// Implicit animation
Text("Hello")
    .scaleEffect(isActive ? 1.2 : 1.0)
    .animation(.spring(), value: isActive)

// Explicit animation
withAnimation(.easeInOut) {
    isActive.toggle()
}

// Transaction
var transaction = Transaction(animation: .spring())
transaction.disablesAnimations = false
withTransaction(transaction) {
    isActive = true
}
```

### Animation Best Practices

| Pattern | Use Case |
|---------|----------|
| `.animation(_:value:)` | Single property |
| `withAnimation` | Multiple properties |
| `.transition()` | View insertion/removal |
| `.matchedGeometryEffect` | Hero transitions |

## Common Patterns

### Async Data Loading

```swift
struct UserListView: View {
    @State private var users: [User] = []
    @State private var isLoading = false

    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .task {
            isLoading = true
            users = await fetchUsers()
            isLoading = false
        }
    }
}
```

### Environment Values

```swift
// Define custom environment
struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme.light
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// Use in view
struct ThemedView: View {
    @Environment(\.theme) var theme

    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.primaryColor)
    }
}
```

### Navigation (iOS 16+)

```swift
struct AppView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink("User", value: Route.user(id: "1"))
                NavigationLink("Settings", value: Route.settings)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .user(let id):
                    UserView(id: id)
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}

enum Route: Hashable {
    case user(id: String)
    case settings
}
```

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| `@ObservableObject` | Legacy, verbose | Use `@Observable` |
| `.onAppear { Task {} }` | Lifecycle issues | Use `.task` modifier |
| ViewModel for simple views | Over-engineering | Views own @State |
| Force unwrap in views | Crashes | Use optional binding |
| Deep view hierarchies | Performance | Extract subviews |

## File Size Limits

| Component | Max LOC |
|-----------|---------|
| View (simple) | 100 |
| View (complex) | 200 |
| @Observable model | 150 |
| Preview file | 50 |

## Sources

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [WWDC 2024 - What's new in SwiftUI](https://developer.apple.com/videos/play/wwdc2024/10144/)
- [Axiom iOS Skills](https://github.com/CharlesWiltgen/Axiom)
