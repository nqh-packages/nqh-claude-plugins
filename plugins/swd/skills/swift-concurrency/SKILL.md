---
name: swift-concurrency
description: 'Expert guidance on Swift Concurrency best practices, patterns, and implementation. Use when developers mention: (1) Swift Concurrency, async/await, actors, or tasks, (2) "use Swift Concurrency" or "modern concurrency patterns", (3) migrating to Swift 6, (4) data races or thread safety issues, (5) refactoring closures to async/await, (6) @MainActor, Sendable, or actor isolation, (7) concurrent code architecture or performance optimization, (8) concurrency-related linter warnings (SwiftLint or similar; e.g. async_without_await, Sendable/actor isolation/MainActor lint).'
version: 2.0.0
author: Antoine van der Lee (SwiftLee), adapted by nqh
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
  - task group
  - async sequence
  - async stream
---

# Swift Concurrency

Expert guidance on Swift Concurrency, covering modern async/await patterns, actors, tasks, Sendable conformance, and migration to Swift 6.

## Agent Behavior Contract (Follow These Rules)

1. Analyze the project/package file to find out which Swift language mode (Swift 5.x vs Swift 6) and which Xcode/Swift toolchain is used when advice depends on it.
2. Before proposing fixes, identify the isolation boundary: `@MainActor`, custom actor, actor instance isolation, or nonisolated.
3. Do not recommend `@MainActor` as a blanket fix. Justify why main-actor isolation is correct for the code.
4. Prefer structured concurrency (child tasks, task groups) over unstructured tasks. Use `Task.detached` only with a clear reason.
5. If recommending `@preconcurrency`, `@unchecked Sendable`, or `nonisolated(unsafe)`, require:
   - a documented safety invariant
   - a follow-up ticket to remove or migrate it
6. For migration work, optimize for minimal blast radius (small, reviewable changes) and add verification steps.

## Project Settings Intake (Evaluate Before Advising)

Concurrency behavior depends on build settings. Always try to determine:

| Setting | Where to Check | Why It Matters |
|---------|----------------|----------------|
| Default actor isolation | SwiftPM: `.defaultIsolation(MainActor.self)` / Xcode: `SWIFT_DEFAULT_ACTOR_ISOLATION` | Changes default isolation of declarations |
| Strict concurrency checking | SwiftPM: `.enableExperimentalFeature("StrictConcurrency=targeted")` / Xcode: `SWIFT_STRICT_CONCURRENCY` | Controls enforcement level |
| Upcoming features | SwiftPM: `.enableUpcomingFeature("NonisolatedNonsendingByDefault")` / Xcode: `SWIFT_UPCOMING_FEATURE_` | Changes behavior (especially 6.2) |
| Swift language mode | SwiftPM: `// swift-tools-version:` / Xcode: `SWIFT_VERSION` | Swift 6 turns warnings into errors |

If any of these are unknown, ask the developer to confirm them before giving migration-sensitive guidance.

## Quick Decision Tree

When a developer needs concurrency guidance, follow this decision tree:

1. **Starting fresh with async code?**
   - Read `references/async-await-basics.md` for foundational patterns
   - For parallel operations → `references/tasks.md` (async let, task groups)

2. **Protecting shared mutable state?**
   - Need to protect class-based state → `references/actors.md` (actors, @MainActor)
   - Need thread-safe value passing → `references/sendable.md` (Sendable conformance)

3. **Managing async operations?**
   - Structured async work → `references/tasks.md` (Task, child tasks, cancellation)
   - Streaming data → `references/async-sequences.md` (AsyncSequence, AsyncStream)

4. **Working with legacy frameworks?**
   - Core Data integration → `references/core-data.md`
   - General migration → `references/migration.md`

5. **Performance or debugging issues?**
   - Slow async code → `references/performance.md` (profiling, suspension points)
   - Testing concerns → `references/testing.md` (XCTest, Swift Testing)

6. **Understanding threading behavior?**
   - Read `references/threading.md` for thread/task relationship and isolation

7. **Memory issues with tasks?**
   - Read `references/memory-management.md` for retain cycle prevention

## Triage-First Playbook (Common Errors -> Next Best Move)

| Error/Warning | First Action | Reference |
|---------------|--------------|-----------|
| SwiftLint `async_without_await` | Remove `async` if not required; if required by protocol/override/@concurrent, prefer narrow suppression | `references/linting.md` |
| "Sending value of non-Sendable type..." | Identify where value crosses isolation boundary | `references/sendable.md`, `references/threading.md` |
| "Main actor-isolated ... cannot be used from nonisolated context" | Decide if it truly belongs on `@MainActor` | `references/actors.md`, `references/threading.md` |
| "Class property 'current' is unavailable from asynchronous contexts" | Avoid thread-centric debugging, use Instruments | `references/threading.md` |
| XCTest "wait(...) is unavailable from asynchronous contexts" | Use `await fulfillment(of:)` or Swift Testing | `references/testing.md` |
| Core Data concurrency warnings | Use DAO pattern or `NSManagedObjectID` | `references/core-data.md` |

