defmodule ExRocketreach.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/nix2intel/ex_rocketreach"

  def project do
    [
      app: :ex_rocketreach,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "ExRocketreach",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExRocketreach.Application, []}
    ]
  end

  defp deps do
    [
      {:req, "~> 0.4.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ]
  end

  defp description do
    """
    An Elixir client for the RocketReach API - search and lookup contact information 
    for professionals and companies.
    """
  end

  defp package do
    [
      name: "ex_rocketreach",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => @source_url,
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end

