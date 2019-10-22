ExUnit.start()

defmodule SubmitRequest do
  @callback request(ExAws.Operation.t()) :: {:ok, term} | {:error, term}
end

Mox.defmock(DynamoStreamer.ExAwsMock, for: SubmitRequest)
