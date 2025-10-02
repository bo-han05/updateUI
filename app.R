library(shiny)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Dataset Visualizer"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "dataset",
                        label = "Choose a dataset",
                        choices = c("airquality", "mtcars")),
            selectInput(inputId = "xvar",
                        label = "Choose X variable",
                        choices = NULL),
            selectInput(inputId = "yvar",
                        label = "Choose Y variable",
                        choices = NULL),
            actionButton(inputId = "plot",
                         label = "Plot!")
        ),
        mainPanel(
          plotOutput("summary")
        )
    )
)

server <- function(input, output, session) {
  observeEvent(input$dataset, {
    dat <- get(input$dataset)
    updateSelectInput(session, "xvar", choices = names(dat))
    updateSelectInput(session, "yvar", choices = names(dat))
  })

  observeEvent(input$xvar, {
    dat <- get(input$dataset)
    updateSelectInput(session, "yvar", 
                      choices = setdiff(names(dat), input$xvar))
  })

  dat <- eventReactive(input$plot, {
    get(input$dataset)
  })
  
  xvar <- eventReactive(input$plot, {
    input$xvar
  })
  
  yvar <- eventReactive(input$plot, {
    input$yvar
  })

  output$summary <- renderPlot({
    ggplot(dat(), aes(x = .data[[xvar()]], y = .data[[yvar()]])) +
      geom_point() +
      labs(title = sprintf("Scatterplot of %s vs %s", yvar(), xvar()))
  })
}
shinyApp(ui, server)