# Make regions.
#regions <- read.table("../../Data/regions.txt")$V1
regions <- read.table("../../Data/regions2.txt")$V1

regions.d        <- rep(NA, 95)
regions.d[1:16]  <- paste(1, regions[1:16])
regions.d[17:30] <- paste(2, regions[17:30])
regions.d[31:73] <- paste(3, regions[31:73])
regions.d[74:81] <- paste(4, regions[74:81])
regions.d[82:93] <- paste(5, regions[82:93])
regions.d[94:95] <- paste(6, regions[94:95])
