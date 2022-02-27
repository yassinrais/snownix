defmodule SnownixWeb.AuthLive.Confirm do
  use SnownixWeb, :live_view

  alias Snownix.Accounts

  def mount(%{"token" => token}, _, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, gettext("Confirm"))
      |> assign(:token, token)
      |> assign(changeset: Accounts.change_user_reset_email(%Accounts.User{}))
    }
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %Accounts.User{}
      |> Accounts.change_user_reset_email(user_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  def handle_event("update", %{"user" => user_params}, socket) do
    with %{"email" => email} <- user_params do
      case Accounts.confirm_user(socket.assigns.token, email) do
        {:ok, _} ->
          {:noreply,
           socket
           |> put_flash(:info, "User confirmed successfully.")
           |> redirect(to: Routes.auth_login_path(socket, :login))}

        :error ->
          # If there is a current user and the account was already confirmed,
          # then odds are that the confirmation link was already visited, either
          # by some automation or by the user themselves, so we redirect without
          # a warning message.
          case socket.assigns do
            %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
              {:noreply, socket |> redirect(to: Routes.auth_login_path(socket, :login))}

            %{} ->
              {:noreply,
               socket
               |> put_flash(:error, "User confirmation link is invalid or it has expired.")
               |> redirect(to: Routes.auth_login_path(socket, :login))}
          end
      end
    end
  end
end
