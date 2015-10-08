-- P01 (*) Find the last element of a list.

lastItem :: [a] -> a
lastItem (x:[]) = x
lastItem (_:ys) = lastItem ys


-- P02 (*) Find the last but one element of a list.

lastButOne :: [a] -> a
lastButOne (x:_:[]) = x
lastButOne (_:ys) = lastButOne ys


-- P03 (*) Find the K'th element of a list.

elementAt :: Int -> [a] -> a
elementAt 1 (x:_) = x
elementAt i (_:ys) = elementAt (i - 1) ys


-- P04 (*) Find the number of elements of a list.

lengthOf :: [a] -> Int
lengthOf xs = len xs 0 where
    len [] acc = acc
    len (_:ys) acc = len ys (acc+1)
