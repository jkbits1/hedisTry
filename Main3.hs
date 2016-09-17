{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Concurrent
-- import qualified Data.ByteString.Char8 as B

import Data.ByteString
import Data.Maybe
import Database.Redis
import Control.Monad.Trans

connInfo = defaultConnectInfo 
-- { connectHost = "172.17.0.2" }

mainx :: IO ()
mainx = do
    conn <- connect connInfo -- defaultConnectInfo
    -- forkIO $ do
    --     threadDelay 10000
    --     runRedis conn $ lpush "test1" ["0"]
    --     return ()
    -- bar <- runRedis conn $ blpop ["test1"] 0
    -- case bar of
    --         Left foobar -> putStrLn "Left"
    --         Right barfoo -> putStrLn "Right"
    runRedis conn $ do
        lpush "test1" ["0"]
    --     -- lpop items
    --     set "foo" "123"
    --     set "bar" "456"
    --     -- foo <- get "foo"
    --     foo <- get "test"
    --     -- bar <- get "bar"
    --     bar <- lpop items
    --     -- xs <- lpop items
    --     liftIO $ print (foo, bar)
        liftIO $ print (123, 345)


onlyStringResult :: ByteString -> Redis ByteString
onlyStringResult key = do
  value <- get key
  case value of
    Left _ -> return "Some error occurred"
    Right v -> return $ fromMaybe "Could not find key in store" v

initialStateNum = 1


main :: IO ()
main = stateLoop initialStateNum
--main = do   line <- getLine
--            if null line
--                then return ()
--                else do
--                    putStrLn $ line
----                    putBoard $ head line
--                    main

stateLoop n = do
  conn <- connect connInfo -- defaultConnectInfo
  line <- Prelude.getLine
  if Prelude.null line || n > 3
    then return ()
    else do
      result <- runRedis conn $ onlyStringResult "abc"
      print result
      -- putStrLn $ show 5
      -- runRedis conn $ do
      --     lpush "test1" ["0"]
      --     liftIO $ print (123, 345)

      stateLoop $ n + 1