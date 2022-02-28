defmodule SnownixWeb.AuthLiveRegisterTest do
  use SnownixWeb.LiveCase, async: true

  import Snownix.AccountsFixtures

  setup do
    %{
      user: user_fixture()
    }
  end

  test "renders sign up page", %{conn: conn} do
    conn = get(conn, Routes.auth_register_path(conn, :register))
    assert html_response(conn, 200)

    {:ok, _view, html} = live(conn, Routes.auth_register_path(conn, :register))
    assert html =~ "Sign up</h1>"
    assert html =~ "Already have an account?"
  end

  test "register the user", %{conn: conn, user_unique: user} do
    {:ok, view, _html} = live(conn, Routes.auth_register_path(conn, :register))
    form = view |> form("form", user: user)

    assert {:error, {:redirect, %{to: "/auth/login"}}} = form |> render_submit()
  end
end
