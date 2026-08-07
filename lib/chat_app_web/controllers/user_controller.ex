defmodule ChatAppWeb.UserController do
  use ChatAppWeb, :controller

  alias ChatApp.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"phone" => phone, "username" => username}}) do
    case Accounts.create_user(%{phone: phone, username: username}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Compte créé : #{user.phone}")
        |> redirect(to: ~p"/conversations")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Erreur : numéro invalide ou déjà utilisé")
        |> render(:new)
    end
  end
end
