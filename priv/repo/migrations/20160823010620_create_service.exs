defmodule Skiptip.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :provider_id, :integer
      add :consumer_id, :integer
      add :phase, :integer
      add :kind, :integer

      timestamps
    end

  end
end
