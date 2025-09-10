#---------------------------------------------------------
# Dashboard Lei Seca - Exemplo Moderno (Shiny + Shinydashboard)
#---------------------------------------------------------

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

ui <- dashboardPage(
  skin = "blue",  # cor azul governamental
  dashboardHeader(title = "Dashboard Lei Seca"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visão Geral", tabName = "overview", icon = icon("dashboard")),
      menuItem("Legislação", tabName = "laws", icon = icon("balance-scale"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      #-------------------------
      # Aba 1 - Visão Geral
      #-------------------------
      tabItem(tabName = "overview",
              fluidRow(
                valueBox("12.345", "Total de Infrações", icon = icon("exclamation-triangle"), color = "blue"),
                valueBox("8.765", "Artigo 165", icon = icon("car"), color = "red"),
                valueBox("2.456", "Artigo 165-A", icon = icon("ban"), color = "orange"),
                valueBox("1.124", "Artigo 306", icon = icon("gavel"), color = "purple"),
                valueBox("87.089", "Testes Realizados", icon = icon("clipboard-check"), color = "green")
              )
      ),
      
      #-------------------------
      # Aba 2 - Legislação
      #-------------------------
      tabItem(tabName = "laws",
              fluidRow(
                box(
                  title = "Artigo 165",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  "Dirigir sob influência de álcool. Penalidade: multa (R$ 2.934,70), suspensão de 12 meses, recolhimento da CNH e retenção do veículo."
                )
              ),
              fluidRow(
                box(
                  title = "Artigo 165-A",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  "Recusa a se submeter ao teste do bafômetro. Penalidade idêntica ao Art. 165: multa (R$ 2.934,70), suspensão de 12 meses, recolhimento da CNH e retenção do veículo."
                )
              ),
              fluidRow(
                box(
                  title = "Artigo 306",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  "Configura crime dirigir com concentração de álcool igual ou superior a 6 dg/L de sangue ou 0,3 mg/L de ar alveolar. Pena: detenção (6 meses a 3 anos), multa e suspensão da habilitação."
                )
              )
      )
    )
  )
)

server <- function(input, output) { }

shinyApp(ui, server)
