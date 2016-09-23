defmodule Caravan.Repo.Migrations.CreateBillItem do
  use Ecto.Migration

  def change do
    create table(:bill_items) do
      add :description, :string
      add :amount, :integer
      add :bill_id, references(:bills, on_delete: :delete_all)

      timestamps()
    end
    create index(:bill_items, [:bill_id])

  end
end
