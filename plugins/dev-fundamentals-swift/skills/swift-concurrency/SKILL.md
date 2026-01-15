---
name: swift-concurrency
description: Swift 6 strict concurrency patterns including actors, Sendable, @MainActor, async/await, and data race prevention. Use when encountering concurrency errors, migrating to Swift 6, or implementing thread-safe code.
version: 1.0.0
author: nqh
triggers:
  - actor
  - sendable
  - mainactor
  - async await
  - data race
  - swift 6 concurrency
  - strict concurrency
  - thread safety
  - isolation
  - nonisolated
  - concurrent
---

# Swift 6 Concurrency

Strict concurrency patterns for data race prevention in Swift 6.2+.

## Swift 6.2 Approachable Concurrency

Swift 6.2 flips the concurrency model: code starts from a single-threaded, @MainActor-by-default world.

### Key Concepts

| Concept | Purpose |
|---------|---------|
| `@MainActor` | UI thread isolation (default in 6.2) |
| `actor` | Shared mutable state isolation |
| `Sendable` | Safe to pass across isolation boundaries |
| `@concurrent` | Explicitly run on separate executor |
| `nonisolated(nonsending)` | Run on caller's actor (6.2 default) |

## Core Patterns

### @MainActor (Default in Swift 6.2)

```swift
// Swift 6.2: Implicitly @MainActor for new projects
@Observable
final class UserModel {
    var name: String = ""

    func updateName(_ newName: String) {
        name = newName  // Safe, runs on MainActor
    }
}

// Explicit when needed (existing projects)
@MainActor
final class ViewController {
    func updateUI() {
        // Guaranteed main thread
    }
}
```

### Actor for Shared State

```swift
actor NetworkCache {
    private var cache: [URL: Data] = [:]

    func get(_ url: URL) -> Data? {
        cache[url]
    }

    func set(_ url: URL, data: Data) {
        cache[url] = data
    }
}

// Usage
let cache = NetworkCache()
let data = await cache.get(url)
```

### Sendable Types

```swift
// Immutable struct - automatically Sendable
struct UserData: Sendable {
    let id: UUID
    let name: String
}

// Class must be final + immutable
final class Config: Sendable {
    let apiURL: URL
    let timeout: TimeInterval

    init(apiURL: URL, timeout: TimeInterval) {
        self.apiURL = apiURL
        self.timeout = timeout
    }
}

// Actor is always Sendable
actor Database: Sendable {
    // ...
}
```

### @concurrent (Swift 6.2)

```swift
// Explicitly runs on separate executor
@concurrent
func processInBackground() async -> Result {
    // Runs off MainActor even if called from MainActor
    return heavyComputation()
}

// Without @concurrent (6.2 default behavior)
nonisolated func helper() async -> String {
    // Runs on CALLER'S actor (no thread hop)
    return "result"
}
```

## Migration Strategies

### Progressive Feature Enablement

Enable features individually instead of bulk-enabling:

```swift
// Package.swift
.target(
    name: "MyApp",
    dependencies: [],
    swiftSettings: [
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableUpcomingFeature("InferSendableFromCaptures"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]
)
```

### Step-by-Step Migration

| Step | Action |
|------|--------|
| 1 | Mark ViewModels/Controllers with `@MainActor` |
| 2 | Convert shared state classes to `actor` |
| 3 | Make data types `Sendable` |
| 4 | Audit closures for `@Sendable` compliance |
| 5 | Enable strict concurrency checking |

### Common Fixes

```swift
// ❌ Non-Sendable capture in async closure
class MyClass {
    var data: [String] = []

    func process() {
        Task {
            self.data.append("x")  // Error: not Sendable
        }
    }
}

// ✅ Fix 1: Make actor
actor MyActor {
    var data: [String] = []

    func process() {
        Task {
            await self.data.append("x")  // OK
        }
    }
}

// ✅ Fix 2: Use @MainActor
@MainActor
class MyClass {
    var data: [String] = []

    func process() {
        Task { @MainActor in
            self.data.append("x")  // OK, same isolation
        }
    }
}
```

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| `@unchecked Sendable` everywhere | Hides real issues | Fix actual Sendable conformance |
| `nonisolated(unsafe)` | Disables safety | Use proper isolation |
| `@MainActor` on everything | Performance | Only UI code needs MainActor |
| Blocking main thread | UI freeze | Use Task for async work |

## Debugging Concurrency

### Thread Sanitizer

```bash
xcodebuild test \
  -scheme MyApp \
  -enableThreadSanitizer YES
```

### Check Isolation

```swift
// Debug current thread
print("Main thread: \(Thread.isMainThread)")

// Check actor isolation (runtime)
#if DEBUG
actor DebugActor {
    func checkIsolation() {
        // If this runs, we're on this actor
    }
}
#endif
```

### Common Error Messages

| Error | Meaning | Fix |
|-------|---------|-----|
| "not Sendable" | Type crosses isolation boundary | Make Sendable or use actor |
| "actor-isolated" | Accessing actor state from outside | Add `await` |
| "main actor-isolated" | UI code from background | Use `@MainActor` or `MainActor.run` |

## Best Practices

1. **Start with @MainActor** for UI code
2. **Use actor** for shared mutable state
3. **Prefer value types** (struct, enum) - automatically Sendable
4. **Avoid @unchecked** unless absolutely necessary
5. **Enable strict concurrency** early in new projects
6. **Use Task** for async work, not DispatchQueue

## Quick Reference

```swift
// UI code
@MainActor class ViewModel { }

// Shared state
actor Cache { }

// Safe data transfer
struct Data: Sendable { }

// Background work (6.2)
@concurrent func work() async { }

// Caller's context (6.2 default)
nonisolated func helper() async { }
```

## Sources

- [Swift 6.2 Approachable Concurrency](https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/)
- [Hacking with Swift - Complete Concurrency](https://www.hackingwithswift.com/swift/6.0/concurrency)
- [Swift Evolution - Strict Concurrency](https://github.com/swiftlang/swift-evolution)
