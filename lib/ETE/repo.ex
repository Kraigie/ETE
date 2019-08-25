defmodule ETE.Repo do
  use Ecto.Repo,
    otp_app: ETE,
    adapter: Ecto.Adapters.Postgres
end
