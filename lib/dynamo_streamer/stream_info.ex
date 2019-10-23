defmodule DynamoStreamer.StreamInfo do
  @moduledoc """
  Stream info for a DynamoDB Table
  """
  defstruct [:stream_arn, :stream_label, :enabled, :view_type]

  @type t :: %DynamoStreamer.StreamInfo{
          stream_arn: binary | nil,
          stream_label: binary | nil,
          enabled: boolean | nil,
          view_type: binary | nil
        }

  def new(%{
        "Table" => %{
          "LatestStreamArn" => stream_arn,
          "LatestStreamLabel" => stream_label,
          "StreamSpecification" => %{
            "StreamEnabled" => enabled,
            "StreamViewType" => view_type
          }
        }
      }) do
    %__MODULE__{
      stream_arn: stream_arn,
      stream_label: stream_label,
      enabled: enabled,
      view_type: view_type
    }
  end

  def new(val), do: {:error, "Unexpected StreamInfo. #{inspect(val)}"}
end
