defmodule Bridgebreaker.Repo do
  use Ecto.Repo,
    otp_app: :bridgebreaker,
    adapter: Ecto.Adapters.Postgres
end
