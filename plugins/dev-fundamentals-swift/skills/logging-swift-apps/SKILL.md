---
name: logging-swift-apps
description: Exhaustive structured logging for Swift apps with easy filtering. Enforces correlation IDs, hierarchical categories, and provides CLI shortcuts for AI agents to debug daemons, extensions, and background processes.
version: 2.0.0
author: nqh
triggers:
  - swift logging
  - os_log
  - Logger
  - daemon logs
  - log stream
  - log show
  - print not working
  - safari extension logs
  - background process debug
  - crash logs
  - DiagnosticReports
  - EXC_BREAKPOINT
  - EXC_BAD_ACCESS
  - correlation ID
  - structured logging
---

# Logging Swift Apps

Exhaustive structured logging with easy filtering for Swift apps.

## Why This Skill Exists

| Problem | `print()` | `Logger` with this skill |
|---------|-----------|--------------------------|
| Daemon/extension output | **Invisible** | Visible + filterable |
| Tracing operations | Manual grep | Correlation IDs |
| Finding related logs | Needle in haystack | Hierarchical categories |
| Post-crash debugging | Gone | Archived + searchable |
| Performance profiling | None | Signpost integration |

## Quick Start (3 Steps)

### 1. Create Logging Infrastructure

```swift
// Logging.swift - Add to Shared/ folder
import OSLog

enum Log {
    static let subsystem = Bundle.main.bundleIdentifier ?? "com.nqh.myapp"

    // MARK: - Hierarchical Categories

    // Daemon operations
    static let daemonPolling = Logger(subsystem: subsystem, category: "daemon.polling")
    static let daemonCircuit = Logger(subsystem: subsystem, category: "daemon.circuit")
    static let daemonLifecycle = Logger(subsystem: subsystem, category: "daemon.lifecycle")

    // Network operations
    static let networkAPI = Logger(subsystem: subsystem, category: "network.api")
    static let networkWebSocket = Logger(subsystem: subsystem, category: "network.websocket")

    // Storage operations
    static let storageCache = Logger(subsystem: subsystem, category: "storage.cache")
    static let storageDatabase = Logger(subsystem: subsystem, category: "storage.database")

    // Extension operations
    static let extensionHandler = Logger(subsystem: subsystem, category: "extension.handler")
    static let extensionUI = Logger(subsystem: subsystem, category: "extension.ui")

    // UI operations
    static let uiViewCycle = Logger(subsystem: subsystem, category: "ui.viewcycle")
    static let uiAnimation = Logger(subsystem: subsystem, category: "ui.animation")
}
```

### 2. Log with Correlation IDs

```swift
func fetchData(endpoint: String) async throws -> Data {
    let opID = UUID().uuidString.prefix(8)  // Short correlation ID

    Log.networkAPI.info("[\(opID, privacy: .public)] START fetch \(endpoint, privacy: .public)")

    do {
        let data = try await URLSession.shared.data(from: URL(string: endpoint)!).0
        Log.networkAPI.info("[\(opID, privacy: .public)] OK size=\(data.count, privacy: .public)")
        return data
    } catch {
        Log.networkAPI.error("[\(opID, privacy: .public)] FAIL \(error.localizedDescription, privacy: .public)")
        throw error
    }
}
```

### 3. Filter Logs via CLI

```bash
# All app logs
log stream --predicate 'subsystem == "com.nqh.myapp"'

# Just daemon.polling category
log stream --predicate 'subsystem == "com.nqh.myapp" && category == "daemon.polling"'

# Trace specific operation by correlation ID
log show --last 1h --predicate 'eventMessage CONTAINS "[A1B2C3D4]"'
```

---

## Exhaustive Logging Patterns

### Pattern 1: Function Entry/Exit with Timing

```swift
func processItem(_ item: Item) async throws {
    let opID = UUID().uuidString.prefix(8)
    let start = CFAbsoluteTimeGetCurrent()

    Log.daemonPolling.info("[\(opID, privacy: .public)] ENTER processItem id=\(item.id, privacy: .public)")
    defer {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        Log.daemonPolling.info("[\(opID, privacy: .public)] EXIT processItem elapsed=\(elapsed, privacy: .public)s")
    }

    // ... implementation
}
```

### Pattern 2: State Changes

```swift
enum AppState: String {
    case idle, loading, ready, error
}

func transitionTo(_ newState: AppState) {
    Log.daemonLifecycle.notice("STATE \(currentState.rawValue, privacy: .public) → \(newState.rawValue, privacy: .public)")
    currentState = newState
}
```

### Pattern 3: Decision Branches

```swift
func handleTab(_ tab: Tab) {
    let opID = UUID().uuidString.prefix(8)

    if tab.isWhitelisted {
        Log.daemonPolling.debug("[\(opID, privacy: .public)] SKIP whitelisted url=\(tab.url, privacy: .public)")
        return
    }

    if tab.isActive {
        Log.daemonPolling.debug("[\(opID, privacy: .public)] SKIP active tab")
        return
    }

    Log.daemonPolling.info("[\(opID, privacy: .public)] HIBERNATE pid=\(tab.pid, privacy: .public)")
    hibernateTab(tab)
}
```

