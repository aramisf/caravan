defmodule Caravan.BillItem do
  use Caravan.Web, :model

  schema "bill_items" do
    field :description, :string
    field :member_ids, {:array, :integer}, virtual: true
    field :amount, Money.Ecto.Type
    belongs_to :bill, Caravan.Bill

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bill_id, :description, :amount])
    |> validate_required([:bill_id, :amount])
  end
end
