#------------------------------------------------------------------------------#
# Dashboard Lei Seca - Versão Completa
#------------------------------------------------------------------------------#
library(shiny)
library(shinydashboard)
library(plotly)
library(ggplot2)
library(tibble)
library(dplyr)
library(magrittr)
library(DT)
library(echarts4r)
#------------------------------------------------------------------------------#

# FRONT END -------------------------------------------------------------------#
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Lei Seca"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("📊 Estatísticas Gerais", tabName = "estatisticas", icon = icon("chart-bar")),
      menuItem("📈 Análises Interativas", tabName = "analises", icon = icon("line-chart")),
      menuItem("📑 Base de Dados", tabName = "dados", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      # Aba Estatísticas Gerais --------------------------------
      tabItem(tabName = "estatisticas",
              fluidRow(
                valueBoxOutput(width = 2,"box_testes"),
                valueBoxOutput(width = 3, "box_total"),
                valueBoxOutput(width = 2, "box_165"),
                valueBoxOutput(width = 2, "box_165a"),
                valueBoxOutput(width = 2, "box_306")
              ),
              fluidRow(
                box(width = 12, 
                    title = "Análise Interativa", 
                    solidHeader = TRUE, 
                    status = "primary",
                    echarts4rOutput("grafico_interativo", height = "400px"))
              )
      ),
      # Aba Análises Interativas -------------------------------
      tabItem(tabName = "analises",
              fluidRow(
                box(width = 12, title = "Filtros Interativos", solidHeader = TRUE, status = "primary",
                    selectInput("filtro_ano", "Selecione o Ano:", choices = c(2022, 2023, 2024)),
                    selectInput("filtro_regiao", "Selecione a Região:", choices = c("Norte", "Sul", "Leste", "Oeste"))
                )
              )
      ),
      # Aba Base de Dados -------------------------------------
      tabItem(tabName = "dados",
              fluidRow(
                box(width = 12, title = "Tabela Completa", solidHeader = TRUE, status = "primary",
                    DTOutput("tabela_dados", height = "400px"))
              )
      )
      
    )
  )
)
# SERVER ----------------------------------------------------------------------#
server <- function(input, output, session) {
  
  # ------------------------------
  # Simulação de valores gerais
  # ------------------------------
  total_infracoes <- 7.446
  art_165   <- 2.258
  art_165a  <- 4.204
  art_306   <- 984
  testes_realizados <- 87.089
  
  # ValueBoxes
  output$box_total <- renderValueBox({
    valueBox(total_infracoes, "Infrações Lavradas (Alcoolemia)", icon = icon("car-crash"), color = "blue")
  })
  
  output$box_165 <- renderValueBox({
    valueBox(art_165, "Infração Art. 165", icon = icon("gavel"), color = "red")
  })
  
  output$box_165a <- renderValueBox({
    valueBox(art_165a, "Recusa Art. 165-A", icon = icon("ban"), color = "orange")
  })
  
  output$box_306 <- renderValueBox({
    valueBox(art_306, "Crime Art. 306", icon = icon("balance-scale"), color = "purple")
  })
  
  output$box_testes <- renderValueBox({
    valueBox(testes_realizados, "Testes Realizados", icon = icon("cannabis"), color = "green")
  })
  
  # ------------------------------
  # Base de dados
  # ------------------------------
  lei_seca <- tribble(
    ~Mes,      ~Abordagens, ~Infracoes_Embriaguez, ~Prisoes_Embriaguez, ~Infracoes_Recusa, ~Testes_Realizados, ~Veiculos_Removidos, ~Agentes_Transito, ~Abordagens_Educativas,
    "Janeiro",   3014,  2,  1,  93, 2921, 27,   61,    NA,
    "Fevereiro", 1178, 24,  2,  58,  326, 70,  220,    NA,
    "Março",     1665, 18,  5,  62,  437, 58,  317,   114,
    "Abril",      964, 12,  5,  29,  326, 45,  532,   116,
    "Maio",      1230, 17,  6,  36,  541, 45,  532,   109,
    "Junho",     1053, 18,  3,  47,  433, 87, 1442,  3803,
    "Julho",     1749, 77, 18,  47,  881, 77, 1749,   276,
    "Agosto",    3742, 95, 28, 115, 1290, 49, 2879,   181
  )
  

  # Renderizar tabela
  output$tabela_dados <- renderDT({
    datatable(lei_seca, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  output$grafico_interativo <- renderEcharts4r({
  
  # Criar gráfico interativo
    lei_seca %>%
      mutate(Mes = factor(Mes, levels = c("Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto"))) %>%
      e_charts(Mes) %>%
      e_line(Infracoes_Embriaguez, name = "Art.165",
             lineStyle = list(width = 4), itemStyle = list(color = "red")) %>%
      e_line(Infracoes_Recusa, name = "Art.165-A",
             lineStyle = list(width = 4), itemStyle = list(color = "blue")) %>%
      e_line(Prisoes_Embriaguez, name = "Art.306",
             lineStyle = list(width = 4), itemStyle = list(color = "green")) %>%
      e_tooltip(trigger = "axis") %>%
      e_legend(right = "10%", textStyle = list(fontSize = 14)) %>%
      e_title("Infrações e Prisões - Lei Seca", textStyle = list(fontSize = 18)) %>%
      e_y_axis(name = "Número de Infrações", axisLabel = list(fontSize = 14)) %>%
      e_x_axis(name = "Mês", axisLabel = list(fontSize = 14)) 
    
  })
  
}

# RUN APP ---------------------------------------------------------------
shinyApp(ui, server)
