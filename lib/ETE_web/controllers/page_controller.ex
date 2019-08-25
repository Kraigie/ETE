defmodule ETEWeb.PageController do
  use ETEWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
