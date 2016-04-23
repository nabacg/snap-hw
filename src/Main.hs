{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Data.Aeson

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "HELLOW") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          , ("ping", pingHandler)
          ] <|>
    dir "static" (serveDirectory ".")

pingHandler :: Snap ()
pingHandler =  do 
    writeBS (encode [1..100])
    --writeJSON [1..10]

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param
