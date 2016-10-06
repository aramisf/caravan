defmodule Caravan.Bill do
  use Caravan.Web, :model

  schema "bills" do
    field :member_ids, {:array, :integer}, virtual: true
    field :total_amount, Money.Ecto.Type, virtual: true
    belongs_to :creator, Caravan.User
    belongs_to :payer, Caravan.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:creator_id, :payer_id, :member_ids, :total_amount])
    |> validate_required([:creator_id, :payer_id])
  end
end
