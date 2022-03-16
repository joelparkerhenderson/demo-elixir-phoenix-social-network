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


### Use git (optional)

Create a git repo.

If you're using an older version of git, then set the initial branch name `main` instead of `master`.

```sh
git init --initial-branch=main
git add --all
git commit -am "Run mix phx.new demo_app"
```


### Use GitHub (optional)

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
defmodule Social.Schema do
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
config :demo_app, Social.Repo,
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
