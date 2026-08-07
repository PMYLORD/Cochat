defmodule ChatApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
      add :sender_id, references(:users, on_delete: :nilify_all), null: false
      add :content, :text, null: false

      timestamps()
    end

    create index(:messages, [:conversation_id])
  end
end
