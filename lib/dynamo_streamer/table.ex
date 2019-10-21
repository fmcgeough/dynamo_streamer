defmodule DynamoStreamer.Table do
  @moduledoc """
  Create our test table to store dynamo records with streaming enabled
  """
  alias ExAws.Dynamo

  @spec setup() :: {:ok, term} | {:error, term}
  def setup do
    tablename = "user-activities"

    with {:ok, _} <- create_table(tablename),
         {:ok, _} <- setup_stream_for_table(tablename) do
      setup_ttl_for_table(tablename)
    end
  end

  @doc """
  Return a table description

  On success the return is {:ok, map()} where the map
  """
  @spec describe_table(tablename :: binary) :: {:ok, term} | {:error, term}
  def describe_table(tablename) do
    tablename
    |> Dynamo.describe_table()
    |> ExAws.request()
  end

  @spec exists?(binary) :: boolean | {:error, term}
  def exists?(tablename) do
    tablename
    |> describe_table()
    |> case do
      {:ok, _} -> true
      {:error, {"ResourceNotFoundException", _}} -> false
      err -> err
    end
  end

  def create_table(tablename) do
    tablename
    |> Dynamo.create_table(
      [id: :hash, email: :range],
      [id: :string, email: :string],
      1,
      1
    )
    |> ExAws.request()
  end

  def setup_stream_for_table(tablename) do
    tablename
    |> Dynamo.update_table(%{
      "StreamSpecification" => %{StreamEnabled: true, StreamViewType: "NEW_AND_OLD_IMAGES"}
    })
    |> ExAws.request()
  end

  def setup_ttl_for_table(tablename, field \\ "delete_at") do
    tablename
    |> Dynamo.update_time_to_live(field, true)
    |> ExAws.request()
  end
end
