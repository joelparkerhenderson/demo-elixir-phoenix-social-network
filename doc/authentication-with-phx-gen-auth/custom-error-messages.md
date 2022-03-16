# Custom error messages

Consider:

* https://stackoverflow.com/questions/32032246/how-to-add-a-custom-error-message-for-a-required-field-in-phoenix-framework

Ecto 2.1:

```elixir
def changeset(model, params \\ :empty) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> required_error_messages("no way it's empty")
end

def required_error_messages(changeset, new_error_message) do
  update_in changeset.errors, &Enum.map(&1, fn
    {key, {"can't be blank", validations}} -> {key, {new_error_message, validations}}
    {_key, _error} = tuple  -> tuple
  end)
end
```
