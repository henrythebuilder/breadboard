defmodule Breadboard.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :breadboard,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Breadboard.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 0.4"}
      {:ex_doc, "~> 0.21.0", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md",
               "CHANGELOG.md"
              ],
      source_ref: "v#{@version}",
    ]
  end
end
