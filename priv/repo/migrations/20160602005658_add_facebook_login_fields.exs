defmodule Skiptip.Repo.Migrations.AddFacebookLoginFields do
  use Ecto.Migration

  def change do
    alter table(:facebook_logins) do
      add :user_id, :integer
      add :facebook_user_id, :string
      add :facebook_access_token, :string

    end
  end
end
