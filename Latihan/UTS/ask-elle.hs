
--- Encoding ---
fromBin lists = sum [2^i | (i,x)<- zip [(length lists -1), (length lists -2) .. 0] lists, x == 1]