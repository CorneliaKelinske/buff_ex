defmodule BuffEx.Repo do
  use Ecto.Repo,
    otp_app: :buff_ex,
    adapter: Ecto.Adapters.Postgres
end
