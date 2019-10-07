defmodule MtgSdkEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :mtg_sdk_ex,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp description do
    """
    This is the Magic: The Gathering SDK Elixir implementation. It is a wrapper around the MTG API of magicthegathering.io.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :mtg_sdk_ex,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["greg.heidorn@gmail.com"],
      licenses: ["GPL 3.0"],
      links: %{"GitHub" => "https://github.com/gheidorn/mtg_sdk_ex"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.6"},
      {:excoveralls, "~> 0.11.2", only: :test},
      {:mock, "~> 0.3.3", only: :test},
      {:ex_doc, "~> 0.21.2"}
    ]
  end
end
