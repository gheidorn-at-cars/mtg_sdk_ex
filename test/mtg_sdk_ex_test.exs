defmodule MtgSdkExTest do
  use ExUnit.Case
  doctest MtgSdkEx

  test "greets the world" do
    assert MtgSdkEx.hello() == :world
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

  test "can't find the card and returns an error" do
    assert MtgSdkEx.artist(111_111_111) == {:error, "Card not found"}
  end
end
