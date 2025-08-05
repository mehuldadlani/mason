# When Clause Demo

This project was generated using the `when_demo` brick with the following configuration:

## Authentication
- **Method**: {{auth_method}}
{{#auth_method == firebase}}
- **Google Sign-In**: {{firebase_google}}
- **Apple Sign-In**: {{firebase_apple}}
{{/auth_method == firebase}}
{{#auth_method == custom_jwt}}
- **JWT Secret**: {{custom_jwt_secret}}
{{/auth_method == custom_jwt}}

## Platform Configuration
- **Target Platform**: {{platform}}
{{#platform in [android, both]}}
- **Android Package**: {{android_package}}
{{/platform in [android, both]}}
{{#platform in [ios, both]}}
- **iOS Bundle**: {{ios_bundle}}
{{/platform in [ios, both]}}

## Analytics
- **Analytics Enabled**: {{enable_analytics}}
{{#enable_analytics == true}}
- **Analytics Provider**: {{analytics_provider}}
{{/enable_analytics == true}}

## How the When Clause Works

This brick demonstrates how the `when` clause can be used to conditionally show variables based on previous answers:

1. **Equality operators**: `auth_method == firebase`
2. **Inequality operators**: `feature_enabled != false`
3. **In operators**: `platform in [android, both]`
4. **Not in operators**: `auth_type not in [google, apple]`

The variables are only prompted when their conditions are met, making the brick much more user-friendly! 