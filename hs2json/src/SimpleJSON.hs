
module SimpleJSON
  ( JValue(..)
  , getString
  , getInt
  , getDouble
  , getBool
  , getObject
  , getArray
  , isNull
  ) where

data JValue
  = JString String
  | JNumber Double
  | JBool Bool
  | JNull
  | JObject [(String, JValue)]
  | JArray [JValue]
  deriving (Eq, Show)

getString :: JValue -> Maybe String
getString (JString value) = Just value
getString _ = Nothing

getInt :: JValue -> Maybe Int
getInt (JNumber value)
  | value == fromIntegral integer = Just integer
  | otherwise = Nothing
  where
    integer = round value
getInt _ = Nothing

getDouble :: JValue -> Maybe Double
getDouble (JNumber value) = Just value
getDouble _ = Nothing

getBool :: JValue -> Maybe Bool
getBool (JBool value) = Just value
getBool _ = Nothing

getObject :: JValue -> Maybe [(String, JValue)]
getObject (JObject value) = Just value
getObject _ = Nothing

getArray :: JValue -> Maybe [JValue]
getArray (JArray value) = Just value
getArray _ = Nothing

isNull :: JValue -> Bool
isNull JNull = True
isNull _ = False
