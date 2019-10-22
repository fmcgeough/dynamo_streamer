defmodule DynamoStreamer.MixProject do
  use Mix.Project

  def project do
    [
      app: :dynamo_streamer,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DynamoStreamer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws_dynamo, "~> 2.3"},
      {:ex_aws_dynamo_streams, "~> 2.0"},
      {:hackney, "~> 1.15"},
      {:poison, "~> 3.0"},
      {:puid, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.12.0", only: :test},
      {:mox, "~> 0.5.1", only: :test}
    ]
  end
end
