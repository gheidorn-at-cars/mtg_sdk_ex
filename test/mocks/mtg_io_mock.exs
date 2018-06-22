defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule MtgMock do
  def card(card_id) do
    {:ok, successful_response}
  end

  defp successful_response do
    %HTTPoison.Response{
      body:
        "{\"card\":{\"name\":\"Ankh of Mishra\",\"manaCost\":\"{2}\",\"cmc\":2,\"type\":\"Artifact\",\"types\":[\"Artifact\"],\"rarity\":\"Rare\",\"set\":\"LEA\",\"setName\":\"Limited Edition Alpha\",\"text\":\"Whenever a land enters the battlefield, Ankh of Mishra deals 2 damage to that land's controller.\",\"artist\":\"Amy Weber\",\"layout\":\"normal\",\"multiverseid\":1,\"imageUrl\":\"http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=1&type=card\",\"rulings\":[{\"date\":\"2004-10-04\",\"text\":\"This triggers on any land entering the battlefield. This includes playing a land or putting a land onto the battlefield using a spell or ability.\"},{\"date\":\"2004-10-04\",\"text\":\"It determines the land's controller at the time the ability resolves. Ifthe land leaves the battlefield before the ability resolves, the land's last controller before it left is used.\"}],\"printings\":[\"LEA\",\"LEB\",\"2ED\",\"CED\",\"CEI\",\"3ED\",\"4ED\",\"5ED\",\"6ED\",\"MED\",\"VMA\"],\"originalText\":\"Ankh does 2 damageto anyone who puts a new land into play.\",\"originalType\":\"Continuous Artifact\",\"legalities\":[{\"format\":\"Commander\",\"legality\":\"Legal\"},{\"format\":\"Legacy\",\"legality\":\"Legal\"},{\"format\":\"Vintage\",\"legality\":\"Legal\"}],\"id\":\"8a5d85644f546525433c4472b76c3b0ebb495b33\"}}",
      headers: [
        {"Date", "Thu, 21 Jun 2018 20:36:29 GMT"},
        {"Content-Type", "application/json; charset=utf-8"},
        {"Content-Length", "1191"},
        {"Connection", "keep-alive"},
        {"Set-Cookie",
         "__cfduid=d92b94b354643acb384c8cc104a913f201529613389; expires=Fri, 21-Jun-19 20:36:29 GMT; path=/; domain=.magicthegathering.io; HttpOnly; Secure"},
        {"X-Frame-Options", "SAMEORIGIN"},
        {"X-Xss-Protection", "1; mode=block"},
        {"X-Content-Type-Options", "nosniff"},
        {"Etag", "W/\"4c2f68fd74b5ae7470f7d0d4421ff62b\""},
        {"Cache-Control", "max-age=0, private, must-revalidate"},
        {"X-Request-Id", "5bf7a01a-f714-42ea-b04d-5eb5190fe57d"},
        {"Ratelimit-Limit", "1000"},
        {"Ratelimit-Remaining", "999"},
        {"X-Runtime", "0.417292"},
        {"Vary", "Origin"},
        {"Via", "1.1 vegur"},
        {"Expect-CT",
         "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\""},
        {"Server", "cloudflare"},
        {"CF-RAY", "42e94481cc0c55ca-ORD"}
      ],
      status_code: 200
    }
  end
end
