defmodule SnownixWeb.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Snownix.Accounts
  alias Snownix.Accounts.User

  def on_mount(:user, _params, session, socket) do
    socket =
      socket
      |> assign(:current_user, find_current_user(session))

    {:cont, socket}
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end
