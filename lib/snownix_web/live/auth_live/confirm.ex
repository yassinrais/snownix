defmodule SnownixWeb.AuthLive.Confirm do
  use SnownixWeb, :live_view

  def mount(%{"token" => token}, _, socket) do
    {:ok, socket |> assign(:token, token)}
  end
end
