---
name: testing-swift-apps
description: Comprehensive Swift app testing - UI automation, simulator control, visual regression, push notifications
version: 2.0.0
author: nqh
triggers:
  - maestro
  - xcuitest
  - swift test
  - ios simulator test
  - macos app test
  - accessibility audit
  - simctl
  - push notification
  - visual diff
  - status bar
  - screenshot
---

# Testing Swift Apps

Test Swift iOS and macOS applications using modern, maintained tools.

## When to Use

- Testing iOS apps on Simulator (Maestro for UI automation)
- Testing macOS native apps (XCUITest)
- Running Swift unit/integration tests (`swift test`)
- Build verification (`xcodebuild`)
- Accessibility audits (`performAccessibilityAudit()`)

## Tool Selection

| Platform | UI Testing | Unit Tests | Build | Accessibility | Performance |
|----------|------------|------------|-------|---------------|-------------|
| iOS Sim  | Maestro    | swift test | xcodebuild | XCUITest | xctrace |
| macOS    | XCUITest   | swift test | xcodebuild | XCUITest | xctrace |

## Prerequisites

### Maestro (iOS Simulator UI)
```bash
# Install Maestro CLI
curl -fsSL "https://get.maestro.mobile.dev" | bash

# Requires Java 17+
brew install openjdk@17
```

### Xcode (All platforms)
- Xcode 16+ installed
- Command line tools: `xcode-select --install`

## Quick Start

### 1. Initialize Maestro Flows for an App
```bash
bash .claude/skills/testing-swift-apps/scripts/maestro/init-flows.sh apps/szync-swift
```

This creates:
```
apps/szync-swift/.maestro/
├── config.yaml
└── flows/
    └── smoke-test.yaml
```

### 2. Run Maestro UI Test
```bash
bash .claude/skills/testing-swift-apps/scripts/maestro/run-flow.sh apps/szync-swift smoke-test
```

### 3. Run Swift Unit Tests
```bash
bash .claude/skills/testing-swift-apps/scripts/swift-test/run-unit-tests.sh apps/szync-swift
```

### 4. Run Full Test Suite
```bash
bash .claude/skills/testing-swift-apps/scripts/test-swift.sh apps/szync-swift --suite=all
```

## Maestro Flow Syntax

Maestro uses YAML for declarative UI flows:

```yaml
appId: com.example.app
---
- launchApp
- tapOn: "Create Map"
- inputText: "My First Map"
- tapOn: "Save"
- assertVisible: "My First Map"
```

### Common Commands

| Command | Description |
|---------|-------------|
| `launchApp` | Launch the app |
| `tapOn: "text"` | Tap element with text |
| `tapOn: {id: "accessibilityId"}` | Tap by accessibility ID |
| `inputText: "value"` | Type text into focused field |
| `assertVisible: "text"` | Assert text is visible |
| `swipe: {direction: UP}` | Swipe gesture |
| `scroll` | Scroll down |
| `takeScreenshot: filename` | Capture screenshot |
| `waitForAnimationToEnd` | Wait for animations |

## XCUITest Patterns (macOS)

For macOS apps, use XCUITest directly:

```swift
func testCreateMap() throws {
    let app = XCUIApplication()
    app.launch()

    app.buttons["Create Map"].tap()
    app.textFields["Map Name"].typeText("My Map")
    app.buttons["Save"].tap()

    XCTAssertTrue(app.staticTexts["My Map"].exists)
}
```

### Accessibility Audit
```swift
func testAccessibility() throws {
    let app = XCUIApplication()
    app.launch()

    try app.performAccessibilityAudit()
}
```

## Directory Structure

```
.claude/skills/testing-swift-apps/
├── SKILL.md                    # This file
├── rules.yaml                  # Activation rules
├── scripts/
│   ├── test-swift.sh          # Main entry point
│   ├── maestro/
│   │   ├── install.sh         # Install Maestro CLI
│   │   ├── run-flow.sh        # Execute Maestro flows
│   │   └── init-flows.sh      # Initialize .maestro/ in app
│   ├── xcuitest/
│   │   ├── run-ui-tests.sh    # Run XCUITest
│   │   └── accessibility-audit.sh
│   ├── swift-test/
│   │   └── run-unit-tests.sh
│   └── build/
│       └── verify-build.sh
├── references/
│   ├── maestro-quick.md
│   └── xcuitest-quick.md
└── templates/
    └── app-maestro/           # Template for init-flows.sh
        ├── config.yaml
        └── flows/smoke-test.yaml
```

## Per-App Maestro Structure

Each app gets its own `.maestro/` directory:

```
apps/szync-swift/
├── .maestro/
│   ├── config.yaml           # App-specific config
│   └── flows/
│       ├── smoke-test.yaml   # Quick sanity check
│       ├── create-map.yaml   # Create map flow
│       └── edit-node.yaml    # Edit node flow
├── Shared/
└── ...
```

## iOS Version Compatibility

