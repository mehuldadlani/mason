# When Clause Feature for Mason Bricks

## Overview

The `when` clause feature allows brick variables to be conditionally prompted based on previously collected variables. This makes bricks much more user-friendly by only asking relevant questions.

## Problem Solved

Before this feature, users would be bombarded with irrelevant questions. For example, if someone selected "no_auth" as their authentication method, they would still be asked:

- "Do you want to enable Google Sign-In with Firebase?"
- "Do you want to enable Apple Sign-In with Firebase?"

These questions don't make sense when no authentication is selected!

## Solution

The `when` clause allows you to specify conditions for when a variable should be prompted:

```yaml
vars:
  auth_method:
    type: enum
    values: [firebase, custom_jwt, no_auth]
    default: firebase
    prompt: Which authentication method do you want to use?

  firebase_google:
    type: boolean
    default: true
    prompt: Do you want to enable Google Sign-In with Firebase?
    when: auth_method == firebase  # Only show if firebase is selected

  firebase_apple:
    type: boolean
    default: true
    prompt: Do you want to enable Apple Sign-In with Firebase?
    when: auth_method == firebase  # Only show if firebase is selected
```

## Supported Operators

The `when` clause supports the following operators:

### Equality Operators
- `==` for equality: `auth_method == firebase`
- `!=` for inequality: `feature_enabled != false`

### List Operators
- `in` for checking if a value is in a list: `platform in [android, ios, both]`
- `not in` for checking if a value is not in a list: `auth_type not in [google, apple]`

### Boolean Checks
- Simple variable name for boolean checks: `enable_analytics`

## Examples

### Authentication Flow
```yaml
vars:
  auth_method:
    type: enum
    values: [firebase, custom_jwt, no_auth]
    default: firebase
    prompt: Which authentication method do you want to use?

  firebase_google:
    type: boolean
    default: true
    prompt: Do you want to enable Google Sign-In with Firebase?
    when: auth_method == firebase

  firebase_apple:
    type: boolean
    default: true
    prompt: Do you want to enable Apple Sign-In with Firebase?
    when: auth_method == firebase

  custom_jwt_secret:
    type: string
    prompt: What is your JWT secret key?
    when: auth_method == custom_jwt
```

### Platform-Specific Configuration
```yaml
vars:
  platform:
    type: enum
    values: [android, ios, both]
    default: both
    prompt: Which platform do you want to target?

  android_package:
    type: string
    prompt: What is your Android package name?
    when: platform in [android, both]

  ios_bundle:
    type: string
    prompt: What is your iOS bundle identifier?
    when: platform in [ios, both]
```

### Feature Flags
```yaml
vars:
  enable_analytics:
    type: boolean
    default: true
    prompt: Do you want to enable analytics?

  analytics_provider:
    type: enum
    values: [firebase_analytics, mixpanel, amplitude]
    default: firebase_analytics
    prompt: Which analytics provider do you want to use?
    when: enable_analytics == true
```

## Implementation Details

### Files Modified

1. **`packages/mason/lib/src/brick_yaml.dart`**
   - Added `when` field to `BrickVariableProperties`
   - Updated all named constructors to include `when` parameter

2. **`packages/mason/lib/src/condition_evaluator.dart`** (new file)
   - Implements condition evaluation logic
   - Supports equality, inequality, in, not in, and boolean operators
   - Handles edge cases gracefully

3. **`packages/mason_cli/lib/src/commands/make.dart`**
   - Modified variable processing loop to check `when` conditions
   - Skips variables that don't meet their conditions

4. **`extensions/vscode/schema/brick.yaml.schema.json`**
   - Added `when` property to all variable type definitions
   - Updated JSON schema for validation

### SDK Requirements

Updated SDK constraints to `^3.8.0` to support null-aware elements in generated code.

## Testing

### Unit Tests
- **`packages/mason/test/src/condition_evaluator_test.dart`**: Comprehensive tests for condition evaluation
- **`packages/mason_cli/test/commands/make_when_test.dart`**: Tests for brick YAML structure with when clauses

### Demo Brick
- **`bricks/when_demo/`**: Complete example brick demonstrating all when clause features

## Usage

1. Add a `when` property to any variable in your `brick.yaml`
2. Use supported operators to define conditions
3. Variables will only be prompted when their conditions are met

## Benefits

1. **Better User Experience**: Users only see relevant questions
2. **Cleaner Bricks**: No more confusing, irrelevant prompts
3. **Flexible Logic**: Support for various conditional scenarios
4. **Backward Compatible**: Existing bricks continue to work unchanged

## Future Enhancements

Potential future improvements could include:
- More complex logical operators (AND, OR)
- Nested conditions
- Mathematical comparisons for numbers
- String pattern matching

## Migration Guide

Existing bricks don't need any changes - the `when` clause is completely optional. To add conditional logic to existing bricks:

1. Add `when` properties to variables that should be conditional
2. Test the brick to ensure conditions work as expected
3. Update documentation to explain the conditional behavior 