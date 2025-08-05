# When Clause Demo

This project was generated using the `when_demo` brick with the following configuration:

## Authentication
- **Method**: no_auth



## Platform Configuration
- **Target Platform**: both



## Analytics
- **Analytics Enabled**: true


## How the When Clause Works

This brick demonstrates how the `when` clause can be used to conditionally show variables based on previous answers:

1. **Equality operators**: `auth_method == firebase`
2. **Inequality operators**: `feature_enabled != false`
3. **In operators**: `platform in [android, both]`
4. **Not in operators**: `auth_type not in [google, apple]`

The variables are only prompted when their conditions are met, making the brick much more user-friendly! 