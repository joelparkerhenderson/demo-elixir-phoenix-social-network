# Elixir Phoenix demo social network

* [Create Phoenix app](#create-phoenix-app)
  * [Create an app](#create-an-app)
  * [Try the server](#try-the-server)
  * [Use git](#use-git)
  * [Use GitHub](#use-github)


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


