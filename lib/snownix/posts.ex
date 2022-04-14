defmodule Snownix.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false

  alias Snownix.Repo

  alias Snownix.Posts.Post
  alias Snownix.Posts.Entity

  alias Snownix.Accounts.User

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts() do
    Post
    |> posts()
  end

  @doc """
  Last 6 posts
  """
  def last_posts(limit \\ 6) do
    Post
    |> limit(^limit)
    |> order_by(desc: :published_at)
    |> posts()
  end

  defp posts(query) do
    query
    |> order_posts()
    |> Repo.all()
    |> Repo.preload(:author)
    |> Repo.preload(:categories)
  end

  def order_posts(query) do
    query
    |> order_by(desc: :published_at)
  end

  def by_user(query, username) do
    query
    |> join(:inner, [p], u in User, on: p.author_id == u.id and u.username == ^username)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_by_slug!(slug) do
    Repo.get_by!(Post, slug: slug)
    |> Repo.preload(:author)
    |> Repo.preload(:entities)
    |> Repo.preload(:categories)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(author, attrs \\ %{}, categories \\ []) do
    %Post{}
    |> Post.changeset(attrs)
    |> Post.author_changeset(author)
    |> Post.categories_changeset(categories)
    |> Post.read_time_changeset()
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Repo.preload(:entities)
    |> Post.changeset(attrs)
    |> Post.read_time_changeset()
    |> Repo.update()
  end

  @doc """
  Updates the post poster.

  The post poster is updated .
  The old poster is deleted
  The confirmed_at date is also updated to the current time.
  """
  def update_post_poster(post, poster) do
    changeset =
      post
      |> Post.poster_changeset(%{poster: poster})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:post, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{post: post}} -> {:ok, post}
      {:error, :post, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def change_entity(%Entity{} = entity, attrs \\ %{}) do
    Entity.changeset(entity, attrs)
  end

  alias Snownix.Posts.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """

  def list_categories(), do: list_categories(Category)
  def list_categories(nil), do: list_categories(Category)

  def list_categories(search) when is_binary(search) do
    search = "#{search}%"

    query =
      from c in Category,
        where: like(c.title, ^search)

    list_categories(query)
  end

  def list_categories(query) do
    Repo.all(query)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
