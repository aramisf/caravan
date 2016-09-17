defmodule Caravan.Bill do
  use Caravan.Web, :model

  schema "bills" do
    belongs_to :creator, Caravan.User
    belongs_to :payer, Caravan.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:creator_id, :payer_id])
    |> validate_required([:creator_id, :payer_id])
  end
end
