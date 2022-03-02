defmodule SnownixWeb.AccountLive.Profile do
  use SnownixWeb, :live_view

  alias Snownix.Accounts

  def mount(%{"username" => username}, _session, socket) do
    {:ok,
     socket
     |> fetch_user_profile(username)}
  end

  defp fetch_user_profile(socket, username) do
    profile = Accounts.get_user_by_username!(username)

    socket
    |> assign(:username, username)
    |> assign(:profile, profile)
  end
end
