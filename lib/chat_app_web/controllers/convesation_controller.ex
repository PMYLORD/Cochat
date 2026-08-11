defmodule ChatAppWeb.ConversationController do
  use ChatAppWeb, :controller

  alias ChatApp.Repo
  alias ChatApp.Conversations
  alias ChatApp.Messages
  alias ChatApp.Accounts.User

  def index(conn, _params) do
    conversations = Conversations.list_user_conversations(1)
    render(conn, :index, conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
  conversation = Repo.get!(Conversations.Conversation, id)
  messages = Messages.list_conversation_messages(id)
  users = Repo.all(User)
  # On passe current_user_id pour colorer les bulles correctement
  render(conn, :show, conversation: conversation, messages: messages, users: users, current_user_id: 1)
  end

  def create_message(conn, %{"id" => id, "sender_id" => sender_id, "content" => content}) do
    case Messages.send_message(String.to_integer(id), String.to_integer(sender_id), content) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, "Message envoyé")
        |> redirect(to: ~p"/conversations/#{id}")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Erreur")
        |> redirect(to: ~p"/conversations/#{id}")
    end
  end
end
