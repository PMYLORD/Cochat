defmodule ChatApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  # Crée la migration qui va ajouter la table des utilisateurs à la base de données.
  def change do
    create table(:users) do
      # Le numéro de téléphone est obligatoire et doit être unique.
      add :phone, :string, null: false
      # Nom d'utilisateur facultatif.
      add :username, :string
      # Nom affiché facultatif.
      add :display_name, :string

      # Ajoute automatiquement les colonnes created_at et updated_at.
      timestamps()
    end

    # Empêche les doublons sur le téléphone en créant un index unique.
    create unique_index(:users, [:phone])
  end
end
