ExUnit.configure(exclude: [buff_ex_external: true])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BuffEx.Repo, :manual)
