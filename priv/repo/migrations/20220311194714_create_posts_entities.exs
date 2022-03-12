defmodule Snownix.Repo.Migrations.CreatePostsEntities do
  use Ecto.Migration

  def change do
    create table(:posts_entities) do
      add :body, :text
      add :order, :integer
      add :type, :string

      add :post_id, references(:posts, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create index(:posts_entities, [:post_id])
  end
end
