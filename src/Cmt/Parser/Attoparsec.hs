{-# LANGUAGE NoImplicitPrelude #-}

module Cmt.Parser.Attoparsec where

import ClassyPrelude

import Data.Attoparsec.Text

import Cmt.Types.Config

lexeme :: Parser a -> Parser a
lexeme p = skipSpace *> p <* skipSpace

tchar :: Char -> Parser Text
tchar ch = singleton <$> char ch

chopt :: Char -> Parser Text
chopt ch = option "" (tchar ch)

tnotChar :: Char -> Parser Text
tnotChar c = pack <$> many' (notChar c)

commentP :: Parser ()
commentP = lexeme $ skipMany (char '#' *> manyTill anyChar endOfLine)

stripComments :: Parser a -> Parser a
stripComments p = lexeme $ commentP *> p <* commentP

word :: Parser Text
word = pack <$> many1 (letter <|> space)

valid :: [Name] -> Parser Text
valid names = choice $ "*" : (string <$> names)
