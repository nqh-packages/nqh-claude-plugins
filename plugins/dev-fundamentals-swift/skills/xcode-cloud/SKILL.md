---
name: xcode-cloud
description: Xcode Cloud CI/CD workflows for automated builds, testing, and TestFlight distribution. Use when setting up CI/CD, configuring workflows, or automating app distribution.
version: 1.0.0
author: nqh
triggers:
  - xcode cloud
  - testflight
  - ci cd ios
  - automated build
  - app store connect
  - workflow
  - distribution
  - continuous integration
---

# Xcode Cloud CI/CD

Automated builds, testing, and TestFlight distribution with Xcode Cloud.

## Key Concept

**Xcode Cloud does NOT use YAML files.** All configuration is in App Store Connect or Xcode UI.

## Workflow Components

| Component | Purpose |
|-----------|---------|
| Start Condition | When to trigger (branch, PR, tag, schedule) |
| Environment | Xcode version, macOS version |
| Actions | Build, Test, Analyze, Archive |
| Post-Actions | TestFlight, Notifications |

## Setting Up Workflow

### In Xcode

1. **Product → Xcode Cloud → Create Workflow**
2. Select repository and branch
3. Configure actions:
   - Build (required)
   - Test (optional)
   - Archive (for distribution)
4. Set post-actions:
   - Deploy to TestFlight
   - Notify via Slack

### Start Conditions

| Trigger | Use Case |
|---------|----------|
| Branch changes | CI on every push |
| Pull request | Validate PRs |
| Tag | Release builds |
| Schedule | Nightly builds |
| Manual | On-demand builds |

## Custom Scripts

Xcode Cloud supports custom scripts at specific points:

```
ci_scripts/
├── ci_post_clone.sh        # After repo clone
├── ci_pre_xcodebuild.sh    # Before build
└── ci_post_xcodebuild.sh   # After build
```

### ci_post_clone.sh

```bash
#!/bin/bash
set -e

# Install dependencies
if [ -f "Brewfile" ]; then
    brew bundle
fi

# Resolve Swift packages
swift package resolve

# Generate code if needed
if command -v sourcery &> /dev/null; then
    sourcery --config .sourcery.yml
fi
```

### ci_post_xcodebuild.sh

```bash
#!/bin/bash
set -e

# Generate release notes
if [ "$CI_XCODEBUILD_ACTION" = "archive" ]; then
    echo "Build: $CI_BUILD_NUMBER" > release_notes.txt
    echo "Commit: $CI_COMMIT" >> release_notes.txt
    git log -5 --oneline >> release_notes.txt
fi
```

## Environment Variables

Xcode Cloud provides these automatically:

| Variable | Description |
|----------|-------------|
| `CI` | Always "TRUE" |
| `CI_BUILD_NUMBER` | Incrementing build number |
| `CI_COMMIT` | Git commit SHA |
| `CI_BRANCH` | Branch name |
| `CI_TAG` | Git tag (if applicable) |
| `CI_PULL_REQUEST_NUMBER` | PR number (if PR build) |
| `CI_XCODEBUILD_ACTION` | build, test, or archive |
| `CI_ARCHIVE_PATH` | Path to .xcarchive |

## TestFlight Distribution

### Internal Testing

1. Archive action with "Deploy to TestFlight (Internal)"
2. Automatically available to team members
3. No review required

### External Testing

1. Archive action with "Deploy to TestFlight (External)"
2. Requires App Store review
3. Configure tester groups in App Store Connect

### Release Notes

```bash
# ci_post_xcodebuild.sh
if [ "$CI_XCODEBUILD_ACTION" = "archive" ]; then
    cat > "$CI_ARCHIVE_PATH/testflight_notes.txt" << EOF
Build $CI_BUILD_NUMBER

Changes:
$(git log -10 --oneline)
EOF
fi
```

## Workflow Examples

### PR Validation

| Setting | Value |
|---------|-------|
| Start Condition | Pull Request (main) |
| Actions | Build, Test |
| Post-Actions | None |

### Nightly Build

| Setting | Value |
|---------|-------|
| Start Condition | Schedule (daily 2 AM) |
| Actions | Build, Test, Analyze |
| Post-Actions | Slack notification |

### Release Build

| Setting | Value |
|---------|-------|
| Start Condition | Tag (v*) |
| Actions | Archive |
| Post-Actions | TestFlight (External) |

## Secrets Management

### In App Store Connect

1. Navigate to Xcode Cloud → Settings
2. Add environment variable with "Secret" type
3. Reference in scripts: `$SECRET_API_KEY`

### In ci_pre_xcodebuild.sh

```bash
#!/bin/bash
# Secrets available as environment variables
echo "API_KEY=$SECRET_API_KEY" >> .env
```

## Pricing (2025)

| Tier | Hours/Month | Cost |
|------|-------------|------|
| Free | 25 | $0 |
| Team | 100 | $14.99 |
| Pro | 250 | $44.99 |
| Enterprise | 1000 | $99.99 |

Free tier included with Apple Developer Program membership.

## Best Practices

1. **Separate workflows** for PR validation vs. release
2. **Cache dependencies** using Swift Package resolution
3. **Use secrets** for API keys, never commit
4. **Fail fast** - put quick tests first
5. **Notify on failure** via Slack/email
6. **Version lock Xcode** for reproducibility

## Troubleshooting

### Build Fails Intermittently

```bash
# ci_pre_xcodebuild.sh - Clean before build
xcodebuild clean \
  -scheme "$CI_XCODE_SCHEME" \
  -destination "generic/platform=iOS"
```

### Swift Package Resolution Fails

```bash
# ci_post_clone.sh
rm -rf .build
rm Package.resolved
swift package resolve
```

### Code Signing Issues

1. Check provisioning profiles in App Store Connect
2. Verify bundle ID matches
3. Use automatic signing in Xcode Cloud

## Integration with XcodeBuildMCP

For local testing of CI workflows:

```bash
# Run same build as CI
npx xcodebuildmcp@latest build \
  --scheme MyApp \
  --destination 'platform=iOS Simulator,name=iPhone 17'

# Run tests
npx xcodebuildmcp@latest test \
  --scheme MyApp \
  --destination 'platform=iOS Simulator,name=iPhone 17'
```

## Sources

- [Apple Xcode Cloud Documentation](https://developer.apple.com/documentation/xcode/xcode-cloud)
- [Configuring Workflows](https://developer.apple.com/documentation/xcode/configuring-your-first-xcode-cloud-workflow)
- [TestFlight Distribution](https://developer.apple.com/documentation/xcode/creating-a-workflow-that-builds-your-app-for-distribution)
