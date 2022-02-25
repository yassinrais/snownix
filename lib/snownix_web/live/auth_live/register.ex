defmodule SnownixWeb.AuthLive.Register do
  use SnownixWeb, :live_view

  def mount(_params, session, socket) do
    IO.inspect(session)
    {:ok, socket}
  end
end
