defmodule ChatApp.Conversations.Participant do
  use Ecto.Schema

  schema "participants" do
    field :role, :string, default: "member"

    belongs_to :conversation, ChatApp.Conversations.Conversation
    belongs_to :user, ChatApp.Accounts.User

    timestamps()
  end
end
