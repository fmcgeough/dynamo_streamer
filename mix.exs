defmodule DynamoStreamer.MixProject do
  use Mix.Project

  def project do
    [
      app: :dynamo_streamer,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ex_aws_dynamo, "~> 2.3"},
      {:ex_aws_dynamo_streams, "~> 2.0"}
    ]
  end
end
