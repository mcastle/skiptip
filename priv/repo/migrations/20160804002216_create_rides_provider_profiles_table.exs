defmodule Skiptip.Repo.Migrations.CreateRidesProviderProfilesTable do
  use Ecto.Migration

  def change do
    create table(:rides_provider_profiles) do
      add :user_id, :int
      add :preferred_payment_method, :string
      add :make, :int
      add :model, :int
      add :max_drive_distance, :int
      add :rate, :int
      add :max_seats, :int
      add :available, :boolean, default: false

      timestamps
    end
  end
end
