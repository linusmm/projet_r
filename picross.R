#Librairies à utiliser
library(tidyverse)

#creation picross 5X5
p5X5<-readxl::read_xlsx("picross_5X5.xlsx",sheet = "snake",col_names = F) %>%
  mutate(y=c(1:nrow(.))) %>%
  pivot_longer(cols=1:ncol(.)-1,names_to = "x",values_to = "couleur")%>%
  mutate(x=as.numeric(paste(substr(x,4,4)))*-1,
         couleur=as.factor(couleur))
p5X5
niveau<-readxl::read_xlsx("Choix niveau.xlsx",col_names = T)

ggplot(p5X5,aes(x,y,colour=couleur,shape=couleur))+geom_point(size=29)+scale_shape_manual(values=c(15,15))+scale_colour_manual(values=c("white","black"))

#Connexion au serveur shiny
library(shiny)
  #Page d'entrée de bienvenu
p5X5<-readxl::read_xlsx("picross_5X5.xlsx",sheet = "snake",col_names = F) %>%
  mutate(y=c(1:nrow(.))) %>%
  pivot_longer(cols=1:ncol(.)-1,names_to = "x",values_to = "couleur")%>%
  mutate(x=as.numeric(paste(substr(x,4,4)))*-1,
         couleur=as.factor(couleur))
p5X5
ui<-fluidPage("Bienvenu Etes-vous prêt à jouer?",#Rajouter une image, icône amusante sur chaque bouton?
              actionButton(inputId = "Facile", label ="Facile",choices=ls(p5X5)),
              actionButton(inputId = "Moyen", label ="moyen"),
              actionButton(inputId = "Difficile", label ="Difficile"),
              actionButton(inputId = "Impossible", label ="Impossible"), plotOutput("plot"))
server<-function(input,output,session){
  f<-reactive({
    input$Facile})
    output$plot<-renderPlot({
  })
}
shinyApp(ui,server)

ui <- fluidPage("Etes vous prêt pour jouer "
  titlePanel("Matrice de Boutons avec Shiny"),
  uiOutput("matrice_boutons")
)

server <- function(input, output) {
  output$matrice_boutons <- renderUI({
    nRows <- 5    # Définir le nombre de lignes
    nCols <- 5    # Définir le nombre de colonnes


    # Créer une matrice de boutons
    boutons <- lapply(1:(nRows * nCols), function(i) {
      actionButton(inputId = paste("bouton", i), label = paste("bouton", i),width = 5)
    })

    # Organiser les boutons en grille
    tagList(div(class = "btn-grid",
                lapply(split(boutons, ceiling(seq_along(boutons) / nCols)), div, class = "button-row")))
  })
}

shinyApp(ui = ui, server = server)

