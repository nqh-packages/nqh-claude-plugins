# swd

Swift/iOS development toolkit with MCP servers, debugging, testing, and modern patterns.

<!-- VISUAL -->
```
swd (addon)
├── .mcp.json                    # 4 MCP servers
├── skills/
│   ├── testing-swift-apps       # Swift Testing patterns
│   ├── logging-swift-apps       # Structured Swift logging
│   ├── swift-concurrency        # Swift 6 strict concurrency
│   ├── swiftui-patterns         # iOS 26+ SwiftUI patterns
│   └── xcode-cloud              # CI/CD workflows
└── agents/
    ├── swift-pro                # Expert Swift developer
    ├── swift-test-pro           # Expert Swift test writer
    └── ios-debugger             # Crash/memory/concurrency debugger
```
<!-- /VISUAL -->

**Requirements**: `dev-fundamentals@nqh-plugins` (core plugin with shared skills)

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install dev-fundamentals@nqh-plugins
/plugin install swd@nqh-plugins
```

## MCP Servers

| Server | Purpose | Tools |
|--------|---------|-------|
| **apple-docs** | Apple API docs + 1,260+ WWDC transcripts | 14 tools |
| **ios-simulator** | AI-driven simulator QA automation | 13 tools |
| **swiftlens** | SourceKit-LSP semantic analysis | 15 tools |
| **xcodebuild** | Build/test automation, scaffolding | 71 tools |

### Prerequisites

```bash
# SwiftLens requires Python 3.10+ and uv
brew install uv

# XcodeBuildMCP AXe for UI automation
brew install cameroncooke/axe/axe
```

## Agents

### swift-pro

Expert Swift developer for iOS/macOS applications.

- Swift 6.2 strict concurrency patterns
- SwiftUI with @Observable, Liquid Glass
- SwiftData with CloudKit compatibility
- Modern async/await networking
- View composition (atomic design)

### swift-test-pro

Expert Swift/iOS test writer with LLM-optimized JSON output.

- Swift Testing framework (Swift 6.2+) with `@Test`, `#expect`
- ViewInspector for SwiftUI component testing
- XCUITest for E2E testing
- Protocol-based dependency injection
- Tests `@Observable` models directly (no ViewModels)
- 85%+ coverage targets for business logic

### ios-debugger

Expert iOS/macOS debugger for crashes, memory, and concurrency issues.

- Crash analysis (EXC_BAD_ACCESS, SIGSEGV)
- Memory leak detection with Instruments
- Swift 6 concurrency debugging (data races, actor issues)
- LLDB command patterns
- Systematic 4-phase debugging methodology

## Skills

| Skill | Triggers | Description |
|-------|----------|-------------|
| `testing-swift-apps` | maestro, xcuitest, swift test | Swift Testing, Maestro, simctl |
| `logging-swift-apps` | os_log, swift logging | Structured logging with os_log |
| `swift-concurrency` | actor, sendable, mainactor | Swift 6 strict concurrency patterns |
| `swiftui-patterns` | swiftui, liquid glass, observable | iOS 26+ SwiftUI, preview-driven dev |
| `xcode-cloud` | testflight, ci cd ios | Xcode Cloud workflows, distribution |

## Sources

### MCP Servers
- [Apple Docs MCP](https://github.com/kimsungwhee/apple-docs-mcp)
- [iOS Simulator MCP](https://github.com/joshuayoes/ios-simulator-mcp)
- [SwiftLens](https://github.com/swiftlens/swiftlens)
- [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP)

### Patterns
- [Swift 6.2 Approachable Concurrency](https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/)
- [Axiom iOS Skills](https://github.com/CharlesWiltgen/Axiom)
- [Apple Xcode Cloud](https://developer.apple.com/documentation/xcode/xcode-cloud)

---

**v0.4.0** · Added comprehensive accessibility patterns to swiftui-patterns skill, accessibility checklists to swift-pro and swift-test-pro agents
**v0.3.2** · Renamed from `dev-fundamentals-swift` to `swd` to fix MCP tool name length exceeding 64-char API limit
**v0.3.0** · Added swift-pro agent, MCP servers (apple-docs, ios-simulator, swiftlens, xcodebuild), ios-debugger agent, swift-concurrency/swiftui-patterns/xcode-cloud skills
**v0.1.0** · Initial release with swift-test-pro agent and testing/logging skills
