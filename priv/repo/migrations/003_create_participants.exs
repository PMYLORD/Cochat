defmodule ChatApp.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role, :string, null: false, default: "member"

      timestamps()
    end

    create unique_index(:participants, [:conversation_id, :user_id])
    create index(:participants, [:user_id])
  end
end
