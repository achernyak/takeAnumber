ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TakeAnumber.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TakeAnumber.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TakeAnumber.Repo)

