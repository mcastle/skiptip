defmodule Skiptip.Repo.Migrations.ChangeBioMaxLength do
  use Ecto.Migration

  def change do
    alter table(:buyer_profiles) do
      modify :bio, :string, size: 1000
    end
  end
end
