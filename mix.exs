defmodule Breadboard.MixProject do
  use Mix.Project

  @version "0.0.2"
  @github_source_url ""
  @homepage_url @github_source_url

  def project do
    [
      app: :breadboard,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      source_url: @github_source_url,
      #homepage_url: @homepage_url,
      deps: deps(),
      docs: docs(),
      aliases: [docs: ["docs", &copy_extra/1]],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Breadboard.Application, []}
    ]
  end

  def description() do
    "An helper library for 'Elixir Circuits'"
  end

  def package() do
    %{
      licenses: ["Apache-2.0"],
      files: ["lib",
              "mix.exs",
              "NOTICE",
              "LICENSE",
              "CHANGELOG.md",
              "README.md",
              ".formatter.exs"],
      links: %{"GitHub" => @github_source_url}
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 0.4"},
      {:ex_doc, "~> 0.21.0", only: :docs, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @github_source_url
    ]
  end

  defp copy_extra(_) do
    File.cp("LICENSE", "doc/LICENSE")
    File.cp("NOTICE", "doc/NOTICE")
  end

end

# SPDX-License-Identifier: Apache-2.0
