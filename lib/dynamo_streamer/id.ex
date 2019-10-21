defmodule(DynamoStreamer.Id, do: use(Puid, total: 1.0e7, risk: 1.0e15, charset: :safe32))
