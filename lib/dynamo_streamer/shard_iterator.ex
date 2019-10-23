defmodule DynamoStreamer.ShardIterator do
  @moduledoc """
  Provide a means of retrieving records from a shard
  """
  alias ExAws.DynamoStreams

  defstruct [:iter, :records, :eof]

  @type t :: %DynamoStreamer.ShardIterator{
          iter: binary | nil,
          records: list | nil,
          eof: binary | nil
        }

  def new(%{stream_arn: stream_arn}, %{shard_id: shard_id}) do
    DynamoStreams.get_shard_iterator(stream_arn, shard_id, :trim_horizon)
    |> ExAws.request()
    |> case do
      {:ok, %{"ShardIterator" => shard_iterator}} ->
        %__MODULE__{iter: shard_iterator, eof: false, records: []}

      {:ok, val} ->
        {:error, "Unexpected ShardIterator. #{inspect(val)}"}

      err ->
        err
    end
  end

  def get_records(shard_iterator) do
    DynamoStreams.get_records(shard_iterator.iter)
    |> ExAws.request()
    |> case do
      {:ok, %{"NextShardIterator" => next_iter, "Records" => records}} ->
        %__MODULE__{records: records, eof: is_empty?(records), iter: next_iter}

      {:ok, %{"Records" => records}} ->
        %__MODULE__{records: records, eof: is_empty?(records), iter: nil}

      {:ok, val} ->
        {:error, "Invalid GetRecords. #{inspect(val)}"}

      err ->
        err
    end
  end

  defp is_empty?(nil), do: true
  defp is_empty?([]), do: true
  defp is_empty?(_), do: false
end
