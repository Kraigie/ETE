defmodule ETEWeb.GameLive do
  use Phoenix.LiveView

  @registry ETE.GameBrowser.Registry

  @impl true
  def render(assigns) do
    ETEWeb.GameView.render("game.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => game_id}, _uri, socket) do
    # Handle unknown game ids
    if Registry.lookup(@registry, game_id) == [] do
      {:noreply, live_redirect(socket, to: "/404")}
    else
      # Don't add player here, instead show modal to select character
      ETE.Game.Server.add_player(game_id, socket.id, self())
      socket = assign(socket, game_id: game_id)
      {:noreply, put_world(game_id, socket)}
    end
  end

  @impl true
  def handle_info({:render, world}, socket) do
    {:noreply, put_world(world, socket)}
  end

  @impl true
  def handle_event("add_player", _event, socket) do
    # Add player to world here, close modal
  end

  @impl true
  def handle_event("move_player", code_map, socket) do
    dir = dir_from_code(code_map)
    if dir, do: ETE.Game.Server.set_moving(socket.assigns.game_id, socket.id, dir)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop_player", code_map, socket) do
    dir = dir_from_code(code_map)
    if dir, do: ETE.Game.Server.stop_moving(socket.assigns.game_id, socket.id, dir)

    {:noreply, socket}
  end

  @impl true
  def handle_event(_command, _key, socket) do
    {:noreply, socket}
  end

  def dir_from_code(%{"code" => "ArrowUp"}), do: :up
  def dir_from_code(%{"code" => "ArrowDown"}), do: :down
  def dir_from_code(%{"code" => "ArrowLeft"}), do: :left
  def dir_from_code(%{"code" => "ArrowRight"}), do: :right
  def dir_from_code(_), do: nil

  defp put_world(id, socket) when is_binary(id) do
    assign(socket, world: ETE.Game.Server.get_world(id))
  end

  defp put_world(world, socket) when is_map(world) do
    assign(socket, world: world)
  end
end