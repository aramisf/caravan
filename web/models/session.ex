defmodule Caravan.Session do
  use Caravan.Web, :model

  alias Caravan.Repo
  alias Caravan.Session
  alias Caravan.User

  schema "sessions" do
    field :email, :string, virtual: true
    field :password, :string, virtual: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  def find_user_and_validate_password(params \\ %{}) do
    changeset = Session.changeset(%Session{}, params)

    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{email: email, password: password}
      } ->
        user = Repo.get_by(User, email: email)

        cond do
          user && Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
            {:ok, user}
          user ->
            {:error, add_error(changeset, :password, "is invalid")}
          true ->
            Comeonin.Bcrypt.dummy_checkpw
            {:error, add_error(changeset, :email, "is not registered")}
        end
      _ ->
        {:error, changeset}
    end
  end
end
