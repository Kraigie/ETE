defmodule ETEWeb.GameLiveController do
  use ETEWeb, :controller

  def show(conn, _params) do
    conn
    |> put_status(:not_found)
    |> put_view(ETEWeb.ErrorView)
    |> render("404.html")
  end
end
