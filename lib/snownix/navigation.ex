defmodule Snownix.Navigation do
  @moduledoc """
  The Navigation context.
  """

  import Ecto.Query, warn: false
  alias Snownix.Repo

  alias Snownix.Navigation.Menu

  @doc """
  Returns the list of menus.

  ## Examples

      iex> list_menus()
      [%Menu{}, ...]

  """
  def list_menus do
    Repo.all(Menu)
  end

  @doc """
  Returns the list of menus (cached).

  ## Examples

      iex> list_menus()
      [%Menu{}, ...]

  """
  def list_active_menus do
    menus = Cachex.get!(:snownix, "list_active_menus")

    if is_nil(menus) do
      menus =
        Menu
        |> where(status: "active")
        |> Repo.all()

      Cachex.put!(:snownix, "list_active_menus", menus)

      menus
    else
      menus
    end
  end

  @doc """
  Gets a single menu.

  Raises `Ecto.NoResultsError` if the Menu does not exist.

  ## Examples

      iex> get_menu!(123)
      %Menu{}

      iex> get_menu!(456)
      ** (Ecto.NoResultsError)

  """
  def get_menu!(id), do: Repo.get!(Menu, id)

  @doc """
  Creates a menu.

  ## Examples

      iex> create_menu(%{field: value})
      {:ok, %Menu{}}

      iex> create_menu(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu(attrs \\ %{}) do
    menu_cache_clear()

    %Menu{}
    |> Menu.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a menu.

  ## Examples

      iex> update_menu(menu, %{field: new_value})
      {:ok, %Menu{}}

      iex> update_menu(menu, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu(%Menu{} = menu, attrs) do
    menu_cache_clear()

    menu
    |> Menu.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a menu.

  ## Examples

      iex> delete_menu(menu)
      {:ok, %Menu{}}

      iex> delete_menu(menu)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu(%Menu{} = menu) do
    menu_cache_clear()

    Repo.delete(menu)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu changes.

  ## Examples

      iex> change_menu(menu)
      %Ecto.Changeset{data: %Menu{}}

  """
  def change_menu(%Menu{} = menu, attrs \\ %{}) do
    Menu.changeset(menu, attrs)
  end

  defp menu_cache_clear() do
    Cachex.del!(:snownix, "list_active_menus")
  end
end
