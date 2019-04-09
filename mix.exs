defmodule Sortopoex.MixProject do
  use Mix.Project

  def project do
    [
      app: :sortopoex,
      aliases: aliases(),
      version: version_from_git_tag(),
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Sortopoex",
      source_url: "https://github.com/kakkoyun/sortopoex",
      homepage_url: "https://github.com/kakkoyun/sortopoex",
      docs: [
        main: "Sortopoex",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ],

      # Static Checks
      dialyzer: [
        ignore_warnings: "./.dialyzer-ignore.txt",
        plt_add_apps: [
          :mix
        ],
        plt_core_path: "./_dialyzer",
        plt_file: {:no_warn, "./_dialyzer/sortopoex.plt"},
        flags: [
          :no_undefined_callbacks,
          :unmatched_returns,
          :race_conditions,
          # :underspecs,
          :overspecs
          # :specdiffs
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sortopoex.Application, []},
      extra_applications: [:logger, :runtime_tools, :confex]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Core
      {:phoenix, "~> 1.4.3"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ranch_connection_drainer, "~> 0.1.0"},

      # Documentation
      {:ex_doc, "~> 0.20.1", only: :dev, runtime: false},

      # Static analyzers
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.7.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev], runtime: false},

      # Configuration and releases
      {:distillery, "~> 2.0"},
      {:confex, "~> 3.4.0"},
      {:confex_config_provider, "~> 0.1.0"}
    ]
  end

  defp aliases do
    [
      test: [
        "format --check-formatted",
        "credo --strict --color -a",
        # running tests last so that the arguments are passed to it
        "test"
      ],
      # Disable CSRF ignore, after fixing GraphiQL interface issues.
      check: [
        "inch",
        "sobelow --verbose --skip --ignore Config.HTTPS,Config.CSRF"
      ]
    ]
  end

  defp version_from_git_tag do
    case System.cmd("git", ["describe", "--always", "--tags", "--dirty"]) do
      {"v" <> version, 0} ->
        version |> String.trim()

      _ ->
        "0.0.0"
    end
  end
end
