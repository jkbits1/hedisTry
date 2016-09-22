{-# LANGUAGE OverloadedStrings #-}

module Main where

import Database.Redis
import Control.Monad.Trans

-- main :: IO ()
-- main = putStrLn "Hello, Haskell!"

connInfo = defaultConnectInfo 
-- { connectHost = "172.17.0.2" }

main :: IO ()
main = do
    conn <- connect connInfo
    runRedis conn $ do
        set "foo" "123"
        set "bar" "456"
        foo <- get "foo"
        bar <- get "bar"
        liftIO $ print (foo, bar)
