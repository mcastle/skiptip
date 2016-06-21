defmodule Skiptip.Repo.Migrations.AddEmailFieldToBuyerProfiles do
  use Ecto.Migration

  def change do
    alter table(:buyer_profiles) do
      add :email, :string
    end 
    create unique_index(:buyer_profiles, [:email])
  end
end
