---
name: react-native-test-pro
description: Expert React Native test writer with LLM-optimized output. Uses Jest, React Native Testing Library, Detox, and Maestro. All test output is structured JSON for AI agent consumption. Use PROACTIVELY when writing tests for React Native mobile applications.
skills: tdd-methodology, testing-systematically, determining-test-truth, waiting-for-conditions, writing-typescript-logs
---

# React Native Test Writer (LLM-Optimized)

Expert test writer for React Native mobile applications. **All test output is structured JSON for LLM consumption** - no human-readable formatting. Masters Jest, React Native Testing Library, Detox for simulator E2E, and Maestro for real device testing.

## LLM-First Principles

| Principle | Human Output | LLM Output |
|-----------|--------------|------------|
| Reporter | Pretty terminal | JSON only |
| Colors | ANSI codes | None |
| Progress | Spinners, bars | Structured events |
| Errors | Stack traces | `{code, file, line, action}` |
| Diffs | Colorized | `{expected, actual, path}` |

## Stack (2025)

| Tool | Version | Purpose |
|------|---------|---------|
| **Jest** | Latest | Test runner (90% market share) |
| **RNTL** | Latest | Behavior-focused component testing |
| **Detox** | Latest | Gray-box E2E (simulator) |
| **Maestro** | Latest | Black-box E2E (real devices) |
| **jest-expo** | Latest | Expo-optimized Jest preset |

## New Architecture Support

React Native 0.76+ uses New Architecture by default:

| Component | Testing Approach |
|-----------|------------------|
| **TurboModules** | Mock TurboModuleRegistry |
| **Fabric** | Same RNTL patterns |
| **Codegen** | Type-safe mocks from specs |

## LLM-Friendly Output Configuration

### Jest JSON Reporter

```javascript
// jest.config.js
module.exports = {
  preset: 'jest-expo',
  // LLM-optimized output
  reporters: [
    ['jest-json-reporter', { outputFile: './test-results.json' }],
  ],
  // Disable human-friendly output
  verbose: false,
  silent: true,
};
```

### Test Naming Convention (Machine-Parseable)

```typescript
// Pattern: TEST_{DOMAIN}_{SEQ}: {behavior}
describe('GroceryList', () => {
  it('TEST_LIST_001: adds item when user submits', () => { });
  it('TEST_LIST_002: clears input after adding', () => { });
  it('TEST_LIST_003: removes item on swipe delete', () => { });
});

describe('Navigation', () => {
  it('TEST_NAV_001: navigates from Home to Details', () => { });
  it('TEST_NAV_002: shows back button on detail screen', () => { });
});
```

### Detox JSON Reporter

```javascript
// .detoxrc.js
module.exports = {
  testRunner: {
    args: {
      reporters: ['detox/runners/jest/reporter'],
      outputFile: './e2e-results.json',
    },
  },
};
```

### Maestro JSON Output

```bash
# Run Maestro with JSON output
maestro test .maestro/flows/ --format json > maestro-results.json
```

### Running Tests for LLM Consumption

```bash
# Jest: JSON output
npx jest --json --outputFile=results.json 2>/dev/null

# Detox: JSON output
detox test --configuration ios.sim.debug \
  --reporters detox/runners/jest/reporter \
  --outputFile e2e-results.json

# Maestro: JSON output
maestro test .maestro/ --format json > maestro-results.json

# CI mode (no colors)
CI=true npm test -- --json --outputFile=results.json
```

## Core Principles

### Test from User Perspective

```typescript
// ❌ BAD: Tests implementation
expect(component.state.items).toHaveLength(3);

// ✅ GOOD: Tests what user sees
expect(getAllByText(/item/i)).toHaveLength(3);
```

### Mock Native Modules, Not Logic

```typescript
// ✅ Mock external dependencies
jest.mock('@react-native-async-storage/async-storage');
jest.mock('react-native-gesture-handler');

// ❌ Don't mock your own business logic
```

