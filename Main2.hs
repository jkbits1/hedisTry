{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Concurrent
import qualified Data.ByteString.Char8 as B

import Database.Redis
import Control.Monad.Trans

-- main :: IO ()
-- main = putStrLn "Hello, Haskell!"

connInfo = defaultConnectInfo 
-- { connectHost = "172.17.0.2" }

main :: IO ()
main = do
    conn <- connect connInfo -- defaultConnectInfo
    forkIO $ do
        threadDelay 10000
        runRedis conn $ lpush "test1" ["0"]
        return ()
    bar <- runRedis conn $ blpop ["test1"] 0
    case bar of
            Left foobar -> putStrLn "Left"
            Right barfoo -> putStrLn "Right"

    -- runRedis conn $ do
    --     bar <- lpop items
    --     liftIO $ print (foo, bar)
