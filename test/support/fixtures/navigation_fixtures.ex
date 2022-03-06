defmodule Snownix.NavigationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Snownix.Navigation` context.
  """

  @doc """
  Generate a menu.
  """
  def menu_fixture(attrs \\ %{}) do
    {:ok, menu} =
      attrs
      |> Enum.into(%{
        link: "some link",
        newtab: true,
        parent_id: "some parent_id",
        status: "some status",
        title: "some title"
      })
      |> Snownix.Navigation.create_menu()

    menu
  end
end
