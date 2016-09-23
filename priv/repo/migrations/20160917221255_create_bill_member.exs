defmodule Caravan.Repo.Migrations.CreateBillMember do
  use Ecto.Migration

  def change do
    create table(:bill_members) do
      add :paid, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :bill_item_id, references(:bill_items, on_delete: :delete_all)

      timestamps()
    end
    create index(:bill_members, [:user_id])
    create index(:bill_members, [:bill_item_id])
    create index(:bill_members, [:paid])

  end
end
