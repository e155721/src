server <- function(input, output, session) {
  
  push <- -1  
  
  observeEvent(input$alignment, {
    push <<- input$alignment
  })
  
  output$table <- renderTable({
    if (input$alignment == push) {
      push <<- -1
      switch (input$method,
              "Phoneme Feature" = PF(input$word),
              "Levenshtein" = LV(input$word))
    }
  })
  
}