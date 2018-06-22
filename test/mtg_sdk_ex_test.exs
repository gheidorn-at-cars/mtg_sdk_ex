defmodule MtgSdkExTest do
  use ExUnit.Case
  doctest MtgSdkEx

  test "find a card and return it" do
    assert MtgSdkEx.card(1)
  end

  test "finds a card and returns the artist name" do
    assert MtgSdkEx.artist(1) == "Amy Weber"
    assert MtgSdkEx.artist(2) == "Jesper Myrfors"
  end

  test "returns a list of cards for a given set code" do
    assert MtgSdkEx.set("ktk") == %MagicSet{
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
    assert MtgSdkEx.artist(111_111_111) == {:error, "Resource not found"}
  end

  test "can't find the set and return an error" do
    assert MtgSdkEx.set(1) == {:error, "Resource not found"}
  end

  test "get all mtg game formats" do
    assert length(MtgSdkEx.formats()) > 0
  end

  test "get all mtg card types" do
    assert length(MtgSdkEx.types()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /types endpoint
  """
  test "mtg card types contain relevant data" do
    types = MtgSdkEx.types()
    assert Enum.member?(types, "Artifact")
    assert Enum.member?(types, "Sorcery")
    assert Enum.member?(types, "Instant")
    assert Enum.member?(types, "Creature")
  end

  test "get all mtg card subtypes" do
    assert length(MtgSdkEx.subtypes()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /subtypes endpoint
  """
  test "mtg card subtypes contain relevant data" do
    subtypes = MtgSdkEx.subtypes()
    assert Enum.member?(subtypes, "Angel")
    assert Enum.member?(subtypes, "Demon")
  end

  test "get all mtg card supertypes" do
    assert length(MtgSdkEx.supertypes()) > 0
  end

  @doc """
  Let's make sure there's some reasonable data returned from the /supertypes endpoint
  """
  test "mtg card supertypes contain relevant data" do
    supertypes = MtgSdkEx.supertypes()
    assert Enum.member?(supertypes, "Basic")
    assert Enum.member?(supertypes, "Legendary")
  end
end
