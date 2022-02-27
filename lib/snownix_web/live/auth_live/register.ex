defmodule SnownixWeb.AuthLive.Register do
  use SnownixWeb, :live_view

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Sign up"))}
  end
end
