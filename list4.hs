
-- http://stackoverflow.com/questions/36664552/get-a-string-from-runredis-conn-get-hello-haskell

{-# LANGUAGE OverloadedStrings #-}
module Main(main) where

import Control.Monad.IO.Class
import Data.ByteString
import Data.Maybe
import Database.Redis

wheel1 = "wheel1"

rotate xs = Prelude.drop 1 xs ++ Prelude.take 1 xs

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
main =
  do 
    conn <- connect defaultConnectInfo
    listLoop conn 1 

listLoop conn n =
  do 
    line <- Prelude.getLine
    if Prelude.null line
      then return ()
      else 
        do
          runRedis conn $ do 
            rs <- lrange wheel1 0 $ -1
            liftIO $ print $ rotate $ valToList rs 
          listLoop conn $ n + 1

-- lpush "items" "it1"
-- llen items
-- lrange "items" 0 1
-- lrange "items" 0 -1
