defmodule DynamoStreamer.UserActivity do
  @derive ExAws.Dynamo.Encodable

  alias DynamoStreamer.Id

  defstruct [:id, :email, :activity, :ttl]

  def new(email, activity) do
    %__MODULE__{
      id: Id.generate(),
      ttl: DateTime.utc_now() |> DateTime.add(3_600, :second) |> DateTime.to_unix(),
      email: email,
      activity: activity
    }
  end
end
