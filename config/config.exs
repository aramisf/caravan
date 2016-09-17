# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :caravan,
  ecto_repos: [Caravan.Repo]

# Configures the endpoint
config :caravan, Caravan.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rZrmhOoQNPM0OcAGqkdYAbes0LRQMhx7Q5z7b6HSM+ghYdPJ5YGTroxDGZ5zElL5",
  render_errors: [view: Caravan.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Caravan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure the authenticator
config :guardian, Guardian,
  issuer: "Caravan.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Caravan.GuardianSerializer,
  secret_key: "#{Mix.env}#{System.get_env("SECRET_KEY_BASE") || "SuPerseCret_aBraCadabrA"}"

# Configure the money lib
config :money,
  default_currency: :BRL,
  separator: ",",
  delimeter: ".",
  symbol: false,
  symbol_on_right: false,
  symbol_space: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
