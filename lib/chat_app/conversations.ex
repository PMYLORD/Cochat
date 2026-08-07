defmodule ChatApp.Conversations do
  # Module responsable des opérations liées aux conversations.
  # Fournit des fonctions pour créer et lister des conversations utilisateurs.
  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias ChatApp.Conversations.{Conversation, Participant}

  # Crée une conversation privée entre deux utilisateurs si elle n'existe pas.
  # Retourne `{:ok, conversation}` si elle existe ou a été créée, sinon `{:error, changeset}`.
  def create_private_conversation(user1_id, user2_id) do
    # Vérifie l'existence d'une conversation privée entre les deux utilisateurs.
    case find_private_conversation(user1_id, user2_id) do
      # Si aucune conversation n'existe, on la crée avec `do_create_private_conversation/2`.
      nil -> do_create_private_conversation(user1_id, user2_id)
      # Si elle existe déjà, on la retourne.
      conversation -> {:ok, conversation}
    end
  end

  # Opération privée qui crée la conversation et les deux participants de façon atomique.
  # Utilise `Ecto.Multi` pour garantir la transactionalité : si une insertion échoue,
  # toutes les opérations sont annulées.
  defp do_create_private_conversation(user1_id, user2_id) do
    Ecto.Multi.new()
    # Insère la conversation (type "private").
    |> Ecto.Multi.insert(:conversation, %Conversation{type: "private"})

    # Insère le premier participant une fois la conversation créée.
    |> Ecto.Multi.insert(:participant_1, fn %{conversation: conversation} ->
      %Participant{conversation_id: conversation.id, user_id: user1_id, role: "member"}
    end)

    # Insère le second participant.
    |> Ecto.Multi.insert(:participant_2, fn %{conversation: conversation} ->
      %Participant{conversation_id: conversation.id, user_id: user2_id, role: "member"}
    end)

    # Exécute la transaction via le Repo. Retourne `{:ok, result_map}` ou `{:error, failed_op, changeset, changes}`.
    |> Repo.transaction()
    |> case do
      {:ok, %{conversation: conversation}} -> {:ok, conversation}
      {:error, _failed_operation, changeset, _changes} -> {:error, changeset}
    end
  end

  # Recherche une conversation privée impliquant `user1_id` et `user2_id`.
  # Utilise deux jointures sur `participants` pour s'assurer que les deux utilisateurs
  # sont participants de la même conversation. Renvoie `nil` si aucune trouvée.
  defp find_private_conversation(user1_id, user2_id) do
    from(c in Conversation,
      join: p1 in Participant, on: p1.conversation_id == c.id and p1.user_id == ^user1_id,
      join: p2 in Participant, on: p2.conversation_id == c.id and p2.user_id == ^user2_id,
      where: c.type == "private",
      limit: 1
    )
    |> Repo.one()
  end

  # Retourne la liste des conversations pour un utilisateur donné, ordonnée par
  # `updated_at` décroissant (les conversations les plus récemment actives en tête).
  def list_user_conversations(user_id) do
    from(c in Conversation,
      join: p in Participant, on: p.conversation_id == c.id,
      where: p.user_id == ^user_id,
      order_by: [desc: c.updated_at]
    )
    |> Repo.all()
  end
end
