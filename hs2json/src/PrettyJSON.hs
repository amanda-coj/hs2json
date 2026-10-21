module PrettyJSON
  ( renderJSON
  , renderJSONCompact
  , stringToDoc
  ) where

import Prelude hiding ((<>))
import Data.Char (chr, ord)
import Numeric (showHex)
import Prettify
import SimpleJSON

renderJSON :: JValue -> String
renderJSON = render . prettyValue 0

renderJSONCompact :: JValue -> String
renderJSONCompact = render . compactValue

stringToDoc :: String -> Doc
stringToDoc value =
  text ("\"" ++ concatMap escapeChar value ++ "\"")
  where
    escapeChar '"'  = "\\\""
    escapeChar '\\' = "\\\\"
    escapeChar '\b' = "\\b"
    escapeChar '\f' = "\\f"
    escapeChar '\n' = "\\n"
    escapeChar '\r' = "\\r"
    escapeChar '\t' = "\\t"
    escapeChar character
      | ord character < 0x20 = "\\u" ++ fourHex (ord character)
      | otherwise = [character]

    fourHex number =
      replicate (4 - length digits) '0' ++ digits
      where
        digits = map toUpperHex (showHex number "")

    toUpperHex character
      | character >= 'a' && character <= 'f' =
          chr (ord character - ord 'a' + ord 'A')
      | otherwise = character

prettyValue :: Int -> JValue -> Doc
prettyValue _ JNull = text "null"
prettyValue _ (JBool value) =
  text (if value then "true" else "false")
prettyValue _ (JNumber value) = text (show value)
prettyValue _ (JString value) = stringToDoc value
prettyValue level (JArray values) =
  prettyArray (map (prettyValue (level + 1)) values)
prettyValue level (JObject fields) =
  prettyObject level fields

prettyArray :: [Doc] -> Doc
prettyArray [] = text "[]"
prettyArray values =
  text "[" <>
  line <>
  nest 2 (text "  " <> joinWith (text "," <> line) values) <>
  line <>
  text "]"

prettyObject :: Int -> [(String, JValue)] -> Doc
prettyObject _ [] = text "{}"
prettyObject level fields =
  text "{" <>
  line <>
  nest 2
    (text "  " <> joinWith (text "," <> line) renderedFields) <>
  line <>
  text "}"
  where
    renderedFields =
      [ stringToDoc key <> text ": " <> prettyValue (level + 1) value
      | (key, value) <- fields
      ]

joinWith :: Doc -> [Doc] -> Doc
joinWith _ [] = empty
joinWith separator (firstDocument:rest) =
  firstDocument <> appendRest rest
  where
    appendRest [] = empty
    appendRest (document:documents) =
      separator <> document <> appendRest documents

compactValue :: JValue -> Doc
compactValue JNull = text "null"
compactValue (JBool value) =
  text (if value then "true" else "false")
compactValue (JNumber value) = text (show value)
compactValue (JString value) = stringToDoc value
compactValue (JArray values) =
  text "[" <>
  joinWith (text ",") (map compactValue values) <>
  text "]"
compactValue (JObject fields) =
  text "{" <>
  joinWith (text ",") (map renderField fields) <>
  text "}"
  where
    renderField (key, value) =
      stringToDoc key <> text ":" <> compactValue value
