defmodule ChatApp.Messages.MessageStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "message_statuses" do
    field :status, :string, default: "delivered"

    belongs_to :message, ChatApp.Messages.Message
    belongs_to :user, ChatApp.Accounts.User

    timestamps()
  end

  def changeset(status, attrs) do
    status
    |> cast(attrs, [:status, :message_id, :user_id])
    |> validate_required([:status, :message_id, :user_id])
    |> validate_inclusion(:status, ~w(sent delivered read))
    |> unique_constraint([:message_id, :user_id])
  end
end
