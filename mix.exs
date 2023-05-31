defmodule BuffEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :buff_ex,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        credo: :test,
        coveralls: :test,
        doctor: :test,
        coverage: :test,
        dialyzer: :test,
        "coveralls.lcov": :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        check: :test
      ],
      dialyzer: [
        plt_ignore_apps: [:scraper_ex],
        plt_add_apps: [:ex_unit, :mix],
        list_unused_filters: true,
        plt_local_path: ".check/local_plt",
        plt_core_path: ".check/core_plt"
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BuffEx.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.7.3"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:finch, "~> 0.15.0"},
      {:scraper_ex, "~> 0.2"},
      {:sandbox_registry, "~> 0.1.0"},
      {:elixir_cache, "~> 0.3.0"},

      # tooling
      {:dialyxir, "~> 1.1", only: :test, runtime: false},
      {:ex_check, "~> 0.15.0", only: :test, runtime: false},
      {:credo, "~> 1.6", only: :test, runtime: false},
      {:blitz_credo_checks, "~> 0.1.5", only: :test, runtime: false},
      {:doctor, "~> 0.21.0", only: :test},
      {:excoveralls, "~> 0.13", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      check: ["format", "test --raise", "credo", "dialyzer", "coveralls.html"]
    ]
  end
end
