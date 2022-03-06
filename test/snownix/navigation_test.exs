defmodule Snownix.NavigationTest do
  use Snownix.DataCase

  alias Snownix.Navigation

  describe "menus" do
    alias Snownix.Navigation.Menu

    import Snownix.NavigationFixtures

    @invalid_attrs %{link: nil, newtab: nil, parent_id: nil, status: nil, title: nil}

    test "list_menus/0 returns all menus" do
      menu = menu_fixture()
      assert Navigation.list_menus() == [menu]
    end

    test "get_menu!/1 returns the menu with given id" do
      menu = menu_fixture()
      assert Navigation.get_menu!(menu.id) == menu
    end

    test "list_active_menus/1 returns the active menus list" do
      menu = menu_fixture()
      assert Navigation.list_active_menus(menu.id) == [menu]
    end

    test "create_menu/1 with valid data creates a menu" do
      valid_attrs = %{
        link: "some link",
        newtab: true,
        parent_id: "some parent_id",
        status: "some status",
        title: "some title"
      }

      assert {:ok, %Menu{} = menu} = Navigation.create_menu(valid_attrs)
      assert menu.link == "some link"
      assert menu.newtab == true
      assert menu.parent_id == "some parent_id"
      assert menu.status == "some status"
      assert menu.title == "some title"
    end

    test "create_menu/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Navigation.create_menu(@invalid_attrs)
    end

    test "update_menu/2 with valid data updates the menu" do
      menu = menu_fixture()

      update_attrs = %{
        link: "some updated link",
        newtab: false,
        parent_id: "some updated parent_id",
        status: "some updated status",
        title: "some updated title"
      }

      assert {:ok, %Menu{} = menu} = Navigation.update_menu(menu, update_attrs)
      assert menu.link == "some updated link"
      assert menu.newtab == false
      assert menu.parent_id == "some updated parent_id"
      assert menu.status == "some updated status"
      assert menu.title == "some updated title"
    end

    test "update_menu/2 with invalid data returns error changeset" do
      menu = menu_fixture()
      assert {:error, %Ecto.Changeset{}} = Navigation.update_menu(menu, @invalid_attrs)
      assert menu == Navigation.get_menu!(menu.id)
    end

    test "delete_menu/1 deletes the menu" do
      menu = menu_fixture()
      assert {:ok, %Menu{}} = Navigation.delete_menu(menu)
      assert_raise Ecto.NoResultsError, fn -> Navigation.get_menu!(menu.id) end
    end

    test "change_menu/1 returns a menu changeset" do
      menu = menu_fixture()
      assert %Ecto.Changeset{} = Navigation.change_menu(menu)
    end
  end
end
