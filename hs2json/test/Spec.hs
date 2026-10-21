module Main (main) where

import PrettyJSON
import SimpleJSON
import Test.QuickCheck

instance Arbitrary JValue where
  arbitrary = sized genJValue
    where
      genJValue size
        | size <= 0 =
            oneof
              [ pure JNull
              , JBool <$> arbitrary
              , JNumber <$> choose (-1000, 1000)
              , JString <$> shortString
              ]
        | otherwise =
            oneof
              [ pure JNull
              , JBool <$> arbitrary
              , JNumber <$> choose (-1000, 1000)
              , JString <$> shortString
              , JArray <$>
                  resize (size `div` 2)
                    (listOf (genJValue (size `div` 2)))
              , JObject <$>
                  resize (size `div` 2)
                    (listOf field)
              ]
        where
          field = do
            key <- elements ["id", "nome", "ativo", "valor"]
            value <- genJValue (size `div` 2)
            pure (key, value)

      shortString =
        listOf (elements (['a' .. 'z'] ++ [' ', '\n', '\t', '"', '\\']))

prop_string_accessor :: String -> Property
prop_string_accessor value =
  getString (JString value) === Just value

prop_number_accessor :: Double -> Property
prop_number_accessor value =
  getDouble (JNumber value) === Just value

prop_boolean_accessor :: Bool -> Property
prop_boolean_accessor value =
  getBool (JBool value) === Just value

prop_null_accessor :: Property
prop_null_accessor =
  isNull JNull === True

prop_wrong_accessor :: Property
prop_wrong_accessor =
  conjoin
    [ getString JNull === Nothing
    , getBool JNull === Nothing
    , getArray JNull === Nothing
    ]

prop_string_is_escaped :: Property
prop_string_is_escaped =
  renderJSONCompact (JString "linha\ncom\ttexto")
    === "\"linha\\ncom\\ttexto\""

main :: IO ()
main = do
  quickCheck prop_string_accessor
  quickCheck prop_number_accessor
  quickCheck prop_boolean_accessor
  quickCheck prop_null_accessor
  quickCheck prop_wrong_accessor
  quickCheck prop_string_is_escaped
