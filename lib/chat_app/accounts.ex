defmodule ChatApp.Accounts do
  # Récupère le module du dépôt Ecto pour les opérations de base de données.
  alias ChatApp.Repo
  # Récupère le schéma utilisateur pour créer et valider un utilisateur.
  alias ChatApp.Accounts.User

  # Crée un nouvel utilisateur à partir des attributs fournis.
  # Cette fonction construit un utilisateur vide, applique les validations,
  # puis l'insère dans la base de données.
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
