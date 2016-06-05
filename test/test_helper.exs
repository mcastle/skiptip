ExUnit.start(exclude: [:skip])

Mix.Task.run "ecto.create", ~w(-r Skiptip.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Skiptip.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Skiptip.Repo)

