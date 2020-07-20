library(dendextend)
library(colorspace)

PlotDend <- function(mat.d, file, method="average", k=6) {
  
  hc <- hclust(mat.d, method = method)
  
  # Create the dend:
  dend <- as.dendrogram(hc)
  
  lab.vec <- 1:6
  
  car_type <- 1:95
  for (lab in lab.vec) {
    is_x           <- grepl(lab, regions.d)
    car_type[is_x] <- lab
  }
  
  car_type     <- factor(car_type)
  n_car_types  <- length(unique(car_type))
  cols_4       <- rainbow_hcl(n_car_types, c = 70, l = 50)
  col_car_type <- cols_4[car_type]
  
  labels_colors(dend) <- col_car_type[order.dendrogram(dend)]
  
  pdf(file = file, height = 7, width = 20)
  plot(dend)
  rect.hclust(hc, k = k, border = "red")
  dev.off()
  
  return(0)
}