### Pattern 4: Error Context

```swift
func loadConfig() throws -> Config {
    let opID = UUID().uuidString.prefix(8)

    do {
        let data = try Data(contentsOf: configURL)
        Log.storageCache.debug("[\(opID, privacy: .public)] Read config size=\(data.count, privacy: .public)")

        let config = try JSONDecoder().decode(Config.self, from: data)
        Log.storageCache.info("[\(opID, privacy: .public)] Parsed config version=\(config.version, privacy: .public)")
        return config

    } catch let error as DecodingError {
        Log.storageCache.error("[\(opID, privacy: .public)] DECODE_ERROR \(String(describing: error), privacy: .public)")
        throw error

    } catch {
        Log.storageCache.error("[\(opID, privacy: .public)] IO_ERROR \(error.localizedDescription, privacy: .public)")
        throw error
    }
}
```

---

## Hierarchical Category System

### Naming Convention

```
subsystem: com.nqh.appname
├── daemon.polling       # Background polling
├── daemon.circuit       # Circuit breaker
├── daemon.lifecycle     # Start/stop/restart
├── network.api          # REST API calls
├── network.websocket    # WebSocket events
├── storage.cache        # In-memory cache
├── storage.database     # Persistent storage
├── extension.handler    # Extension request handling
├── extension.ui         # Extension UI events
├── ui.viewcycle         # View appear/disappear
└── ui.animation         # Animation start/complete
```

### Category Selection Guide

| Scenario | Category | Level |
|----------|----------|-------|
| Daemon starting/stopping | `daemon.lifecycle` | `.notice` |
| Poll cycle start/end | `daemon.polling` | `.info` |
| Circuit breaker trip | `daemon.circuit` | `.warning` |
| API request/response | `network.api` | `.info` |
| Cache hit/miss | `storage.cache` | `.debug` |
| Extension handler called | `extension.handler` | `.info` |
| View appeared | `ui.viewcycle` | `.debug` |
| Unrecoverable error | Any | `.fault` |

---

## CLI Filtering (Easy Mode)

### Shell Aliases (Add to ~/.zshrc)

```bash
# Quick app log stream
alias logapp='log stream --predicate "subsystem == \"com.nqh.myapp\""'

# Daemon logs only
alias logdaemon='log stream --predicate "subsystem == \"com.nqh.myapp\" && category BEGINSWITH \"daemon\""'

# Network logs only
alias lognet='log stream --predicate "subsystem == \"com.nqh.myapp\" && category BEGINSWITH \"network\""'

# Errors only
alias logerr='log stream --predicate "subsystem == \"com.nqh.myapp\" && messageType IN {error, fault}"'

# Show last hour
alias logshow='log show --last 1h --predicate "subsystem == \"com.nqh.myapp\""'

# Trace correlation ID (usage: logtrace "A1B2C3D4")
logtrace() {
    log show --last 1h --predicate "eventMessage CONTAINS \"[$1]\""
}

# Category filter (usage: logcat daemon.polling)
logcat() {
    log stream --predicate "subsystem == \"com.nqh.myapp\" && category == \"$1\""
}
```

### Common Filter Predicates

| Goal | Predicate |
|------|-----------|
| Specific category | `category == "daemon.polling"` |
| Category group | `category BEGINSWITH "daemon"` |
| Multiple categories | `category IN {"daemon.polling", "daemon.circuit"}` |
| Errors only | `messageType IN {error, fault}` |
| Contains text | `eventMessage CONTAINS "hibernat"` |
| Correlation ID | `eventMessage CONTAINS "[A1B2C3D4]"` |
| Combined | `(category == "network.api") && (messageType == error)` |

### Output Formats

```bash
# Compact (default, human-readable)
log show --style compact --last 1h --predicate '...'

# JSON (for parsing)
log show --style json --last 1h --predicate '...' > logs.json

# Syslog (traditional)
log show --style syslog --last 1h --predicate '...'
```

---

## Privacy Annotations

| Annotation | When to Use | Example |
|------------|-------------|---------|
| `.public` | IDs, counts, status, URLs | `\(tabCount, privacy: .public)` |
| `.private` | User data, tokens | `\(userEmail, privacy: .private)` |
| `.private(mask: .hash)` | Track equality | `\(sessionID, privacy: .private(mask: .hash))` |
| (none) | Default auto-redact | `\(someValue)` |

### Quick Reference

```swift
// Always public (non-sensitive operational data)
Log.daemon.info("Processed \(count, privacy: .public) tabs")
Log.daemon.info("PID \(pid, privacy: .public)")
Log.daemon.info("URL \(url.host ?? "unknown", privacy: .public)")

// Always private (user/sensitive data)
Log.auth.info("Token: \(token, privacy: .private)")
Log.auth.info("User: \(email, privacy: .private)")

// Hash for correlation without exposure
Log.session.info("Session: \(sessionID, privacy: .private(mask: .hash))")
```

