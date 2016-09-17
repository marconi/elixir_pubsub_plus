defmodule PubSubPlus.Mixfile do
  use Mix.Project

  def project do
    [app: :pubsub_plus,
     version: "0.0.1",
     elixir: "~> 1.3",
     description: "Pubsub library with nested topic support",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:pubsub, "~> 0.0.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Marconi Moreto Jr."],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/marconi/elixir_pubsub_plus"}
    ]
  end
end
