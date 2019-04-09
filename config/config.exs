# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# General application configuration
version_from_git_tag =
  case System.cmd("git", ["describe", "--always", "--tags", "--dirty"]) do
    {"v" <> version, 0} ->
      version |> String.trim()

    _ ->
      "0.0.0"
  end

# Configures the endpoint
config :sortopoex, SortopoexWeb.Endpoint,
  http: [
    port: {:system, :integer, "SORTOPOEX_INTERNAL_PORT", 4000},
    protocol_options: [
      max_request_line_length: 8192,
      max_header_value_length: 8192
    ]
  ],
  url: [
    scheme: {{:via, Sortopoex.Config}, "SORTOPOEX_EXPOSED_VIA_SSL"},
    host: {:system, "SORTOPOEX_EXPOSED_HOST", "localhost"},
    port: {:system, :integer, "SORTOPOEX_EXPOSED_PORT", 4000}
  ],
  secret_key_base: "",
  secret_key_base:
    {:system, "SORTOPOEX_SECRET_KEY_BASE", "ayo9bJVKOUDH5WnPr9M+f9bW6PdyfomN2Qxnd/5huRpIs8sW6CnAzPVplg2Osq9u"},
  render_errors: [view: SortopoexWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Sortopoex.PubSub, adapter: Phoenix.PubSub.PG2],
  log_level: {:system, :atom, "SORTOPOEX_LOG_LEVEL", :debug}

# Logger
config :logger,
  truncate: :infinity,
  utc_log: true,
  console: [
    metadata: [:request_id, :module, :function],
    format: "$time $metadata[$level] $levelpad$message\n"
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