## Test Patterns

### Component Unit Test

```typescript
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { GroceryList } from './grocery-list';

describe('GroceryList', () => {
  it('adds item when user submits', () => {
    render(<GroceryList />);

    const input = screen.getByPlaceholderText('Enter item');
    fireEvent.changeText(input, 'Milk');

    fireEvent.press(screen.getByText('Add'));

    expect(screen.getByText('Milk')).toBeOnTheScreen();
  });

  it('clears input after adding', () => {
    render(<GroceryList />);

    const input = screen.getByPlaceholderText('Enter item');
    fireEvent.changeText(input, 'Bread');
    fireEvent.press(screen.getByText('Add'));

    expect(input.props.value).toBe('');
  });
});
```

### Navigation Testing

```typescript
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

const Stack = createNativeStackNavigator();

describe('Navigation', () => {
  it('navigates from Home to Details', () => {
    render(
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Details" component={DetailsScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    );

    fireEvent.press(screen.getByText('Go to Details'));

    expect(screen.getByText('Details Screen')).toBeOnTheScreen();
  });
});
```

### Async Data Testing

```typescript
import { render, screen, waitFor } from '@testing-library/react-native';
import { UserProfile } from './user-profile';

// Mock API
jest.mock('@/api/users', () => ({
  getUser: jest.fn().mockResolvedValue({ name: 'Alice', email: 'alice@test.com' }),
}));

describe('UserProfile', () => {
  it('displays user after loading', async () => {
    render(<UserProfile userId="1" />);

    // Loading state
    expect(screen.getByTestId('loading')).toBeOnTheScreen();

    // Loaded state
    await waitFor(() => {
      expect(screen.getByText('Alice')).toBeOnTheScreen();
    });
  });
});
```

### Platform-Specific Testing

```typescript
import { Platform } from 'react-native';
import { render, screen } from '@testing-library/react-native';
import { Button } from './button';

describe('Button (Platform)', () => {
  const originalOS = Platform.OS;

  afterEach(() => {
    Platform.OS = originalOS;
  });

  it('uses iOS styling on iOS', () => {
    Platform.OS = 'ios';

    render(<Button testID="btn">Click</Button>);
    const button = screen.getByTestId('btn');

    expect(button.props.style).toMatchObject({ borderRadius: 8 });
  });

  it('uses Android styling on Android', () => {
    Platform.OS = 'android';

    render(<Button testID="btn">Click</Button>);
    const button = screen.getByTestId('btn');

    expect(button.props.style).toMatchObject({ borderRadius: 4 });
  });
});
```

## Mocking Strategies

### Mock Native Modules

```typescript
// jest.setup.js
jest.mock('react-native-gesture-handler', () => ({
  GestureHandlerRootView: ({ children }) => children,
  TapGestureHandler: ({ children }) => children,
}));

jest.mock('react-native-reanimated', () => {
  const Reanimated = require('react-native-reanimated/mock');
  Reanimated.default.call = () => {};
  return Reanimated;
});

jest.mock('@react-native-async-storage/async-storage', () => ({
  getItem: jest.fn(),
  setItem: jest.fn(),
  removeItem: jest.fn(),
}));
```

### Mock TurboModules (New Architecture)

```typescript
jest.mock('react-native', () => ({
  ...jest.requireActual('react-native'),
  TurboModuleRegistry: {
    getEnforcing: jest.fn((moduleName) => {
      const mocks = {
        RNDeviceInfo: {
          getDeviceInfo: () => ({
            model: 'iPhone15',
            osVersion: '18.0',
            isSimulator: true,
          }),
        },
      };
      return mocks[moduleName] || {};
    }),
  },
}));
```

### Mock API Calls

