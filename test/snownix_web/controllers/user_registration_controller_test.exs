defmodule SnownixWeb.UserRegistrationControllerTest do
  use SnownixWeb.ConnCase, async: true

  import Snownix.AccountsFixtures

  describe "GET /auth/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.auth_register_path(conn, :register))
      response = html_response(conn, 200)
      assert response =~ "Sign up</h1>"
      assert response =~ "Register</button>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn |> log_in_user(user_fixture()) |> get(Routes.auth_register_path(conn, :register))

      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /auth/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Log out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "username" => "invalid username",
            "email" => "with spaces",
            "password" => "too short"
          }
        })

      assert redirected_to(conn) == Routes.auth_register_path(conn, :register)
      assert get_flash(conn, :error) =~ "Username username must be alphanumeric"

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "username" => "username",
            "email" => "with spaces",
            "password" => "too short"
          }
        })

      assert get_flash(conn, :error) =~ "must have the @ sign and no spaces"

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "username" => "username",
            "email" => "email@example.com",
            "password" => "too short"
          }
        })

      assert redirected_to(conn) == Routes.auth_register_path(conn, :register)
      assert get_flash(conn, :error) =~ "should be at least 12 character"
    end
  end
end
