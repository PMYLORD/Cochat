defmodule ChatApp.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :type, :string, null: false, default: "private"

      timestamps()
    end
  end
end
