# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kodala,
  ecto_repos: [Kodala.Repo]

# Configures the endpoint
config :kodala, KodalaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KodalaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kodala.PubSub,
  live_view: [signing_salt: "ONtXofsq"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kodala, Kodala.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ash
config :ash, :use_all_identities_in_manage_relationship?, false
config :kodala, :ash_apis, [Kodala.Desk, Kodala.Accounts]
config :ash_graphql, :default_managed_relationship_type_name_template, :action_name



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
