defmodule SnownixWeb.SharedLive.FooterComponent do
  use SnownixWeb, :live_component

  def handle_event("change-lang", %{"lang" => lang}, socket) do
    {:noreply,
     socket
     |> redirect(to: Routes.index_index_path(socket, :index, locale: lang))}
  end
end
