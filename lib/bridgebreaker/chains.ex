defmodule Bridgebreaker.Chains do
  def list_chains() do
    Path.join(Application.app_dir(:bridgebreaker), "priv/chain_data.json")
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(fn m ->
      Enum.map(m, fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})
    end)
  end
end
