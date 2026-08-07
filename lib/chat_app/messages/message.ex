defmodule ChatApp.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string

    belongs_to :conversation, ChatApp.Conversations.Conversation
    belongs_to :sender, ChatApp.Accounts.User, foreign_key: :sender_id

    has_many :statuses, ChatApp.Messages.MessageStatus

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :conversation_id, :sender_id])
    |> validate_required([:content, :conversation_id, :sender_id])
  end
end
