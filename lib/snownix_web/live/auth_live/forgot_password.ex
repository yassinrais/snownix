defmodule SnownixWeb.AuthLive.ForgotPassword do
  use SnownixWeb, :live_view

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Forgot password"))}
  end
end
