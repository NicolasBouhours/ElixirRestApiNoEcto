defmodule Restapi.DatastoreTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, datastore} = start_supervised Restapi.Datastore
  end
  
end
