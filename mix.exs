defmodule RasaSDK.Mixfile do
  use Mix.Project
  @version "0.5.0"
  def project do
    [
      app: :rasa_sdk,
      version: @version,
      build_path: "./_build",
      config_path: "./config/config.exs",
      deps_path: "./deps",
      lockfile: "./mix.lock",
      # I have only worked on this on 1.9 It may support earlier versions
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [source_ref: "v#{@version}", main: "readme", extras: ["README.md", "LICENSE.md"]]
    ]
  end

  defp description do
    """
       Rasa is an open source machine learning framework to automate text-and voice-based conversations.
       https://github.com/RasaHQ/rasa

       This library provides tools to communicate and control a Rasa application from Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Dirk Elmendorf"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/r26D/rasa-sdk-elixir"
      }
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.3.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:tesla, "~> 1.3"},
      {:poison, "~> 3.1.0"},
      {:plug_crypto, "~> 1.1.2"},
      # {:jason, "~> 1.2"},
      {:plug, "~> 1.10"}
    ]
  end
  defp aliases do
  [
    tag: "cmd git tag -a v#{@version} -m 'Version #{@version}';cmd git push origin v#{@version}"
  ]
  end
end
