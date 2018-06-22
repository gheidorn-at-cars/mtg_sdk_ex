defmodule MtgTest do
  use ExUnit.Case
  doctest Mtg

  test "find a card and return it" do
    assert Mtg.card(1)
  end

  test "finds a card and returns the artist name" do
    assert Mtg.artist(1) == "Amy Weber"
    assert Mtg.artist(2) == "Jesper Myrfors"
  end

  test "returns a list of cards for a given set code" do
    assert Mtg.set("ktk") == %MagicSet{
             block: "Khans of Tarkir",
             border: "black",
             code: "KTK",
             magic_cards_info_code: "ktk",
             mkm_id: 1495,
             mkm_name: "Khans of Tarkir",
             name: "Khans of Tarkir",
             release_date: "2014-09-26",
             type: "expansion"
           }
  end

  test "can't find the card and return an error" do
    assert Mtg.artist(111_111_111) == {:error, "Resource not found"}
  end

  test "can't find the set and return an error" do
    assert Mtg.set(1) == {:error, "Resource not found"}
  end

  test "get all mtg game formats" do
    assert length(Mtg.formats()) > 0
  end

  test "get all mtg card types" do
    assert length(Mtg.types()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /types endpoint
  """
  test "mtg card types contain relevant data" do
    types = Mtg.types()
    assert Enum.member?(types, "Artifact")
    assert Enum.member?(types, "Sorcery")
    assert Enum.member?(types, "Instant")
    assert Enum.member?(types, "Creature")
  end

  test "get all mtg card subtypes" do
    assert length(Mtg.subtypes()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /subtypes endpoint
  """
  test "mtg card subtypes contain relevant data" do
    subtypes = Mtg.subtypes()
    assert Enum.member?(subtypes, "Angel")
    assert Enum.member?(subtypes, "Demon")
  end

  test "get all mtg card supertypes" do
    assert length(Mtg.supertypes()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /supertypes endpoint
  """
  test "mtg card supertypes contain relevant data" do
    supertypes = Mtg.supertypes()
    assert Enum.member?(supertypes, "Basic")
    assert Enum.member?(supertypes, "Legendary")
  end
end
