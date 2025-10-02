library(shiny)

ui <- fluidPage(
    titlePanel("Dataset Visualizer"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "dataset",
                        label = "Choose a dataset",
                        choices = c("airquality", "mtcars")),
            selectInput(inputId = "variable",
                        label = "Choose a variable",
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
        updateSelectInput(inputId = "variable",
                          choices = names(dat))
    })
    dat <- eventReactive(input$plot, {
        get(input$dataset)
    })
    variable <- eventReactive(input$plot, {
        input$variable
    })
    output$summary <- renderPlot({
        dat() |>
            ggplot(aes(y = .data[[variable()]])) +
            geom_boxplot() +
            labs(title = sprintf("Boxplot of %s", variable()))
    })
}
shinyApp(ui, server)