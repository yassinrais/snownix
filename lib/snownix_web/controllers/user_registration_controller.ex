defmodule SnownixWeb.UserRegistrationController do
  use SnownixWeb, :controller

  alias Snownix.Accounts
  alias SnownixWeb.UserAuth

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.auth_confirm_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        conn
        |> put_changeset_errors(changeset)
        |> redirect(to: Routes.auth_register_path(conn, :register))
    end
  end
end
