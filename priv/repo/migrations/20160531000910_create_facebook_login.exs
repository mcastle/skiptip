defmodule Skiptip.Repo.Migrations.CreateFacebookLogin do
  use Ecto.Migration

  def change do
    create table(:facebook_logins) do

      timestamps
    end

  end
end
