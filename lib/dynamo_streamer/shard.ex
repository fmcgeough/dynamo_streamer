defmodule DynamoStreamer.Shard do
  @moduledoc """
  Info about a shard in a stream
  """
  defstruct [:shard_id, :parent_shard_id, :start_seq, :end_seq]

  @type t :: %DynamoStreamer.Shard{
          shard_id: binary | nil,
          parent_shard_id: binary | nil,
          start_seq: integer | nil,
          end_seq: integer | nil
        }

  def new(%{
        "ParentShardId" => parent_shard_id,
        "SequenceNumberRange" => %{
          "EndingSequenceNumber" => end_seq_str,
          "StartingSequenceNumber" => start_seq_str
        },
        "ShardId" => shard_id
      }) do
    create(shard_id, start_seq_str, end_seq_str, parent_shard_id)
  end

  def new(%{
        "ShardId" => shard_id,
        "SequenceNumberRange" => %{
          "EndingSequenceNumber" => end_seq_str,
          "StartingSequenceNumber" => start_seq_str
        }
      }) do
    create(shard_id, start_seq_str, end_seq_str)
  end

  def new(%{
        "ShardId" => shard_id,
        "SequenceNumberRange" => %{
          "StartingSequenceNumber" => start_seq_str
        }
      }) do
    create(shard_id, start_seq_str)
  end

  defp create(shard_id, start_seq_str, end_seq_str \\ nil, parent_shard_id \\ nil) do
    %__MODULE__{
      parent_shard_id: parent_shard_id,
      end_seq: convert_seq(end_seq_str),
      start_seq: convert_seq(start_seq_str),
      shard_id: shard_id
    }
  end

  defp convert_seq(nil), do: nil

  defp convert_seq(str) do
    String.to_integer(str)
  end
end
