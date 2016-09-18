defmodule Caravan.BillMember do
  use Caravan.Web, :model

  schema "bill_members" do
    field :paid, :boolean, default: false
    belongs_to :user, Caravan.User
    belongs_to :bill_item, Caravan.BillItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:paid, :user_id, :bill_item_id])
    |> validate_required([:paid, :user_id, :bill_item_id])
  end
end
