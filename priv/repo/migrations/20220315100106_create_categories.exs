defmodule Snownix.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :slug, :string
      add :title, :string
      add :description, :text
      add :status, :string, default: "active"
      add :parent_id, references(:categories, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:categories, [:parent_id])
    create index(:categories, [:slug], unique: true)
  end
end
