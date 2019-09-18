server <- function(input, output, session) {
  
  s <- MakeFeatureMatrix(-Inf, -3)
  
  push <- -1  
  observeEvent(input$alignment, {
    push <<- input$alignment
  })
  
  aln <- list()
  N <- 0
  output$table <- renderTable({
    if (input$alignment == push) {
      push <<- -1
      N <<- dim(input$word.file)[1]
      for (i in 1:N) {
        print(i)
        #word.list <- MakeWordList(paste("data", input$word, sep = "/"))
        word.list <- MakeWordList(input$word.file[i, ]$datapath)
        word.list <- MakeInputSeq(word.list)
        aln[[i]] <<- switch (input$method,
                             "Remove First" = RemoveFirst(word.list, s),
                             "Best First" = BestFirst(word.list, s),
                             "Random" = Random(word.list, s))
      }
      if (N == 1) {
        return(aln[[1]])
      } else {
        return("アラインメントが終了しました．")
      }
    } else {
      # no operation
    }
  })
  
  output$download <- downloadHandler(
    filename = function() {
      if (N == 1) {
        input$word.file[1, ]$name
      } else {
        "alignment.zip"
      }
    },
    content = function(file) {
      if (N == 1) {
        write.csv(aln[[1]], file)
      } else {
        fs <- c(NULL)
        for (i in 1:N) {
          path <- input$word.file[i, ]$name
          fs <- append(fs, path)
          write.csv(aln[[i]], path, row.names = F)
        }
        zip(zipfile=file, files=fs)
      }
    }
  )
  
}