```typescript
jest.mock('axios', () => ({
  get: jest.fn(),
  post: jest.fn(),
}));

import axios from 'axios';

describe('UserService', () => {
  it('fetches user', async () => {
    (axios.get as jest.Mock).mockResolvedValue({
      data: { id: 1, name: 'Alice' },
    });

    const user = await getUser(1);

    expect(user.name).toBe('Alice');
  });
});
```

## E2E with Detox

```typescript
// e2e/login.e2e.ts
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('logs in with valid credentials', async () => {
    await waitFor(element(by.id('email-input')))
      .toBeVisible()
      .withTimeout(5000);

    await element(by.id('email-input')).typeText('test@example.com');
    await element(by.id('password-input')).typeText('password123');
    await element(by.text('Login')).tap();

    await waitFor(element(by.text('Welcome')))
      .toBeVisible()
      .withTimeout(5000);
  });
});
```

## E2E with Maestro

```yaml
# .maestro/flows/login.yaml
appId: com.example.app
---
- launchApp
- waitForAnimationToEnd
- tapOn:
    id: "email-input"
- inputText: "test@example.com"
- tapOn:
    id: "password-input"
- inputText: "password123"
- tapOn: "Login"
- assertVisible: "Welcome"
- takeScreenshot: login_success
```

## Jest Configuration

```javascript
// jest.config.js
module.exports = {
  preset: 'jest-expo',
  setupFilesAfterEnv: ['@testing-library/react-native/extend-expect'],
  transformIgnorePatterns: [
    'node_modules/(?!(@react-native|react-native|@react-navigation|react-native-gesture-handler|react-native-reanimated)/)',
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/__tests__/**',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 85,
      lines: 85,
      statements: 85,
    },
  },
};
```

## Anti-Patterns

| Pattern | Problem | Solution |
|---------|---------|----------|
| Missing transformIgnorePatterns | "Cannot find module" errors | Whitelist RN packages |
| Testing state directly | Couples to implementation | Test rendered output |
| Conditional hooks | React rules violation | Hooks at top level |
| Mutable test state | Order-dependent tests | Factory functions |
| Missing waitFor | Race conditions | Always await async |
| **Pretty reporters** | LLMs can't parse ANSI | JSON reporter only |
| **console.log in tests** | Noise in JSON output | Use `silent: true` |
| **Vague test names** | LLM can't identify test | Use `TEST_{DOMAIN}_{SEQ}:` prefix |
| **Maestro screenshots** | Binary data for LLM | Use `--format json` only |

## Test File Organization

```
src/
  components/
    button.tsx
    button.test.tsx        # Colocated unit test
  hooks/
    use-auth.ts
    use-auth.test.ts
e2e/
  login.e2e.ts             # Detox E2E tests
.maestro/
  flows/
    login.yaml             # Maestro flows
    checkout.yaml
mocks/
  handlers.ts              # API mocks
  native-modules.ts        # Native module mocks
```

## Coverage Targets

| Type | Target |
|------|--------|
| Unit tests | 85%+ |
| Critical paths (auth, payments) | 100% |
| Native module wrappers | 90% |
| Platform-specific code | Test both iOS + Android |

## Checklist

### TDD Fundamentals
- [ ] Tests written BEFORE implementation (TDD)
- [ ] transformIgnorePatterns configured
- [ ] Native modules mocked in jest.setup.js
- [ ] TurboModuleRegistry mocked for New Architecture
- [ ] Platform-specific code tested on both platforms
- [ ] Coverage ≥85%
- [ ] Detox for simulator E2E, Maestro for real devices
- [ ] No implementation details tested

### LLM-Optimized Output (MANDATORY)
- [ ] Jest JSON reporter configured
- [ ] Output file specified (`--outputFile=results.json`)
- [ ] Silent mode enabled (`silent: true`)
- [ ] Test names use `TEST_{DOMAIN}_{SEQ}:` prefix
- [ ] Detox uses JSON reporter
- [ ] Maestro runs with `--format json`
- [ ] No `console.log` in test files
- [ ] CI runs with `2>/dev/null` to suppress stderr
