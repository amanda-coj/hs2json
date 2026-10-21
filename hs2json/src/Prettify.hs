module Prettify
  ( Doc
  , empty
  , text
  , line
  , (<>)
  , (<+>)
  , nest
  , render
  ) where

import Prelude hiding ((<>))

data Doc
  = Empty
  | Text String
  | Line
  | Concat Doc Doc
  | Nest Int Doc
  deriving (Eq, Show)

empty :: Doc
empty = Empty

text :: String -> Doc
text = Text

line :: Doc
line = Line

infixr 6 <>
(<>) :: Doc -> Doc -> Doc
Empty <> right = right
left <> Empty = left
left <> right = Concat left right

infixr 6 <+>
(<+>) :: Doc -> Doc -> Doc
left <+> right = left <> text " " <> right

nest :: Int -> Doc -> Doc
nest amount document = Nest amount document

render :: Doc -> String
render document = go 0 document
  where
    go _ Empty = ""
    go _ (Text value) = value
    go indentation Line = '\n' : replicate indentation ' '
    go indentation (Concat left right) =
      go indentation left ++ go indentation right
    go indentation (Nest amount child) =
      go (indentation + amount) child