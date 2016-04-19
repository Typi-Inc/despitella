ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Despite.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Despite.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Despite.Repo)