## Core Patterns Reference

### When to Use Each Concurrency Tool

| Tool | Use When | Example |
|------|----------|---------|
| `async/await` | Single asynchronous operation | `func fetchUser() async throws -> User` |
| `async let` | Fixed number of parallel operations (compile-time known) | `async let user = fetchUser()` |
| `Task` | Fire-and-forget, bridging sync to async | `Task { await updateUI() }` |
| `TaskGroup` | Dynamic parallel operations (runtime count) | `withTaskGroup(of: Result.self) { ... }` |
| `actor` | Protecting mutable state from data races | `actor DataCache { var cache: [...] }` |
| `@MainActor` | UI updates, view models | `@MainActor class ViewModel` |

### Common Scenarios

**Network request with UI update:**
```swift
Task { @concurrent in
    let data = try await fetchData()
    await MainActor.run {
        self.updateUI(with: data)
    }
}
```

**Multiple parallel network requests:**
```swift
async let users = fetchUsers()
async let posts = fetchPosts()
async let comments = fetchComments()
let (u, p, c) = try await (users, posts, comments)
```

**Processing array items in parallel:**
```swift
await withTaskGroup(of: ProcessedItem.self) { group in
    for item in items {
        group.addTask { await process(item) }
    }
    for await result in group {
        results.append(result)
    }
}
```

## Swift 6.2 Approachable Concurrency

Swift 6.2 flips the concurrency model: code starts from a single-threaded, @MainActor-by-default world.

| Concept | Purpose |
|---------|---------|
| `@MainActor` | UI thread isolation (default in 6.2) |
| `actor` | Shared mutable state isolation |
| `Sendable` | Safe to pass across isolation boundaries |
| `@concurrent` | Explicitly run on separate executor |
| `nonisolated(nonsending)` | Run on caller's actor (6.2 default) |

## Swift 6 Migration Quick Guide

Key changes in Swift 6:
- **Strict concurrency checking** enabled by default
- **Complete data-race safety** at compile time
- **Sendable requirements** enforced on boundaries
- **Isolation checking** for all async boundaries

For detailed migration steps, see `references/migration.md`.

## Reference Files

Load these files as needed for specific topics:

| File | Topics Covered |
|------|----------------|
| `async-await-basics.md` | async/await syntax, execution order, async let, URLSession patterns |
| `tasks.md` | Task lifecycle, cancellation, priorities, task groups, structured vs unstructured |
| `threading.md` | Thread/task relationship, suspension points, isolation domains, nonisolated |
| `memory-management.md` | Retain cycles in tasks, memory safety patterns |
| `actors.md` | Actor isolation, @MainActor, global actors, reentrancy, custom executors, Mutex |
| `sendable.md` | Sendable conformance, value/reference types, @unchecked, region isolation |
| `linting.md` | Concurrency-focused lint rules and SwiftLint `async_without_await` |
| `async-sequences.md` | AsyncSequence, AsyncStream, when to use vs regular async methods |
| `core-data.md` | NSManagedObject sendability, custom executors, isolation conflicts |
| `performance.md` | Profiling with Instruments, reducing suspension points, execution strategies |
| `testing.md` | XCTest async patterns, Swift Testing, concurrency testing utilities |
| `migration.md` | Swift 6 migration strategy, closure-to-async conversion, @preconcurrency, FRP migration |
| `glossary.md` | Terminology and concepts |

## Best Practices Summary

1. **Prefer structured concurrency** - Use task groups over unstructured tasks when possible
2. **Minimize suspension points** - Keep actor-isolated sections small to reduce context switches
3. **Use @MainActor judiciously** - Only for truly UI-related code
4. **Make types Sendable** - Enable safe concurrent access by conforming to Sendable
5. **Handle cancellation** - Check Task.isCancelled in long-running operations
6. **Avoid blocking** - Never use semaphores or locks in async contexts
7. **Test concurrent code** - Use proper async test methods and consider timing issues

## Verification Checklist (When You Change Concurrency Code)

- [ ] Confirm build settings (default isolation, strict concurrency, upcoming features) before interpreting diagnostics
- [ ] Run tests, especially concurrency-sensitive ones (see `references/testing.md`)
- [ ] If performance-related, verify with Instruments (see `references/performance.md`)
- [ ] If lifetime-related, verify deinit/cancellation behavior (see `references/memory-management.md`)

## Glossary

See `references/glossary.md` for quick definitions of core concurrency terms used across this skill.

---

**Note**: This skill is based on the comprehensive [Swift Concurrency Course](https://www.swiftconcurrencycourse.com) by Antoine van der Lee.
