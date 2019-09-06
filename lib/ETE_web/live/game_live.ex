defmodule ETEWeb.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    ETEWeb.PageView.render("game.html", assigns)
  end

  def mount(_session, socket) do
    ETE.Game.Server.add_player(socket.id, self())
    {:ok, put_world(socket)}
  end

  def handle_info({:render, world}, socket) do
    {:noreply, put_world(world, socket)}
  end

  def handle_event("move_player", "ArrowLeft", socket) do
    ETE.Game.Server.set_moving(socket.id, :left)
    {:noreply, socket}
  end

  def handle_event("move_player", "ArrowRight", socket) do
    ETE.Game.Server.set_moving(socket.id, :right)
    {:noreply, socket}
  end

  def handle_event("move_player", "ArrowUp", socket) do
    ETE.Game.Server.set_moving(socket.id, :up)
    {:noreply, socket}
  end

  def handle_event("move_player", "ArrowDown", socket) do
    ETE.Game.Server.set_moving(socket.id, :down)
    {:noreply, socket}
  end

  def handle_event("stop_player", "ArrowLeft", socket) do
    ETE.Game.Server.stop_moving(socket.id, :left)
    {:noreply, socket}
  end

  def handle_event("stop_player", "ArrowRight", socket) do
    ETE.Game.Server.stop_moving(socket.id, :right)
    {:noreply, socket}
  end

  def handle_event("stop_player", "ArrowUp", socket) do
    ETE.Game.Server.stop_moving(socket.id, :up)
    {:noreply, socket}
  end

  def handle_event("stop_player", "ArrowDown", socket) do
    ETE.Game.Server.stop_moving(socket.id, :down)
    {:noreply, socket}
  end

  def handle_event("move_player", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("stop_player", _key, socket) do
    {:noreply, socket}
  end

  defp put_world(socket) do
    assign(socket, world: ETE.Game.Server.get_world())
  end

  defp put_world(world, socket) do
    assign(socket, world: world)
  end
end
