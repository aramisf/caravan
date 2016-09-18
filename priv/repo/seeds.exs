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

superadmin = %{
  email: "super@admin.com",
  name: "SuperAdmin",
  password: "poorguy",
  role: "admin"
}
Caravan.Repo.insert!(Caravan.User.creation_changeset(%Caravan.User{}, superadmin))
