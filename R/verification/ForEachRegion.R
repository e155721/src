source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")

ForEachRegion <- function(f, correct, wordList, s,
                          ansratePath, comparePath, regions)
{
  # making gold standard
  MakeGoldStandard(f, correct, comparePath, regions, s)
  
  # making pairwise
  count <- MakePairwise(f, correct, wordList, s,
                        ansratePath, comparePath, regions)
  
  # output the matching rate
  sink(ansratePath, append = T)
  npairs <- sum((regions-1):1)
  matchingRate <- count / npairs * 100
  rlt <- paste(f["name"], matchingRate, sep = " ")
  print(rlt, quote = F)
  sink()
  
  return(0)
}
