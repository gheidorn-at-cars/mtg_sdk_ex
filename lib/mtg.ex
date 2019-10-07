defmodule Mtg do
  require Logger

  @moduledoc """
  Mtg module provides functions that make calls to magicthegathering.io for game information.
  """

  # template function that makes the actual http call and handles the response
  defp call_api(url, f, params \\ []) do
    case HTTPoison.get(url, [], params: params, recv_timeout: 30000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        Logger.info(fn -> IO.inspect(headers) end)

        f.(headers, body)

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        Logger.error(fn ->
          IO.puts("Bad request :(")
        end)

        {:error, "Bad request"}

      {:ok, %HTTPoison.Response{status_code: 403}} ->
        Logger.error(fn ->
          IO.puts("Rate limit exceeded :(")
          {:error, "Rate limit exceeded"}
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info(fn ->
          IO.puts("Not found :(")
        end)

        {:error, "Resource not found"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        Logger.error(fn ->
          IO.puts("Internal server error at magicthegathering.io :(")
        end)

        {:error, "Internal server error at magicthegathering.io"}

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        Logger.error(fn ->
          IO.puts("magicthegathering.io is offline for maintenance :(")
        end)

        {:error, "magicthegathering.io is offline for maintenance"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(fn ->
          IO.inspect(reason)
        end)

        {:error, "Internal error with mtg_sdk_ex, please report an issue on github"}
    end
  end

  @doc "returns the name of the artist given a card id"
  def artist(card_id) do
    url = "https://api.magicthegathering.io/v1/cards/#{card_id}"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["card"]["artist"]
    end

    call_api(url, handle_200)
  end

  @doc "returns the information for a card given a card multiverse id"
  def card(multiverse_id) do
    url = "https://api.magicthegathering.io/v1/cards/#{multiverse_id}"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["card"]
    end

    call_api(url, handle_200)
  end

  @doc "returns the name of the artist given a card id"
  def set(set_code) do
    url = "https://api.magicthegathering.io/v1/sets/#{set_code}"

    handle_200 = fn headers, body ->
      set = Poison.decode!(body)["set"]

      Logger.info(fn ->
        IO.puts(set)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

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
    end

    call_api(url, handle_200)
  end

  @doc "returns a list of cards by set"
  def cards(opts \\ []) do
    params =
      [
        {:artist, Keyword.get(opts, :artist, nil)},
        {:name, Keyword.get(opts, :name, nil)},
        {:layout, Keyword.get(opts, :layout, nil)},
        {:cmc, Keyword.get(opts, :cmc, nil)},
        {:colors, Keyword.get(opts, :colors, nil)},
        {:colorIdentity, Keyword.get(opts, :color_identity, nil)},
        {:supertypes, Keyword.get(opts, :supertypes, nil)},
        {:types, Keyword.get(opts, :types, nil)},
        {:subtypes, Keyword.get(opts, :subtypes, nil)},
        {:type, Keyword.get(opts, :type, nil)},
        {:rarity, Keyword.get(opts, :rarity, nil)},
        {:set, Keyword.get(opts, :set, nil)},
        {:setName, Keyword.get(opts, :set_name, nil)},
        {:text, Keyword.get(opts, :text, nil)},
        {:flavor, Keyword.get(opts, :flavor, nil)},
        {:number, Keyword.get(opts, :number, nil)},
        {:power, Keyword.get(opts, :power, nil)},
        {:toughness, Keyword.get(opts, :toughness, nil)},
        {:loyalty, Keyword.get(opts, :loyalty, nil)},
        {:language, Keyword.get(opts, :language, nil)},
        {:gameFormat, Keyword.get(opts, :game_format, nil)},
        {:legality, Keyword.get(opts, :legality, nil)},
        {:orderBy, Keyword.get(opts, :order_by, nil)},
        {:random, Keyword.get(opts, :random, nil)},
        {:contains, Keyword.get(opts, :contains, nil)},
        # a unique id for a card built as a SHA1 hash of setCode, cardName, cardImageName
        {:id, Keyword.get(opts, :id, nil)},
        {:multiverseId, Keyword.get(opts, :multiverse_id, nil)},
        {:page, Keyword.get(opts, :page_num, 1)},
        {:pageSize, Keyword.get(opts, :page_size, 100)}
      ]
      |> Enum.filter(fn {_, v} -> v != nil end)

    url = "https://api.magicthegathering.io/v1/cards"

    handle_200 = fn headers, body ->
      # convert list of header key-value pairs to a map to find the total count
      cards = Poison.decode!(body)["cards"]

      [
        {:num_cards_in_set, String.to_integer(Enum.into(headers, %{})["Total-Count"])},
        {:cards, cards},
        {:num_cards_in_page, length(cards)}
      ]
    end

    call_api(url, handle_200, params)
  end

  @doc "returns a list of cards by set"
  def cards_by_set(set_code, opts \\ []) do
    page_num = Keyword.get(opts, :page_num, 1)
    page_size = Keyword.get(opts, :page_size, 100)

    url =
      "https://api.magicthegathering.io/v1/cards?set=#{set_code}&page=#{page_num}&pageSize=#{
        page_size
      }"

    handle_200 = fn headers, body ->
      # convert list of header key-value pairs to a map to find the total count
      cards = Poison.decode!(body)["cards"]

      [
        {:num_cards_in_set, String.to_integer(Enum.into(headers, %{})["Total-Count"])},
        {:cards, cards},
        {:num_cards_in_page, length(cards)}
      ]
    end

    call_api(url, handle_200)
  end

  @doc "returns a list of strings representing the formats of MTG"
  def formats() do
    url = "https://api.magicthegathering.io/v1/formats"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["formats"]
    end

    call_api(url, handle_200)
  end

  @doc "returns a list of strings representing the types of MTG cards"
  def types() do
    url = "https://api.magicthegathering.io/v1/types"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["types"]
    end

    call_api(url, handle_200)
  end

  @doc "returns a list of strings representing the subtypes of MTG cards"
  def subtypes() do
    url = "https://api.magicthegathering.io/v1/subtypes"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["subtypes"]
    end

    call_api(url, handle_200)
  end

  @doc "returns a list of strings representing the supertypes of MTG cards"
  def supertypes() do
    url = "https://api.magicthegathering.io/v1/supertypes"

    handle_200 = fn headers, body ->
      Logger.info(fn ->
        IO.puts(body)
        rate_limit_remaining = Enum.into(headers, %{})["Ratelimit-Remaining"]
        IO.puts("Ratelimit-Remaining #{rate_limit_remaining}")
      end)

      Poison.decode!(body)["supertypes"]
    end

    call_api(url, handle_200)
  end
end
