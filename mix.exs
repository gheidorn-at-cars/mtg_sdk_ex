defmodule MtgSdkEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :mtg_sdk_ex,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      links: %{"GitHub" => "https://github.com/gheidorn/mtg_sdx_ex"}
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
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.1"},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end
end
