defmodule MtgSdkEx do
  alias MtgSdkEx.MagicCard

  @moduledoc """
  Documentation for MtgSdkEx.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MtgSdkEx.hello
      :world

  """
  def hello do
    :world
  end

  @doc "returns the name of the artist given a card id"
  def artist(card_id) do
    url = "https://api.magicthegathering.io/v1/cards/#{card_id}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts(body)
        Poison.decode!(body)["card"]["artist"]

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        IO.puts("Bad request :(")
        {:error, "Bad request"}

      {:ok, %HTTPoison.Response{status_code: 403}} ->
        IO.puts("Rate limit exceeded :(")
        {:error, "Rate limit exceeded"}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")
        {:error, "Card not found"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        IO.puts("Internal server error at magicthegathering.io :(")
        {:error, "Internal server error at magicthegathering.io"}

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        IO.puts("magicthegathering.io is offline for maintenance :(")
        {:error, "magicthegathering.io is offline for maintenance"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, "Internal error with mtg_sdk_ex, please report an issue on github"}
    end
  end

  @doc "returns the name of the artist given a card id"
  def set(set_code) do
    url = "https://api.magicthegathering.io/v1/sets/#{set_code}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        set = Poison.decode!(body)["set"]

        %MagicSet{
          block: set["block"],
          border: set["border"],
          code: set["code"],
          magic_cards_info_code: set["magicCardsInfoCode"],
          mkm_id: set["mkm_id"],
          mkm_name: set["mkm_name"],
          name: set["name"],
          release_date: set["releaseDate"],
          type: set["type"]
        }

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        IO.puts("Bad request :(")
        {:error, "Bad request"}

      {:ok, %HTTPoison.Response{status_code: 403}} ->
        IO.puts("Rate limit exceeded :(")
        {:error, "Rate limit exceeded"}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")
        {:error, "Card not found"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        IO.puts("Internal server error at magicthegathering.io :(")
        {:error, "Internal server error at magicthegathering.io"}

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        IO.puts("magicthegathering.io is offline for maintenance :(")
        {:error, "magicthegathering.io is offline for maintenance"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, "Internal error with mtg_sdk_ex, please report an issue on github"}
    end
  end

  @doc "returns the name of the artist given a card id"
  def cards_by_set(set_code, opts \\ []) do
    page_num = Keyword.get(opts, :page_num, 1)
    page_size = Keyword.get(opts, :page_size, 100)

    url =
      "https://api.magicthegathering.io/v1/cards?set=#{set_code}&page=#{page_num}&pageSize=#{
        page_size
      }"

    cards = nil

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        # convert list of header key-value pairs to a map to find the total count
        cards = Poison.decode!(body)["cards"]

        [
          {:num_cards_in_set, String.to_integer(Enum.into(headers, %{})["Total-Count"])},
          {:cards, cards},
          {:num_cards_in_page, length(cards)}
        ]

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        IO.puts("Bad request :(")
        {:error, "Bad request"}

      {:ok, %HTTPoison.Response{status_code: 403}} ->
        IO.puts("Rate limit exceeded :(")
        {:error, "Rate limit exceeded"}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")
        {:error, "Card not found"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        IO.puts("Internal server error at magicthegathering.io :(")
        {:error, "Internal server error at magicthegathering.io"}

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        IO.puts("magicthegathering.io is offline for maintenance :(")
        {:error, "magicthegathering.io is offline for maintenance"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, "Internal error with mtg_sdk_ex, please report an issue on github"}
    end
  end
end
