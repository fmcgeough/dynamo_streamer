defmodule DynamoStreamer.UserActivity do
  @moduledoc """
  Our test table
  """
  @derive ExAws.Dynamo.Encodable

  alias DynamoStreamer.{Id, Table}

  defstruct [:id, :email, :activity, :ttl]

  def new(email, activity) do
    %__MODULE__{
      id: Id.generate(),
      ttl: DateTime.utc_now() |> DateTime.add(3_600, :second) |> DateTime.to_unix(),
      email: email,
      activity: activity
    }
  end

  @spec setup() :: {:ok, term} | {:error, term}
  def setup do
    tablename = "user-activities"

    with {:ok, _} <- Table.create_table(tablename),
         {:ok, _} <- Table.setup_stream_for_table(tablename) do
      Table.setup_ttl_for_table(tablename)
    end
  end

  @doc """
  Provide a helper to generate random data
  """
  def random do
    new("#{Id.generate()}@gmail.com", %{
      page: Id.generate(),
      task: Enum.random(["buying", "selling", "viewing", "data_entry"])
    })
  end
end
