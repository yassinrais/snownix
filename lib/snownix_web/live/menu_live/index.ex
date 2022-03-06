defmodule SnownixWeb.MenuLive.Index do
  use SnownixWeb, :live_view

  alias Snownix.Navigation
  alias Snownix.Navigation.Menu

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :menus, list_menus())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Menu")
    |> assign(:menu, Navigation.get_menu!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Menu")
    |> assign(:menu, %Menu{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Menus")
    |> assign(:menu, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    menu = Navigation.get_menu!(id)
    {:ok, _} = Navigation.delete_menu(menu)

    {:noreply, assign(socket, :menus, list_menus())}
  end

  defp list_menus do
    Navigation.list_menus()
  end
end
