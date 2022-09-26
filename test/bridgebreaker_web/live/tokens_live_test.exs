defmodule BridgebreakerWeb.TokensLiveTest do
  use BridgebreakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bridgebreaker.AccountsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_tokens(_) do
    tokens = tokens_fixture()
    %{tokens: tokens}
  end

  describe "Index" do
    setup [:create_tokens]

    test "lists all tokens", %{conn: conn, tokens: tokens} do
      {:ok, _index_live, html} = live(conn, Routes.tokens_index_path(conn, :index))

      assert html =~ "Listing Tokens"
      assert html =~ tokens.name
    end

    test "saves new tokens", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.tokens_index_path(conn, :index))

      assert index_live |> element("a", "New Tokens") |> render_click() =~
               "New Tokens"

      assert_patch(index_live, Routes.tokens_index_path(conn, :new))

      assert index_live
             |> form("#tokens-form", tokens: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tokens-form", tokens: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tokens_index_path(conn, :index))

      assert html =~ "Tokens created successfully"
      assert html =~ "some name"
    end

    test "updates tokens in listing", %{conn: conn, tokens: tokens} do
      {:ok, index_live, _html} = live(conn, Routes.tokens_index_path(conn, :index))

      assert index_live |> element("#tokens-#{tokens.id} a", "Edit") |> render_click() =~
               "Edit Tokens"

      assert_patch(index_live, Routes.tokens_index_path(conn, :edit, tokens))

      assert index_live
             |> form("#tokens-form", tokens: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tokens-form", tokens: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tokens_index_path(conn, :index))

      assert html =~ "Tokens updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes tokens in listing", %{conn: conn, tokens: tokens} do
      {:ok, index_live, _html} = live(conn, Routes.tokens_index_path(conn, :index))

      assert index_live |> element("#tokens-#{tokens.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tokens-#{tokens.id}")
    end
  end

  describe "Show" do
    setup [:create_tokens]

    test "displays tokens", %{conn: conn, tokens: tokens} do
      {:ok, _show_live, html} = live(conn, Routes.tokens_show_path(conn, :show, tokens))

      assert html =~ "Show Tokens"
      assert html =~ tokens.name
    end

    test "updates tokens within modal", %{conn: conn, tokens: tokens} do
      {:ok, show_live, _html} = live(conn, Routes.tokens_show_path(conn, :show, tokens))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tokens"

      assert_patch(show_live, Routes.tokens_show_path(conn, :edit, tokens))

      assert show_live
             |> form("#tokens-form", tokens: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tokens-form", tokens: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tokens_show_path(conn, :show, tokens))

      assert html =~ "Tokens updated successfully"
      assert html =~ "some updated name"
    end
  end
end
