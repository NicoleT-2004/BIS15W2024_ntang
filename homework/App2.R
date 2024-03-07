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
          selectInput("z", "Select Ethnicity", choices = c("International", "African American", "All", "American Indian", "Asian", "Chicano/Latino", "Unknown", "White"),
                      selected = "African American")
      ),
      
      box(title = "Overall Enrollment", width = 9,
          plotOutput("plot", width = "800px", height = "600px")
      )
    )
  )
)

server <- function(input, output, session){
  
  session$onSessionEnded(stopApp) 
  
  output$plot <- renderPlot({
    
    UC_admit %>% 
      filter(Category == input$x) %>% 
      filter(Campus == input$y) %>%
      filter(Ethnicity == input$z) %>%
      ggplot(aes(x=Academic_Yr, y=FilteredCountFR))+ 
      geom_point()
    
  })
}

shinyApp(ui, server)