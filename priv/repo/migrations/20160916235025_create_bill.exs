defmodule Caravan.Repo.Migrations.CreateBill do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :creator_id, references(:users, on_delete: :nothing)
      add :payer_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:bills, [:creator_id])
    create index(:bills, [:payer_id])

  end
end
