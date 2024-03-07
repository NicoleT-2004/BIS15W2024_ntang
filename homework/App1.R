ui <- dashboardPage(
  
  dashboardHeader(title = "UC Admission"),
  
  dashboardSidebar(disable=T),
  
  dashboardBody(
    fluidRow(
      box(title = "Options", width = 3,
          
          selectInput("x", "Select Category", choices = c("Admits", "Applicants", "Enrollees"),
                      selected = "Admits"),
          selectInput("y", "Select Campus", choices = c("Davis", "Berkeley", "Irvine", "Los_Angeles", "Merced", "Riverside", "San_Diego", "Santa_Barbara", "Santa_Cruz"),
                      selected = "Davis"),
          sliderInput("year", "Select Year", min = 2010, max = 2019, value = 2010, step = 1),
      ),   
      
      box(title = "Ethnicity Distribution", width = 9,
          plotOutput("plot", width = "800px", height = "600px")
      ) 
    ) 
  ) 
) 

server <- function(input, output, session) {
  
  session$onSessionEnded(stopApp) 
  
  output$plot <- renderPlot({
    
    UC_admit %>% 
      filter(Ethnicity != "All") %>%
      filter(Category == input$x) %>% 
      filter(Campus == input$y) %>%
      filter(Academic_Yr == input$year) %>%
      ggplot(aes(x=Ethnicity, y=FilteredCountFR)) + 
      geom_col()
  })
}

shinyApp(ui, server)