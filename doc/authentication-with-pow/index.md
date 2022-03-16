# Authentication with Pow

We want to use Pow, and its extensions, and generate our own templates.

This section describes how to create all of this at one time, and also use comments to wait to enable the extensions.


## Install

See:

* https://hexdocs.pm/pow/

* https://curiosum.dev/blog/elixir-phoenix-liveview-messenger-part-3


Edit `mix.exs` and add the following to deps function:

```exs
{:pow, "~> 1.0.21"}
```

Run:

```sh
mix deps.get
mix pow.install
mix pow.phoenix.gen.templates
mix pow.extension.ecto.gen.migrations \
  --extension PowResetPassword \
  --extension PowEmailConfirmation \
  --extension PowPersistentSession \
  --extension PowInvitation
mix ecto.migrate
mix pow.phoenix.gen.templates
mix pow.extension.phoenix.gen.templates \
  --extension PowResetPassword \
  --extension PowEmailConfirmation \
  --extension PowPersistentSession \
  --extension PowInvitation
```


## Configure

Edit `config/config.exs` and add:

```exs
# Configure Pow authentication
config :commissary_ux, :pow,
  user: CommissaryUx.Users.User,
  repo: CommissaryUx.Repo,
  extensions: [
    #TODO enable
    # PowResetPassword,
    # PowEmailConfirmation,
    # PowPersistentSession,
    # PowInvitation,
  ],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: MyAppWeb
```


## Add session

Edit `lib/commissary_ux_web/endpoint.ex` and add `plug Pow.Plug.Session…` line below, in between `plug Plug.Session…` and `plug MyAppWeb.Router`:


```ex
defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :commissary_ux
  # ...

  plug Plug.Session, @session_options
  plug Pow.Plug.Session, otp_app: :commissary_ux
  plug MyAppWeb.Router
end
```


## Add routes

Edit `lib/commissary_ux_web/router.ex` and add the Pow routes:

```ex
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [
      #TODO enable
      # PowResetPassword,
      # PowEmailConfirmation,
      # PowPersistentSession,
      # PowInvitation,
    ]

  # ... pipelines

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    #TODO enable
    # pow_extension_routes()
  end

  scope "/", MyAppWeb do
    pipe_through [:browser, :protected]

    # Add your protected routes here
  end

  # ... routes
end
```


## Fix schema 

Pow generates a user schema.

   * Pow generates with `Ecto.Schema` which we must replace with `CommissaryUx.Schema` in order to get binary ids.

File:

```ex
defmodule CommissaryUx.Users.User do
  use CommissaryUx.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [
      #TODO enable
      # PowResetPassword,
      # PowEmailConfirmation,
      # PowPersistentSession,
      # PowInvitation,
    ]

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    #TODO enable
    # |> pow_extension_changeset(attrs)
  end

end
```


## Modify templates

Edit the templates as you wish:

```sh
lib/commissary_ux_web/templates/pow/registration/new.html.eex
lib/commissary_ux_web/templates/pow/registration/edit.html.eex
lib/commissary_ux_web/templates/pow/session/new.html.eex
lib/commissary_ux_web/templates/pow_reset_password/reset_password/new.html.eex
lib/commissary_ux_web/templates/pow_reset_password/reset_password/edit.html.eex
lib/commissary_ux_web/templates/pow_invitation/invitation/new.html.eex
lib/commissary_ux_web/templates/pow_invitation/invitation/show.html.eex
lib/commissary_ux_web/templates/pow_invitation/invitation/edit.html.eex
```


## Add links

Edit `lib/commissary_ux_web/templates/layout/root.html.eex` and see this line:

```eex
<li><a href="https://hexdocs.pm/phoenix/overview.html">Get Started</a></li>
```

Append this:

```eex
<%= if Pow.Plug.current_user(@conn) do %>
  <li><%= link "Logout", to: Routes.pow_session_path(@conn, :delete), method: :delete %></li>
<% else %>
  <li><%= link "Login", to: Routes.pow_session_path(@conn, :new) %></li>
  <li><%= link "Join", to: Routes.pow_registration_path(@conn, :new) %></li>
<% end %>
```


```sh
mix test && git add --all && git commit -am "Add Pow for authentication"
```


## Prepare for test

See:

  * https://elixirforum.com/t/controller-test-with-pow/18926

When we create a typical resource controller test for a typical protected route, then we will need to add a current user to the connection, and also need to keep track of the connection across redirect tests.

This is because of how Phoenix recycles connections in tests. The response conn will have a :state key set to :sent so when it’s reused the test helpers in Phoenix will build a new connection and only copy over headers e.g. cookies. Assigns will not be preserved.

Example test:

```ex
# Extend a connection by using Pow to assign a current user,
# in order to test Pow protected routes and also redirects.
setup %{conn: conn} do
  current_user = %CommissaryUx.Users.User{email: "test@example.com"}
  connx = Pow.Plug.assign_current_user(conn, current_user, [])

  {:ok, conn: conn, connx: connx}
end

test "redirect when data is valid", %{connx: connx} do
  conn = post(connx, Routes.item_path(connx, :create), item: @create_attrs)

  assert %{id: id} = redirected_params(conn)
  assert redirected_to(conn) == Routes.item_path(conn, :show, id)

  conn = get(conn_pow, Routes.item_path(connx, :show, id))
  assert html_response(conn, 200) =~ "Show"
end
```

Optional regex helpers:

```sh
gsed -i 's/\bconn: conn\b/connx: connx/g; s/\(get\|post\|put\|delete\|path\)(conn,/\1(connx,/g' foo_controller_test.exs
```


## Custom controllers

See https://hexdocs.pm/pow/custom_controllers.html

Example HTML for root layout, using a form in order to do the delete action even without JavaScript:

```eex
<%= if Pow.Plug.current_user(@conn) do %>
    <%= form_for @conn, Routes.session_path(@conn, :delete), [method: :delete, as: :user], fn _ -> %>
        <%= submit "Logout" %>
    <% end %>
<% else %>
    <%= link "Login", to: Routes.session_path(@conn, :new) %> &bull;
    <%= link "Register", to: Routes.registration_path(@conn, :new) %>
<% end %>
