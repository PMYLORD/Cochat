defmodule ChatApp.Conversations.Conversation do
  # Module qui représente une conversation (salon, discussion privée, etc.).
  # Contient les associations vers les participants et les utilisateurs.
  use Ecto.Schema

  schema "conversations" do
    # Type de conversation : par exemple "private" ou "group".
    # Valeur par défaut "private" si aucun type n'est fourni.
    field :type, :string, default: "private"

    # Association vers les enregistrements `Participant` liés à cette
    # conversation. Une conversation a plusieurs participants.
    has_many :participants, ChatApp.Conversations.Participant

    # Association through pour accéder directement aux `User` associés via
    # la table `participants`. Permet d'écrire `conversation |> Repo.preload(:users)`.
    has_many :users, through: [:participants, :user]

    # Colonnes `inserted_at` et `updated_at` automatiquement maintenues par Ecto.
    timestamps()
  end
end
