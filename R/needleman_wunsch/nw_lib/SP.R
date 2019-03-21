SP <- function(prof1, prof2, s)
{
  # make profiles
  prof <- rbind(prof1, prof2)
  prof.len <- length(prof)
  len1 <- prof.len-1
  len2 <- prof.len
  
  sp <- 0
  l <- 2
  for (k in 1:len1) {
    for (m in l:len2) {
      sp <- sp + s[prof[k], prof[m]]
    }
    l <- l + 1
  }
  return(sp)
}