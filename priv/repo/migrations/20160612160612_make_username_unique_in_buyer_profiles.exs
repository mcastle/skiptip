defmodule Skiptip.Repo.Migrations.MakeUsernameUniqueInBuyerProfiles do
  use Ecto.Migration

  def change do
    create unique_index(:buyer_profiles, [:username])
  end
end
