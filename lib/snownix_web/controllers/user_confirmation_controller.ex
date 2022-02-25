defmodule SnownixWeb.UserConfirmationController do
  use SnownixWeb, :controller

  alias Snownix.Accounts

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.auth_confirm_url(conn, :confirm, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> go_login()
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"token" => token, "user" => %{"email" => email}}) do
    case Accounts.confirm_user(token, email) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User confirmed successfully.")
        |> go_login()

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            conn |> go_login()

          %{} ->
            conn
            |> put_flash(:error, "User confirmation link is invalid or it has expired.")
            |> go_login()
        end
    end
  end

  defp go_login(conn) do
    conn |> redirect(to: Routes.auth_login_path(conn, :login))
  end
end
