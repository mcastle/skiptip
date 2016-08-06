defmodule Skiptip.Repo.Migrations.CreateBuyerProfile do
  use Ecto.Migration

  def change do
    create table(:buyer_profiles) do
      add :user_id, :int
      add :name, :string
      add :display_name, :string
      add :username, :string
      add :bio, :string
      add :picture_url, :string

      timestamps
    end

  end
end
