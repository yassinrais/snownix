defmodule SnownixWeb.MenuLive.Show do
  use SnownixWeb, :live_view

  alias Snownix.Navigation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:menu, Navigation.get_menu!(id))}
  end

  defp page_title(:show), do: "Show Menu"
  defp page_title(:edit), do: "Edit Menu"
end
