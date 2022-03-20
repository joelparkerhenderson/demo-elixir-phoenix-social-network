# Elixir Phoenix demo social network

* [Create Phoenix app](#create-phoenix-app)
  * [Create an app](#create-an-app)
  * [Try the server](#try-the-server)
  * [Use git](#use-git)
  * [Use GitHub](#use-github)
  * [Add gitignore rules](#add-gitignore-rules)
* [Enable binary id](#enable-binary-id)
  * [Configure schema with binary id](#configure-schema-with-binary-id)
  * [Configure migration primary key](#configure-migration-primary-key)
* [Add authentication](#add-authentication)
* [Add fonts](#add-fonts)
* [Add static files](#add-static-files)
  * [Enable static files](#enable-static-files)
  * [Create a content delivery area](#create-a-content-delivery-area)
* [Add dependencies](#add-dependencies)
* [Generate](#generate)
  * [Generate user](#generate-user)
  * [Generate group](#generate-group)
  * [Generate post](#generate-post)
* [Add user acceptance testing](#add-user-acceptance-testing)
* [Add app hosting via Gigalixir](#add-app-hosting-via-gigalixir)
* [Add asset hosting via Cloudinary](#add-asset-hosting-via-cloudinary)


## Introduction

This demonstrates:

* The Elixir programming language

* The Phoenix web framework

* How to create a social network application


## Create Phoenix app


### Create an app

Create:

```sh
mix phx.new demo_app --binary-id --install --live
cd demo_app
MIX_ENV=dev mix deps.get
MIX_ENV=dev mix compile
MIX_ENV=dev mix ecto.reset
MIX_ENV=test mix deps.get
MIX_ENV=test mix compile
MIX_ENV=test mix ecto.reset
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile
MIX_ENV=prod mix ecto.reset
mix test
```


### Try the server

If you want to try running the Phoenix server:

```sh
mix phx.server
```


### Use git

Create a git repo.

If you're using an older version of git, then set the initial branch name `main` instead of `master`.

```sh
git init --initial-branch=main
git add --all
git commit -am "Run mix phx.new demo_app"
```


### Use GitHub

Create a GitHub repo. 

If you're using GitHub, GitLab, or any similar service, then use your own username and your choice of repository name.

```sh
git remote add origin git@github.com:joelparkerhenderson/demo-elixir-phoenix-social-network.git
git branch -M main
git push -u origin main
```


### Add gitignore rules

Edit `.gitignore` and add these:

```gitignore
# Dot files: ignore all, then accept specific files and patterns.
.*
!.gitignore
!.*.gitignore
!.*[-_.]example
!.*[-_.]example[-_.]*
!.*.gpg

# Env files: ignore all, then accept specific files and patterns.
env
env[-_.]*
!env[-_.]example
!env[-_.]example[-_.]*
!env[-_.]gpg
!env[-_.]*.gpg
```

Run:

```sh
git commit -m "Add gitignore rules for dot files and env files" .gitignore 
```


## Enable binary id


### Configure schema with binary id

We prefer our database primary keys to use binary id values.

We created our app with binary id values as the default. If we hadn't created our app that way, and instead we wanted to add binary id values later on, here's a way to do it.

See:

* https://hexdocs.pm/ecto/Ecto.Schema.html#module-schema-attributes

Create file `lib/demo_app/schema.ex`:

```ex
defmodule Demo.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
```

```sh
mix test && git add --all && git commit -am "Add schema with binary id"
```


### Configure migration primary key

Edit `config/{dev,test}.exs` and add `migration_primary_key` such as:

```
config :demo_app, Demo.Repo,
  ...
  migration_primary_key: [name: :id, type: :binary_id]
```

```sh
mix test && git add --all && git commit -am "Add migration primary key"
```


## Add authentication

See [doc/authentication-via-phx.md](doc/authentication-via-phx.md)

See [doc/authentication-via-pow.md](doc/authentication-via-pow.md)


## Add fonts

See [doc/fonts-via-webpack-and-scss.md](doc/fonts-via-webpack-and-scss.md)


## Add static files


### Enable static files

Edit `.gitignore` and comment out `/priv/static/`.

```sh
git add --all && git commit -am "Add static files"
```

### Create a content delivery area

Edit `lib/demo_web/endpoint.ex` and add `cdn`:

```
plug Plug.Static,
  at: "/",
  from: :demo,
  gzip: false,
  only: ~w(cdn css fonts images js favicon.ico robots.txt)
```


## Add dependencies


Add dependencies that we expect to use:

```elixir
# ExMachina makes it easy to create test data and associations. 
# https://github.com/thoughtbot/ex_machina
{:ex_machina, "~> 2.4"},

# Bamboo provides email integration capabilties.
# https://github.com/thoughtbot/bamboo
{:bamboo, "~> 1.6"},

# Brady provides helper functions for use within Phoenix templates.
# https://github.com/thoughtbot/brady
{:brady, "~> 0.0.9"},

# Formulator is a library for Phoenix forms.
# https://github.com/thoughtbot/formulator
{:formulator, "~> 0.2.0"},

# Guardian authentication library for use with Elixir applications.
# https://github.com/ueberauth/guardian
{:guardian, "~> 2.0"},
```


## Generate


### Generate user

Run: `generators/user.sh`


Edit `lib/demo_app_web/templates/profile/index.html.eex` and delete:

```eex
<th>Json</th>
```

```eex
<td><%= profile.json %></td>
```

Edit `lib/demo_app_web/templates/profile/show.html.eex` and delete:

```eex
<li>
  <strong>Json:</strong>
  <%= @user.json %>
</li>
```

Edit `lib/demo_app_web/templates/profile/form.html.eex` and delete:

```eex
<%= label f, :json %>
<%= text_input f, :json %>
<%= error_tag f, :json %>
```

Test:

```
mix test
```


### Generate group

Run: `generators/group.sh`

Make adjustments as in the section above.


### Generate post

Run: `generators/post.sh`

Make adjustments as in the section above.


## Add user acceptance testing

We use Wallaby. Other choices we considered: Hound, Cypress.

https://hashrocket.com/blog/posts/integration-testing-phoenix-with-wallaby


## Add app hosting with Gigalixir

See <doc/app-hosting-with-gigalixir.md>


## Add asset hosting via Cloudinary

See <https://cloudinary.com/>
