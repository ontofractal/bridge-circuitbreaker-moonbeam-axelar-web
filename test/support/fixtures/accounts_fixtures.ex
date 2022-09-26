defmodule Bridgebreaker.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bridgebreaker.Accounts` context.
  """

  @doc """
  Generate a tokens.
  """
  def tokens_fixture(attrs \\ %{}) do
    {:ok, tokens} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Bridgebreaker.Accounts.create_tokens()

    tokens
  end
end
