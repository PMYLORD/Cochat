defmodule ChatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Définition du schéma Ecto pour la table des utilisateurs.
  # Ici on décrit les champs disponibles et leurs types.
  schema "users" do
    # Numéro de téléphone de l'utilisateur, stocké sous forme de chaîne.
    field :phone, :string
    # Nom d'utilisateur utilisé pour l'identification.
    field :username, :string
    # Nom affiché à l'utilisateur dans l'interface.
    field :display_name, :string

    # Ajoute automatiquement les colonnes d'horodatage créées à partir de la base.
    timestamps()
  end

  # Crée un changeset pour valider et préparer les données d'un utilisateur.
  # Ce changeset est utilisé avant l'insertion ou la mise à jour en base.
  def changeset(user, attrs) do
    user
    # Filtre et accepte uniquement les champs autorisés.
    |> cast(attrs, [:phone, :username, :display_name])
    # Vérifie que le champ phone est obligatoire.
    |> validate_required([:phone])
    # Vérifie que le téléphone respecte un format précis (ex. +1234567890).
    |> validate_format(:phone, ~r/^\+[1-9]\d{1,14}$/)
    # Empêche les doublons sur le numéro de téléphone.
    |> unique_constraint(:phone)
  end
end
