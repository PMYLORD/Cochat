defmodule ChatApp.Messages do
  import Ecto.Query, warn: false
  alias ChatApp.Repo

  alias ChatApp.Messages.{Message, MessageStatus}

  def send_message(conversation_id, sender_id, content) do
    %Message{}
    |> Message.changeset(%{
      conversation_id: conversation_id,
      sender_id: sender_id,
      content: content
    })
    |> Repo.insert()
  end

  def list_conversation_messages(conversation_id) do
  from(m in Message,
    where: m.conversation_id == ^conversation_id,
    order_by: [asc: m.inserted_at],
    preload: [:sender]  # ← AJOUTÉ : charge les infos de l'expéditeur
  )
  |> Repo.all()
  end

  def mark_as_read(message_id, user_id) do
    case Repo.get_by(MessageStatus, message_id: message_id, user_id: user_id) do
      nil ->
        %MessageStatus{}

        |> MessageStatus.changeset(%{
          message_id: message_id,
          user_id: user_id,
          status: "read"
        })
        |> Repo.insert()

      status ->
        status
        |> MessageStatus.changeset(%{status: "read"})
        |> Repo.update()
    end
  end

  def get_message_statuses(message_id) do
    from(s in MessageStatus,
      where: s.message_id == ^message_id,
      preload: [:user]
    )
    |> Repo.all()
  end
end
