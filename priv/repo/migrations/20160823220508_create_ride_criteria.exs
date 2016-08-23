defmodule Skiptip.Repo.Migrations.CreateRideCriteria do
  use Ecto.Migration

  def change do
    create table(:ride_criteria) do
      add :service_id, :integer
      add :origin, :geography
      add :destination, :geography
      add :pickup_time, :datetime
      add :dropoff_time, :datetime
      add :seat_count, :integer
      add :rate, :integer

      timestamps
    end

  end
end
