# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :despite, Despite.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "CMn37uWwird54BCrLKz8a1DClTg4DJeyEOriI/Rz3S3B/+gDFJVZuQ+zAieoYz5D",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Despite.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :despite, ecto_repos: [Despite.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :ex_twilio, account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token: System.get_env("TWILIO_AUTH_TOKEN"),
  phone_number: System.get_env("TWILIO_PHONE_NUMBER")

config :guardian, Guardian,
  issuer: "Despite",
  ttl: { 1, :day },
  verify_issuer: true, # optional
  secret_key: fn ->
    JOSE.JWK.from_pem_file(System.get_env("GUARDIAN_KEY_FILE"))
  end,
  serializer: Despite.GuardianSerializer
