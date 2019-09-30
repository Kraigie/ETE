defmodule ETEWeb.GameLive do
  use Phoenix.LiveView

  alias ETEWeb.Router.Helpers, as: Routes

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
      ETE.Game.Server.add_connected(game_id, socket.id, self())

      socket =
        socket
        |> assign(game_id: game_id)
        |> assign(show_picker: true)
        |> assign(socket: socket)
        |> assign(player_id: socket.id)
        |> assign(show_hitboxes: false)
        |> put_world(game_id)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:render, world}, socket) do
    {:noreply, put_world(socket, world)}
  end

  @impl true
  def handle_event("redirect_to_main", _key, socket) do
    {:noreply, live_redirect(socket, to: Routes.live_path(socket, ETEWeb.GameBrowserLive))}
  end

  @impl true
  def handle_event("rejoin", _key, socket) do
    {:noreply,
     live_redirect(socket, to: Routes.live_path(socket, ETEWeb.GameLive, socket.assigns.game_id))}
  end

  @impl true
  def handle_event("add_player", %{"selected_cat" => cat}, socket) do
    ETE.Game.Server.add_player(socket.assigns.game_id, socket.id, cat)

    socket =
      socket
      |> assign(show_picker: false)
      |> put_world(socket.assigns.game_id)

    {:noreply, socket}
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
  def handle_event("toggle_hitboxes", _, %{assigns: %{show_hitboxes: show}} = socket) do
    IO.inspect(show)
    {:noreply, assign(socket, show_hitboxes: !show)}
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

  defp put_world(socket, id) when is_binary(id) do
    assign(socket, world: ETE.Game.Server.get_world(id))
  end

  defp put_world(socket, world) when is_map(world) do
    assign(socket, world: world)
  end
end
