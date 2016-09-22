
-- http://stackoverflow.com/questions/36664552/get-a-string-from-runredis-conn-get-hello-haskell

{-# LANGUAGE OverloadedStrings #-}
module Main(main) where

import Control.Monad.IO.Class
import Data.ByteString
import Data.Maybe
import Database.Redis

valToStr :: Either Reply (Maybe ByteString) -> ByteString
valToStr val =
  case val of
    Left b  -> "no reply"
    Right m ->
      case m of 
        Nothing -> "empty reply"
        Just s  -> s 

valToList :: Either Reply [t1] -> [t1]
valToList val = 
  case val of
    Left _    -> []
    Right xs  -> xs        

-- main :: IO (Either Reply (Maybe ByteString))
main :: IO ()
main = do
  conn <- connect defaultConnectInfo
  
  runRedis conn $ do 
    rs   <- lrange "items" 0 1
    liftIO $ print $ valToList rs 
