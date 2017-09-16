defmodule Restapi.Datastore do
  use GenServer

  alias Restapi.Post

  def start_link() do
    state = %{
        posts: %{},
        lastID: 0
      }
    GenServer.start_link(__MODULE__, state, [name: :datastore])
  end

  def get() do
    GenServer.call(:datastore, :get)
  end

  def get(id) do
    GenServer.call(:datastore, {:getByID, id})
  end

  def add(post) do
    GenServer.cast(:datastore, {:add, post})
  end

  def put(post) do
    GenServer.cast(:datastore, {:put, post})
  end

  def delete(postID) do
    GenServer.cast(:datastore, {:delete, postID})
  end

  def handle_call(:get, _from, state) do
    {:reply, state.posts, state}
  end

  def handle_call({:getByID, id}, _from, state) do
    {postID, _} = :string.to_integer(id)
    post = Map.get(state, :posts)
    |> Map.get(postID)

    {:reply, post, state}
  end

  def handle_cast({:add, post}, state) do
    #Affectation d'un ID à un post
    post = Map.put(post, :id, state.lastID + 1)

    #Ajout du post dans la liste de posts
    posts = Map.get(state, :posts)
      |> Map.put(post.id, post)


    new_state = Map.put(state, :lastID, state.lastID + 1)
      |> Map.put(:posts, posts)

    {:noreply, new_state}
  end

  def handle_cast({:put, %{"id" => postID} = post}, state) do
    posts = Map.get(state, :posts)
      |> Map.put(postID, post)

    new_state = Map.put(state, :posts, posts)
    {:noreply, new_state}
  end

  def handle_cast({:delete, id}, state) do
    {postID, _} = :string.to_integer(id)
    posts = Map.get(state, :posts)
      |> Map.delete(postID)

    new_state = Map.put(state, :posts, posts)
    {:noreply, new_state}
  end
end
