defmodule DynamoStreamer.Table do
  @moduledoc """
  Provide wrappers around DynamoDB table operations
  """
  alias ExAws.Dynamo

  @doc """
  Return a table description

  On success the return is {:ok, map()} where the map has the table description
  """
  @spec describe_table(binary) :: {:ok, term} | {:error, term}
  def describe_table(tablename) do
    tablename
    |> Dynamo.describe_table()
    |> request()
  end

  @doc """
  Does tablename exist?

  Returns true/false or {:error, term} on unexpected return values
  """
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

  @doc """
  Create a table in Dynamo

  Note: in AWS you have to have permissions on operations and CreateTable (and
  DeleteTable) are typically not granted to avoid inadvertently using an excessive
  amount of resources or destroying data inadvertently. However, for local
  DynamoDB testing this all works without issue.
  """
  @spec create_table(
          binary,
          Dynamo.key_schema(),
          Dynamo.key_definitions(),
          pos_integer,
          pos_integer,
          Dynamo.dynamo_billing_types()
        ) :: {:error, any} | {:ok, any}
  def create_table(
        tablename,
        partition_key \\ [id: :hash, email: :range],
        sort_key \\ [id: :string, email: :string],
        read_capacity \\ 1,
        write_capacity \\ 1,
        billing_mode \\ :provisioned
      ) do
    tablename
    |> Dynamo.create_table(partition_key, sort_key, read_capacity, write_capacity, billing_mode)
    |> request()
  end

  @doc """
  Modify a created table so that it supports streams

  There are various types of stream options that you can explore in the AWS doc.
  In this case, by default, we're asking for NEW_AND_OLD_IMAGES. This makes our
  stream somewhat analogous to what you'd code in a database trigger with access
  to new/old versions of a record.
  """
  @spec setup_stream_for_table(binary, boolean, binary) :: {:ok, term} | {:error, term}
  def setup_stream_for_table(tablename, enabled \\ true, view_type \\ "NEW_AND_OLD_IMAGES") do
    tablename
    |> Dynamo.update_table(%{
      "StreamSpecification" => %{StreamEnabled: enabled, StreamViewType: view_type}
    })
    |> request()
  end

  @doc """
  Modify a created table so that it expires (deletes) rows

  The TTL in Dynamo is a Unix based epoch (number)
  """
  @spec setup_ttl_for_table(binary, binary) :: {:ok, term} | {:error, term}
  def setup_ttl_for_table(tablename, field \\ "delete_at") do
    tablename
    |> Dynamo.update_time_to_live(field, true)
    |> request()
  end

  defp request(request) do
    Application.get_env(:ex_aws, :submit_using, ExAws).request(request)
  end
end
