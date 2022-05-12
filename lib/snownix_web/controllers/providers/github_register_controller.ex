defmodule SnownixWeb.Providers.GithubRegisterController do
  use SnownixWeb, :controller

  alias Snownix.Providers.Github
  alias Snownix.Accounts
  alias SnownixWeb.UserAuth

  def create(conn, params) do
    with {:ok, data} <- Github.get_user_resources(params["code"]),
         %{"email" => email} <- Enum.find(data["emails"], & &1["primary"]),
         {:ok, user} <- Accounts.register_user_from_provider(:github, data, email) do
      UserAuth.log_in_user(conn, user)
    else
      {:error, _} ->
        conn
        |> put_flash(:error, "Authentication using Github has been failed")
        |> redirect(to: Routes.auth_register_path(conn, :register))
    end
  end
end
