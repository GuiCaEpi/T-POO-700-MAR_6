# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :time_manager,
  namespace: Todolist,
  ecto_repos: [Todolist.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :time_manager, TodolistWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TodolistWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Todolist.PubSub,
  live_view: [signing_salt: "Wgm3lA6j"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :time_manager, Todolist.Mailer, adapter: Swoosh.Adapters.Local

config :time_manager, TodolistWeb.Auth.Guardian,
  issuer: "time_manager",
  secret_key: "VKWceKFGZq7Pf0SvzMLweK0PfrAjPT8c2EeswEzXNpS7IOufTCj7WTvOiEplk20L"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
