import Data.List

type Candidate = ([Char], Int)

-- First 3 functions obtained from class notes
removeDups :: Eq a => [a] -> [a]
removeDups lst = foldr (\x ss -> if elem x ss then ss else x : ss) [] lst

count :: Eq a => a -> [a] -> Int
count v xs = length (filter (== v) xs)

approvalCount :: [[String]] -> [Candidate]
approvalCount ballots = map (\(a,b) -> (b,a)) results
                        where 
                           allVotes   = concat (map removeDups ballots)
                           candidates = removeDups allVotes
                           rawCounts  = [(count c allVotes, c) | c <- candidates]
                           results    = reverse (sort rawCounts)

printCandidates :: [Candidate] -> String
printCandidates []            = []
printCandidates ((c, i) : ss) = c ++ ": " ++ (show i ++ "\n" ++ printCandidates ss)

main :: IO ()
main = do
       putStrLn "What is the name of the ballot file?"
       fileName <- getLine
       input    <- readFile fileName -- Obtained from (https://stackoverflow.com/questions/28861976/reading-file-into-string-haskell)

       rawBallots      <- return $ map words $ lines input
       filteredBallots <- return $ filter (not . null) $ map removeDups $ map (filter (/= "none")) rawBallots
       emptyBallots    <- return $ map concat $ filter (not . null) $ map (filter (== "none")) rawBallots
       fullLength      <- return $ length $ removeDups $ concat filteredBallots
       fullBallots     <- return $ filter (\x -> length x == fullLength) filteredBallots

       putStrLn $ "\n" ++ "Total # of ballots: " ++ (show $ length rawBallots) ++ "\n"
       putStrLn $ printCandidates $ approvalCount filteredBallots
       putStrLn $ "empty: " ++ (show $ length emptyBallots)
       putStrLn $ "full: " ++ (show $ length fullBallots)