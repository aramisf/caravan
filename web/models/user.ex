defmodule Caravan.User do
  use Caravan.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :name, :string
    field :role, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :role])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:role, ["admin"])
  end

  @doc """
  Builds a changeset for creation, with password encryption
  """
  def creation_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> encrypt_password
  end


  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        encrypted_password = Comeonin.Bcrypt.hashpwsalt(password)
        put_change(changeset, :encrypted_password, encrypted_password)
      _ ->
        changeset
    end
  end
end
