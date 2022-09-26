defmodule Bridgebreaker.AccountsTest do
  use Bridgebreaker.DataCase

  alias Bridgebreaker.Accounts

  describe "tokens" do
    alias Bridgebreaker.Accounts.Tokens

    import Bridgebreaker.AccountsFixtures

    @invalid_attrs %{name: nil}

    test "list_tokens/0 returns all tokens" do
      tokens = tokens_fixture()
      assert Accounts.list_tokens() == [tokens]
    end

    test "get_tokens!/1 returns the tokens with given id" do
      tokens = tokens_fixture()
      assert Accounts.get_tokens!(tokens.id) == tokens
    end

    test "create_tokens/1 with valid data creates a tokens" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tokens{} = tokens} = Accounts.create_tokens(valid_attrs)
      assert tokens.name == "some name"
    end

    test "create_tokens/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_tokens(@invalid_attrs)
    end

    test "update_tokens/2 with valid data updates the tokens" do
      tokens = tokens_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tokens{} = tokens} = Accounts.update_tokens(tokens, update_attrs)
      assert tokens.name == "some updated name"
    end

    test "update_tokens/2 with invalid data returns error changeset" do
      tokens = tokens_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_tokens(tokens, @invalid_attrs)
      assert tokens == Accounts.get_tokens!(tokens.id)
    end

    test "delete_tokens/1 deletes the tokens" do
      tokens = tokens_fixture()
      assert {:ok, %Tokens{}} = Accounts.delete_tokens(tokens)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_tokens!(tokens.id) end
    end

    test "change_tokens/1 returns a tokens changeset" do
      tokens = tokens_fixture()
      assert %Ecto.Changeset{} = Accounts.change_tokens(tokens)
    end
  end
end
