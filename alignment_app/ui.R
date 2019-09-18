library(shiny)

source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_nwunsch.R")
source("lib/load_verif_lib.R")

source("msa/RemoveFirst.R")
source("msa/BestFirst.R")
source("msa/Random.R")

path.list <- GetPathList("data")
file.vec <- list2mat(path.list)[, 2]

ui <- fluidPage(
  titlePanel("発音記号列アラインメントツール"),
  
  sidebarLayout(
    sidebarPanel(
      
      if (0) {
        selectInput("word",
                    label = "入力ファイルの選択",
                    choices = c(file.vec))
      },
      fileInput("word.file", "入力ファイルを選択してください", 
                multiple = T, buttonLabel = "選択", placeholder = "ファイルが選択されていません"),
      selectInput("method", 
                  label = "アラインメント手法の選択",
                  choices = c("Remove First", "Best First", "Random")),
      actionButton("alignment", "アラインメント"),
      downloadButton("download", "ダウンロード")
      
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)
