# Hosting with Gigalixir


## Set up Gigalixir

See:

* https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html

Ensure these work:

```sh
gigalixir signin
gigalixir account
```

Create an app:

```sh
gigalixir create -n demo-app --cloud aws --region us-west-2
```


### Configure

Edit `config/prod.exs` and add configuration such as:

```exs
# ## Gigalixir releases via Mix
#
# TODO: upgrade this from Mix Releases to Elixir Releases to Distillery Releases

config :demo_app, MyAppWeb.Endpoint,
  http: [port: {:system, "PORT"}], # Possibly not needed, but doesn't hurt
  url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server: true

config :demo_app, CommissaryUx.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: 2 # Gigalixir free tier db only allows 4 connections. Rolling deploys need pool_size*(n+1) connections where n is the number of app replicas.
```


### Create buildpacks

Create buildpacks with current versions:

```sh
echo "elixir_version=1.11.0" > elixir_buildpack.config
echo "erlang_version=23.1.1" >> elixir_buildpack.config
echo "node_version=12.16.3" > phoenix_static_buildpack.config
```

Create database:

```sh
gigalixir pg:create
```

Verify: 

```sh
gigalixir pg
```


### Set environment

Create `./env/env-prod-gigalixir.txt` with the environment settings:

```ini
APP_NAME="demo-app"
DATABASE_URL="postgresql://gigalixir_admin:*@34.123.203.224:5432/e236ff24-fd43-4363-865e-accf1c176167"
```


### Deploy

Deploy `main` branch, which Gigalixir needs renamed to `master` branch, in order to satisfy a Gigalixir pre-commit hook:

```sh
git push gigalixir main:master
```

Migrate:

```sh
gigalixir run mix ecto.migrate
```

Run seeds in order:

```sh
gigalixir run -- mix run priv/repo/seeds/user.exs 
gigalixir run -- mix run priv/repo/seeds/group.exs 
gigalixir run -- mix run priv/repo/seeds/post.exs 
```

Summary to deploy:

```
git push gigalixir main:master
gigalixir run mix ecto.migrate
gigalixir ps:restart
```


### Create a custom domain

See:

* https://gigalixir.readthedocs.io/en/latest/domain.html

Run:

```sh
gigalixir domains:add app.example.com
```
