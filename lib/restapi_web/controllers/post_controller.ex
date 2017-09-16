defmodule RestapiWeb.PostController do
  use RestapiWeb, :controller

  alias Restapi.Datastore

  def index(conn, _params) do
    posts = Datastore.get()
    json conn, posts
  end

  def show(conn, %{"id" => id}) do
    post = Datastore.get(id)
    json conn, post
  end

  def create(conn, params) do
    Datastore.add(params)
    json conn, params
  end

  def update(conn, params) do
    Datastore.put(params)

    json conn, params
  end

  def delete(conn, %{"id" => id}) do
    Datastore.delete(id)
    json conn, id
  end

end
