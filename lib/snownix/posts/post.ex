defmodule Snownix.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Snownix.Helper
  use Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  alias Snownix.Accounts.User
  alias Snownix.Posts.{Entity, Category}

  schema "posts" do
    field :poster, Snownix.Uploaders.PosterUploader.Type

    field :slug, :string
    field :title, :string
    field :published_at, :naive_datetime

    field :description, :string, default: nil

    field :draft, :boolean, default: false
    field :read_time, :integer, default: 0

    belongs_to :author, User, type: :binary_id

    has_many :entities, Entity, on_replace: :delete
    many_to_many :categories, Category, join_through: "posts_categories"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    attrs = Map.merge(attrs, generate_slug(attrs))

    post
    |> cast(attrs, [
      :slug,
      :title,
      :poster,
      :description,
      :author_id,
      :published_at,
      :read_time
    ])
    |> filter_changeset()
    |> validate_required([:slug, :title, :description])
    |> validate_length(:title, min: 10, max: 225)
    |> validate_length(:description, min: 10, max: 400)
    |> unique_constraint(:slug)
    |> cast_assoc(:entities, with: &Entity.changeset/2, required: true)
  end

  @doc """
  Calculate and assign new read_time value to changeset
  """
  def read_time_changeset(changeset) do
    read_time =
      reading_time(get_field(changeset, :description)) +
        Enum.reduce(get_field(changeset, :entities), 0, &(&2 + reading_time(&1.body)))

    changeset |> put_change(:read_time, read_time)
  end

  def poster_changeset(post, attrs) do
    post
    |> cast_attachments(attrs, [:poster])
  end

  def author_changeset(post, author) do
    post
    |> put_change(:author, author)
  end

  def categories_changeset(post, categories) do
    post
    |> put_assoc(:categories, categories)
  end

  defp filter_changeset(changeset) do
    changeset
    |> update_change(:title, &Snownix.Posts.Post.trim_text/1)
    |> update_change(:description, &Snownix.Posts.Post.trim_text/1)
  end

  def trim_text(text \\ nil) do
    case text do
      nil ->
        nil

      _ ->
        String.trim(text)
    end
  end
end
