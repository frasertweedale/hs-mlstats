-- This file is part of nmstats - mailing list statistics extractor
-- Copyright (C) 2015  Red Hat, Inc.
--
-- hs-notmuch is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Control.Monad ((>=>))
import Data.Foldable (traverse_)
import Data.Semigroup ((<>))
import System.Environment (getArgs)
import Text.Printf (printf)

import Data.Time (Day, addDays, getZonedTime, utctDay, zonedTimeToUTC)

import Notmuch
import Notmuch.Search


main :: IO ()
main = do

  [db'', listAddr, fromDomain, daysArg] <- getArgs
  db' <- databaseOpen db''
  today <- fmap (utctDay . zonedTimeToUTC) getZonedTime

  let
    n = abs $ read daysArg
    dates = zipWith (addDays . (0-)) [n,n-1..0] (repeat today)

  case db' of
    Left status -> putStrLn $ "Error: " <> show status
    Right db ->
      traverse_ (infoForDate db listAddr fromDomain >=> printTable) dates

infoForDate
  :: Database
  -> String   -- ^ list address
  -> String   -- ^ origin domain
  -> Day
  -> IO (Day, Int, Int, Int)
infoForDate db listAddr fromDomain date = do
  let
    dateExpr = Date <$> show <*> show $ date
    toListExpr = To listAddr
    fromDomainExpr = From ("*@" <> fromDomain)
  allMsgs <- query db (dateExpr `And` toListExpr)
  notFromDomainMsgs <- query db (dateExpr `And` toListExpr `And` Not fromDomainExpr)
  nMsgs <- queryCountMessages allMsgs
  nMsgsNotFromDomain <- queryCountMessages notFromDomainMsgs
  nThreads <- queryCountThreads allMsgs
  return (date, nMsgs, nMsgsNotFromDomain, nThreads)

printVerbose :: String -> (Day, Int, Int, Int) -> IO ()
printVerbose fromDomain (date, nMsgs, nMsgsNotFromDomain, nThreads) = do
  print date
  putStrLn $ " " <> show nMsgs <> " messages"
  putStrLn $ " " <> show nMsgsNotFromDomain <> " messages not from " <> fromDomain
  putStrLn $ " " <> show nThreads <> " active threads"

printTable :: (Day, Int, Int, Int) -> IO ()
printTable (d, n, m, p) = printf "%s %d %d %d\n" (show d) n m p
