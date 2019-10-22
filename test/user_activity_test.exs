defmodule DynamoStreamer.UserActivityTest do
  use ExUnit.Case, async: true
  import Mox
  alias DynamoStreamer.UserActivity

  setup :set_mox_global
  setup :verify_on_exit!

  setup_all do
    Application.put_env(:ex_aws, :submit_using, DynamoStreamer.ExAwsMock)

    on_exit(fn ->
      Application.put_env(:ex_aws, :submit_using, ExAws)
    end)
  end

  test "setting up table calls appropriate APIs" do
    DynamoStreamer.ExAwsMock
    |> expect(:request, 3, fn request -> {:ok, request} end)

    UserActivity.setup()
  end

  test "making new user activity sets TTL and id" do
    activity = UserActivity.new("test@test.com", "testing")
    assert activity.id
    assert activity.ttl
    current_epoch_time = DateTime.utc_now() |> DateTime.to_unix()
    assert activity.ttl > current_epoch_time
  end
end
