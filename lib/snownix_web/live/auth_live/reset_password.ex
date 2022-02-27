defmodule SnownixWeb.AuthLive.ResetPassword do
  use SnownixWeb, :live_view

  def mount(%{"token" => token}, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Reset Password"))
     |> assign(:token, token)}
  end
end
