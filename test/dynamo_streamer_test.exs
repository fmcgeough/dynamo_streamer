defmodule DynamoStreamerTest do
  use ExUnit.Case
  doctest DynamoStreamer

  test "greets the world" do
    assert DynamoStreamer.hello() == :world
  end
end
