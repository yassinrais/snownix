defmodule Snownix.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Snownix.Helper

  @primary_key {:id, :binary_id, autogenerate: true}

  alias Snownix.Accounts.User
  alias Snownix.Posts.{Entity, Category}

  schema "posts" do
    field :description, :string
    field :poster, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string
    field :read_time, :integer, default: 0

    belongs_to :author, User, type: :binary_id

    has_many :entities, Entity
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
      :published_at
    ])
    |> validate_required([:slug, :title, :poster, :description, :published_at])
    |> unique_constraint(:slug)
  end
end
