defmodule Skiptip.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def up do
    create table(:locations) do
      add :user_id, :integer
      add :point, :geography

      timestamps
    end
  end

  def down do
    drop table(:locations)
  end

end
