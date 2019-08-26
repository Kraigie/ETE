defmodule ETEWeb.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    ETEWeb.PageView.render("game.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(16, self(), :tick)
    ETE.Game.Server.add_player(socket.id)
    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  def handle_event("move_player", "ArrowLeft", socket) do
    ETE.Game.Server.move_player(socket.id, -1)
    {:noreply, socket}
  end

  def handle_event("move_player", "ArrowRight", socket) do
    ETE.Game.Server.move_player(socket.id, 0.5)
    {:noreply, socket}
  end

  def handle_event("move_player", _key, socket) do
    {:noreply, socket}
  end

  defp put_date(socket) do
    assign(socket, world: ETE.Game.Server.get_world())
  end
end