| iOS Version | Maestro Status | Notes |
|-------------|----------------|-------|
| iOS 17.x | ✅ Full support | All features work |
| iOS 18.0-18.5 | ✅ Full support | All features work |
| iOS 26+ (beta) | ⚠️ Limited | Element detection issues (GitHub #2609) |

### iOS 26+ Known Issues

Maestro has documented compatibility problems with iOS 26 / macOS Tahoe:
- **Element not found**: Text and ID selectors fail to match visible elements
- **XCTest driver**: Accessibility tree not properly exposed
- **Workaround**: Use coordinate-based selectors (`tapOn: {point: "50%,60%"}`)

See: [GitHub Issue #2609](https://github.com/mobile-dev-inc/Maestro/issues/2609)

### Recommended Approach for iOS 26+

1. **Use XCUITest** for reliable UI testing (native Apple framework)
2. **Coordinate-based Maestro** as workaround for simple flows
3. **Wait for Maestro 2.1+** which may include iOS 26 fixes

## Comparison: Maestro vs idb

| Feature | Maestro | idb (old) |
|---------|---------|-----------|
| Maintained | Yes (7k+ stars) | No (Aug 2022) |
| iOS 17-18.5 | ✅ Works | Broken |
| iOS 26+ | ⚠️ Limited | Broken |
| macOS Tahoe | ⚠️ Issues | Framework conflict |
| Syntax | YAML | Python scripts |
| Setup | One curl | pipx + brew |

## Troubleshooting

### Maestro not finding elements (iOS 26+)
This is a **known issue** with Maestro on iOS 26 / macOS Tahoe.

**Symptoms:**
- `Element not found: Text matching regex: ...`
- `Element with Id matching regex: ... not found`
- Screenshots show element is visible, but Maestro can't find it

**Workarounds:**
```yaml
# Instead of text selector (broken on iOS 26):
- tapOn: "Create Map"

# Use coordinate-based selector:
- tapOn:
    point: "50%,60%"

# Or percentage bounds:
- tapOn:
    point: "160,850"
```

**Root cause:** Maestro's XCTest driver doesn't properly access the accessibility tree on iOS 26.

### Maestro not finding app
- Ensure simulator is booted: `xcrun simctl boot "iPhone 17 Pro"`
- Check app is installed: `xcrun simctl listapps booted`
- Verify bundle ID matches config.yaml

### XCUITest failures
- Check accessibility identifiers are set in code
- Use `app.debugDescription` to see element hierarchy
- Enable "Accessibility Inspector" in Xcode

---

## Simulator Control (simctl)

Direct iOS Simulator control via native `xcrun simctl` commands.

### Health Check
```bash
bash .claude/skills/testing-swift-apps/scripts/simctl/health-check.sh
```
Verifies Xcode, simulator, Maestro, ImageMagick, and all required capabilities.

### Status Bar (App Store Screenshots)
```bash
# Perfect App Store preset: 9:41, 100% battery, WiFi
bash .claude/skills/testing-swift-apps/scripts/simctl/status-bar.sh --appstore

# Custom
bash .claude/skills/testing-swift-apps/scripts/simctl/status-bar.sh --time=9:41 --battery=100

# Reset
bash .claude/skills/testing-swift-apps/scripts/simctl/status-bar.sh --reset
```

### Push Notifications
```bash
bash .claude/skills/testing-swift-apps/scripts/simctl/push-notification.sh \
  com.nqh.szync-swift-ios "New Map" "Someone shared a map with you"

# With badge
bash .claude/skills/testing-swift-apps/scripts/simctl/push-notification.sh \
  com.nqh.app "Alert" "Check this" --badge=3
```

### Privacy / Permissions
```bash
# Grant camera access
bash .claude/skills/testing-swift-apps/scripts/simctl/privacy.sh grant camera com.example.app

# Revoke location
bash .claude/skills/testing-swift-apps/scripts/simctl/privacy.sh revoke location com.example.app

# Reset all permissions
bash .claude/skills/testing-swift-apps/scripts/simctl/privacy.sh reset all com.example.app
```

### Clipboard
```bash
# Copy text to simulator
bash .claude/skills/testing-swift-apps/scripts/simctl/clipboard.sh copy "user@example.com"

# Paste from simulator
bash .claude/skills/testing-swift-apps/scripts/simctl/clipboard.sh paste
```

### Device Lifecycle
```bash
# List simulators
bash .claude/skills/testing-swift-apps/scripts/simctl/device-lifecycle.sh list

# Get booted UDID
bash .claude/skills/testing-swift-apps/scripts/simctl/device-lifecycle.sh booted

# Boot/shutdown
bash .claude/skills/testing-swift-apps/scripts/simctl/device-lifecycle.sh boot
bash .claude/skills/testing-swift-apps/scripts/simctl/device-lifecycle.sh shutdown all

# Factory reset
bash .claude/skills/testing-swift-apps/scripts/simctl/device-lifecycle.sh erase booted
```

### Log Monitoring
```bash
# Stream all logs
bash .claude/skills/testing-swift-apps/scripts/simctl/log-monitor.sh

# Filter by app
bash .claude/skills/testing-swift-apps/scripts/simctl/log-monitor.sh --app=szync-swift

# Errors only
bash .claude/skills/testing-swift-apps/scripts/simctl/log-monitor.sh --level=error
```

### Screen Hierarchy
```bash
# Dump accessibility tree (via Maestro)
bash .claude/skills/testing-swift-apps/scripts/simctl/screen-hierarchy.sh
```

### Visual Diff / Screenshot Comparison
```bash
# Compare screenshots (requires ImageMagick: brew install imagemagick)
bash .claude/skills/testing-swift-apps/scripts/simctl/screenshot-diff.sh baseline.png current.png

# With threshold (allow 5% difference)
bash .claude/skills/testing-swift-apps/scripts/simctl/screenshot-diff.sh baseline.png current.png --threshold=5
```

### App State Capture
```bash
# Capture debugging snapshot (screenshot, logs, device info)
bash .claude/skills/testing-swift-apps/scripts/simctl/app-state.sh com.nqh.szync-swift-ios
```

---

## Directory Structure (Full)

```
.claude/skills/testing-swift-apps/
├── SKILL.md
├── rules.yaml
├── scripts/
│   ├── test-swift.sh              # Main entry point
│   ├── maestro/                   # iOS UI automation
│   │   ├── install.sh
│   │   ├── run-flow.sh
│   │   └── init-flows.sh
│   ├── xcuitest/                  # macOS UI + accessibility
│   │   ├── run-ui-tests.sh
│   │   └── accessibility-audit.sh
│   ├── swift-test/                # Unit tests
│   │   └── run-unit-tests.sh
│   ├── build/                     # Build verification
│   │   └── verify-build.sh
│   ├── simctl/                    # Simulator control
│   │   ├── health-check.sh
│   │   ├── clipboard.sh
│   │   ├── status-bar.sh
│   │   ├── push-notification.sh
│   │   ├── privacy.sh
│   │   ├── device-lifecycle.sh
│   │   ├── log-monitor.sh
│   │   ├── screen-hierarchy.sh
│   │   ├── screenshot-diff.sh
│   │   └── app-state.sh
│   └── xctrace/                   # Performance profiling
│       ├── profile.sh
│       ├── app-launch.sh
│       └── export-xml.sh
├── references/
│   ├── maestro-quick.md
│   ├── xcuitest-quick.md
│   ├── simctl-quick.md
│   ├── snapshot-testing-quick.md
│   └── xctrace-quick.md           # Performance profiling
└── templates/
    └── app-maestro/
```

## Performance Profiling (xctrace)

Apple's CLI interface to Instruments for headless performance profiling.

### Quick Start
```bash
# Profile running app for 10 seconds
bash .claude/skills/testing-swift-apps/scripts/xctrace/profile.sh com.nqh.myapp 10s

# Profile app launch (cold start)
bash .claude/skills/testing-swift-apps/scripts/xctrace/app-launch.sh com.nqh.myapp --cold

# Export trace to XML for analysis
bash .claude/skills/testing-swift-apps/scripts/xctrace/export-xml.sh profile.trace
```

### Available Templates
| Template | Use Case |
|----------|----------|
| Time Profiler | CPU sampling, call stacks |
| Allocations | Memory allocation tracking |
| Leaks | Memory leak detection |
| App Launch | Startup performance |
| Animation Hitches | UI jank detection |
| SwiftUI | SwiftUI-specific profiling |

### Common Commands
```bash
# List available templates
xcrun xctrace list templates

# Record Time Profiler trace
xcrun xctrace record \
  --template 'Time Profiler' \
  --attach 'MyApp' \
  --time-limit 10s \
  --output profile.trace

# Export data as XML
xcrun xctrace export \
  --input profile.trace \
  --xpath '//trace-toc[1]/run[1]/data[1]/table' \
  --output results.xml
```

### AI Agent Workflow
```
┌─────────────────────────────────────────────────────────────────┐
│                    AI AGENT PERFORMANCE WORKFLOW                 │
├─────────────────────────────────────────────────────────────────┤
│  1. TRIGGER   └─> User reports issue / CI detects regression    │
│  2. PROFILE   └─> xctrace record --template 'Time Profiler'     │
│  3. EXPORT    └─> xctrace export --xpath '...' > XML            │
│  4. PARSE     └─> Extract call stacks, hot paths from XML       │
│  5. ANALYZE   └─> AI identifies bottlenecks                     │
│  6. RECOMMEND └─> Generate optimization suggestions             │
│  7. VALIDATE  └─> Re-profile after changes, compare metrics     │
└─────────────────────────────────────────────────────────────────┘
```

### Limitations
| Limitation | Workaround |
|------------|------------|
| XML export slow/large | Use XPath filtering |
| Leaks export incomplete | Use Instruments GUI |
| No JSON export | Parse XML |

---

## Dependencies

| Tool | Purpose | Install |
|------|---------|---------|
| Maestro | iOS UI automation | `curl -fsSL "https://get.maestro.mobile.dev" \| bash` |
| Java 17+ | Maestro dependency | `brew install openjdk@17` |
| ImageMagick | Visual diff | `brew install imagemagick` |
| jq | JSON parsing | `brew install jq` |

## Related

- Slash command: `/test-swift`
- References: `references/*.md`
