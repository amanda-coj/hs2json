module Main (main) where

import PrettyJSON
import SimpleJSON

example :: JValue
example =
  JObject
    [ ("projeto", JString "hs2json")
    , ("unidade", JNumber 2)
    , ("aprovado", JBool True)
    , ("observacao", JString "JSON com\nquebras e acentos: café")
    , ("participantes", JArray
        [ JString "Pessoa 1"
        , JString "Pessoa 2"
        ])
    , ("metadados", JNull)
    ]

main :: IO ()
main = do
  putStrLn "=== JSON formatado ==="
  putStrLn (renderJSON example)

  putStrLn "\n=== JSON compacto ==="
  putStrLn (renderJSONCompact example)

  putStrLn "\n=== Accessors ==="
  print (getString (JString "exemplo"))
  print (getInt (JNumber 42))
  print (isNull JNull)
