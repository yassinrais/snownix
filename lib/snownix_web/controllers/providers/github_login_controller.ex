defmodule SnownixWeb.Providers.GithubLoginController do
  use SnownixWeb, :controller

  alias Snownix.Providers.Github
  alias Snownix.Accounts
  alias SnownixWeb.UserAuth

  def create(conn, params) do
    with {:ok, data} <- Github.get_user_resources(params["code"]),
         user when not is_nil(user) <- Accounts.get_user_by_provider_id(:github, data["id"]) do
      UserAuth.log_in_user(conn, user)
    else
      {:error, _} ->
        conn
        |> put_flash(:error, "Authentication using Github has been failed")
        |> redirect(to: Routes.auth_login_path(conn, :login))
      nil ->
        conn
        |> put_flash(:error, "This Github account is not registered")
        |> redirect(to: Routes.auth_login_path(conn, :login))
    end
  end
end
