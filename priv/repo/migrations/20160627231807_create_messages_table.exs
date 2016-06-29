defmodule Skiptip.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user_id, :int
      add :recipient_id, :int
      add :body, :text
      timestamps
    end
  end
end
