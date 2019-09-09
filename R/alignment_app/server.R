server <- function(input, output) {
  
  output$table <- renderTable({
    
    if (input$alignment != 0) {
      aln <- switch (input$var,
                     "Phoneme Feature" = PF(input$word),
                     "Levenshtein" = LV(input$word))
    }
    
  })
  
}