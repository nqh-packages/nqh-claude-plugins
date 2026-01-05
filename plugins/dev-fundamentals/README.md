# dev-fundamentals

Core development methodologies: systematic debugging, testing, TDD, and research skills.

<!-- VISUAL -->
```
dev-fundamentals (core)
├── skills/
│   ├── debugging-systematically    # 4-phase scientific debugging
│   ├── testing-systematically      # ZOMBIES test case analysis
│   ├── tdd-methodology             # RED-GREEN-REFACTOR
│   ├── researching                 # Research orchestration
│   ├── waiting-for-conditions      # Async/polling patterns
│   ├── determining-test-truth      # Test result verification
│   ├── capturing-screenshots       # Visual debugging
│   ├── writing-markdown            # Documentation output
│   └── writing-typescript-logs     # Structured logging
└── agents/
    ├── debugger                    # Autonomous debugging specialist
    └── research-agent              # Web research with credibility scoring
```
<!-- /VISUAL -->

**Requirements**: None (core plugin, no dependencies)

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install dev-fundamentals@nqh-plugins
```

## Skills

| Skill | Description |
|-------|-------------|
| `debugging-systematically` | 4-phase scientific debugging: Wolf Fence isolation, Pattern Analysis, 5 Whys, Confidence Report |
| `testing-systematically` | Test framework: Testing Pyramid, ZOMBIES case analysis, Risk Confidence Report |
| `tdd-methodology` | RED-GREEN-REFACTOR cycle with anti-pattern detection and coverage gates |
| `researching` | Orchestrates research-agent subagents for web research with synthesis |
| `waiting-for-conditions` | Patterns for async operations, polling, and condition checking |
| `determining-test-truth` | Methods for verifying test results and identifying flaky tests |
| `capturing-screenshots` | Visual debugging and screenshot capture for documentation |
| `writing-markdown` | Structured markdown output for reports and documentation |
| `writing-typescript-logs` | Structured logging patterns for TypeScript applications |

## Agents

| Agent | Description |
|-------|-------------|
| `debugger` | Autonomous debugging specialist using systematic methodology |
| `research-agent` | Web research with Firecrawl API and credibility scoring (0-95) |

## Addon Plugins

Install addons for platform-specific testing agents:

| Addon | Agent | Install |
|-------|-------|---------|
| dev-fundamentals-react | react-test-pro | `/plugin install dev-fundamentals-react@nqh-plugins` |
| dev-fundamentals-swift | swift-test-pro | `/plugin install dev-fundamentals-swift@nqh-plugins` |
| dev-fundamentals-typescript | typescript-test-pro | `/plugin install dev-fundamentals-typescript@nqh-plugins` |
| dev-fundamentals-react-native | react-native-test-pro | `/plugin install dev-fundamentals-react-native@nqh-plugins` |

---

**v0.1.0** · Initial release with 9 skills and 2 agents
