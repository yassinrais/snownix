defmodule SnownixWeb.LiveHelpersTest do
  use SnownixWeb.ConnCase, async: true

  alias SnownixWeb.LiveHelpers

  import Snownix.NavigationFixtures

  test "menu list" do
    assert LiveHelpers.list_menu() == []

    menu = menu_fixture(%{status: "active"})

    assert LiveHelpers.list_menu() == [
             %{
               item: menu,
               sub: []
             }
           ]
  end

  test "article format date" do
    date = ~N[2022-01-01 12:00:00]

    assert LiveHelpers.article_date_format(date) =~ "Sat, January 01 2022"
  end
end
