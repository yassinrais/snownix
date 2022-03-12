defmodule Snownix.Posts.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snownix.Posts.Post

  schema "posts_entities" do
    field :body, :string
    field :type, :string
    field :order, :integer

    belongs_to :post, Post, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:body, :order, :type, :post_id])
    |> validate_required([:body, :order, :type, :post_id])
  end
end
