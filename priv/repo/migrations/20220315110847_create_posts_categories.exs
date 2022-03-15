defmodule Snownix.Repo.Migrations.CreatecategoriesCategories do
  use Ecto.Migration

  def change do
    create table(:posts_categories) do
      add :post_id, references(:posts, on_delete: :delete_all, type: :uuid)
      add :category_id, references(:categories, on_delete: :delete_all, type: :uuid)
    end

    create index(:posts_categories, [:post_id, :category_id], unique: true)
  end
end
