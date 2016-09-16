# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Caravan.Repo.insert!(%Caravan.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

poorguy = %{
  email: "poor@mail.com",
  name: "Poor",
  password: "poor",
  role: "admin"
}
Caravan.Repo.insert!(Caravan.User.creation_changeset(%Caravan.User{}, poorguy))
