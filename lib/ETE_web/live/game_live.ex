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

  def handle_event("move_player", code_map, socket) do
    dir = dir_from_code(code_map)
    if dir, do: ETE.Game.Server.set_moving(socket.id, dir)

    {:noreply, socket}
  end

  def handle_event("stop_player", code_map, socket) do
    dir = dir_from_code(code_map)
    if dir, do: ETE.Game.Server.stop_moving(socket.id, dir)

    {:noreply, socket}
  end

  def handle_event(_command, _key, socket) do
    {:noreply, socket}
  end

  def dir_from_code(%{"code" => "ArrowUp"}), do: :up
  def dir_from_code(%{"code" => "ArrowDown"}), do: :down
  def dir_from_code(%{"code" => "ArrowLeft"}), do: :left
  def dir_from_code(%{"code" => "ArrowRight"}), do: :right
  def dir_from_code(_), do: :nil

  defp put_world(socket) do
    assign(socket, world: ETE.Game.Server.get_world())
  end

  defp put_world(world, socket) do
    assign(socket, world: world)
  end
end