---

## Signpost Integration (Performance)

```swift
import os

class TabMonitor {
    private static let signposter = OSSignposter(subsystem: Log.subsystem, category: "performance")

    func pollCycle() async {
        let signpostID = Self.signposter.makeSignpostID()
        let interval = Self.signposter.beginInterval("pollCycle", id: signpostID)
        defer { Self.signposter.endInterval("pollCycle", interval) }

        // ... polling logic

        Self.signposter.emitEvent("processed", id: signpostID, "\(tabCount) tabs")
    }
}
```

View in Instruments: Product → Profile → Choose "Logging" instrument.

---

## OSLogStore (Programmatic Access)

```swift
import OSLog

func exportRecentLogs() async throws -> String {
    let store = try OSLogStore(scope: .currentProcessIdentifier)
    let position = store.position(date: Date(timeIntervalSinceNow: -3600))
    let entries = try store.getEntries(at: position)

    var output = ""
    for entry in entries.compactMap({ $0 as? OSLogEntryLog }) {
        let ts = entry.date.formatted(.iso8601)
        output += "[\(ts)] [\(entry.category)] \(entry.composedMessage)\n"
    }
    return output
}

func getErrorsOnly() async throws -> [OSLogEntryLog] {
    let store = try OSLogStore(scope: .currentProcessIdentifier)
    let predicate = NSPredicate(format: "messageType IN %@",
        [OSLogEntryLog.Level.error.rawValue, OSLogEntryLog.Level.fault.rawValue])
    let position = store.position(date: Date(timeIntervalSinceNow: -86400))

    return try store.getEntries(at: position, matching: predicate)
        .compactMap { $0 as? OSLogEntryLog }
}
```

---

## Crash Log Correlation

### Add Pre-Crash Context

```swift
func performRiskyOperation() throws {
    let opID = UUID().uuidString.prefix(8)

    // Log BEFORE risky operation (will appear in crash logs)
    Log.daemon.fault("[\(opID, privacy: .public)] ABOUT_TO: riskyOperation state=\(currentState, privacy: .public)")

    try riskyOperation()  // If this crashes, the log above survives

    Log.daemon.notice("[\(opID, privacy: .public)] COMPLETED: riskyOperation")
}
```

### Crash Log Locations

```bash
# macOS app crashes
ls -lt ~/Library/Logs/DiagnosticReports/*.ips | head -10

# Read specific crash
cat ~/Library/Logs/DiagnosticReports/MyApp-*.ips

# Correlate with logs
log show --last 1h --predicate 'subsystem == "com.nqh.myapp"' --start "$(date -v-1H +%Y-%m-%d\ %H:%M:%S)"
```

---

## Enforcement Checklist

When reviewing Swift code, verify:

| Check | Requirement |
|-------|-------------|
| **Logging infrastructure** | `Log` enum with hierarchical categories exists |
| **Correlation IDs** | Async operations use `[opID]` prefix |
| **Function boundaries** | `ENTER`/`EXIT` logs for important functions |
| **State changes** | `STATE old → new` format logged |
| **Decision branches** | `SKIP reason` or `ACTION why` logged |
| **Error context** | Errors include operation context, not just message |
| **Privacy** | Sensitive data uses `.private`, IDs use `.public` |
| **Levels** | Appropriate level (debug/info/notice/warning/error/fault) |

### Log Level Guidelines

| Level | Persistence | Use Case |
|-------|-------------|----------|
| `.debug` | Only when streaming | Verbose dev diagnostics |
| `.info` | With collection | Operational events |
| `.notice` | **YES** | Notable events (DEFAULT) |
| `.warning` | **YES** | Recoverable issues |
| `.error` | **YES** | Failures |
| `.fault` | **YES** | Critical/pre-crash |

---

## AI Agent Workflow

```
1. IMPLEMENT  → Add Logger categories per component
2. ADD LOGS   → Entry/exit, decisions, state changes, errors
3. ADD IDs    → Correlation IDs for async operations
4. BUILD      → xcodebuild
5. RUN        → Launch app/daemon
6. STREAM     → log stream --predicate 'subsystem=="..."'
7. TRACE      → logtrace "A1B2C3D4" for specific operation
8. DIAGNOSE   → log show --last 1h (historical)
9. CRASH?     → Check DiagnosticReports/, correlate with logs
```

---

## Migration from print()

| Before | After |
|--------|-------|
| `print("Starting...")` | `Log.daemon.notice("ENTER daemon")` |
| `print("User: \(user)")` | `Log.auth.info("User: \(user.id, privacy: .private)")` |
| `print("Error: \(error)")` | `Log.daemon.error("[\(opID)] FAIL \(error.localizedDescription, privacy: .public)")` |
| `print("Done")` | `Log.daemon.info("[\(opID)] EXIT elapsed=\(time)s")` |

---

## Related Skills

- `testing-swift-apps` - Simulator control
- `writing-shell-logs` - Shell script logging
- `writing-python-logs` - Python script logging
