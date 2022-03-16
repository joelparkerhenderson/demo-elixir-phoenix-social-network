# Use shorter passwords

To enable shorter passwords, such as 9 characters instead of the default 12 characters, we need to adjust the tests. 

A few approaches:

* Change the password length hardcoded numbers (from 12 to 9) and the password text hardcoded strings (from "too short" to "short"). 

* Change from hardcoded to application config.

* Change from hardcoded to constants.

For the app, there's one place to change. 

Edit `lib/demo-app/accounts/user.ex` and add:

```elixir
@password_length_min 8
@password_length_max 80
```

Find…

```elixir
|> validate_length(:password, min: 12, max: 80)
```

…replace:

```elixir
|> validate_length(:password, min: @password_length_min, max: @password_length_max)
```

For the tests, there are multiple places to change.

Edit these files:

```sh
test/demo_app/accounts_test.exs
test/demo_app_web/user_registration_controller_test.exs
test/demo_app_web/user_reset_password_controller_test
test/demo_app_web/user_settings_controller_test.exe
```

Add:

```elixir
@password_length_min 8
@password_length_max 80
@password_that_is_too_short String.duplicate("x", @password_length_min - 1)
@password_that_is_too_long String.duplicate("x", @password_length_max + 1)
```

Find…

```elixir
password: too_long
```

…replace:

```elixir
password: @password_that_is_too_long
```

Find…

```elixir
password: "too short"
```

…replace:

```elixir
password: @password_that_is_too_short
```

Find…

```elixir
password: "not valid",
```
…and if the "not valid" intention is that the password is too short, then replace:

```elixir
password: @password_that_is_too_short
```

Find…

```elixir
too_long = String.duplicate("db", 100)
```

…and if the intention is password validation then delete the line.
