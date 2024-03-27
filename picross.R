#Librairie
library("stringi")
library(shiny)
library(tidyverse)

#creation picross 5X5 d'essai
p5X5 <-
  readxl::read_xlsx("picross_5X5.xlsx", sheet = "snake", col_names = F)

#Comptage du nombre de carreaux noire qui se suivent
vec <- paste(p5X5$...1, collapse = "")
attributes(gregexpr("1+", vec)[[1]])[["match.length"]]

lapply(p5X5, function(i) {
  attributes(gregexpr("1+", p5X5)[[1]])[["match.length"]]
})

#Conversion pour générer le ggplot
p5X5 <-
  readxl::read_xlsx("picross_5X5.xlsx", sheet = "snake", col_names = F) %>%
  mutate(y = c(1:nrow(.))) %>%
  pivot_longer(cols = 1:ncol(.) - 1,
               names_to = "x",
               values_to = "couleur") %>%
  mutate(x = as.numeric(paste(substr(x, 4, 4))) * -1,
         couleur = as.factor(couleur))
p5X5

(ggplot(p5X5, aes(x, y, colour = couleur, shape = couleur)) 
  + geom_point(size = 29) + scale_shape_manual(values = c(15, 15)) 
  + scale_colour_manual(values = c("white", "black"))
)

#Application shiny

ui <- fluidPage(
  #Rajouter une image, icône amusante sur chaque bouton?
  #plotOutput("plot",choices= p5X5),
  #imageOutput("image",width="100%",choices=img),
  #mainPanel(img(src='image.png', height = '100px', width = '100px')),
  titlePanel(
    "Bienvenu dans le merveilleux monde de la relaxation et du casse tête"
  ),
  uiOutput("matrice_boutons"),
  #selectInput(inputId = "niveau", label="niveau",choices = unique(choix$Niveau)),
  actionButton(
    inputId = "Facile",
    label = "Facile",
    choices = p5X5
  ),
  #voir en remplaçant par un plotOutput() à l'intérieur
  actionButton(inputId = "Moyen", label = "moyen"),
  actionButton(inputId = "Difficile", label = "Difficile"),
  actionButton(inputId = "Impossible", label = "Impossible")
)


server <- function(input, output, session) {
  # output$image<-renderImage({ima<-get(input$image,"image")
  # ima})
  facile <- reactive({
    input$Facile
  })
  output$matrice_boutons <- renderUI({
    nRows <- 5    # Définir le nombre de lignes
    nCols <- 5    # Définir le nombre de colonnes
    # Créer une matrice de boutons
    boutons <- lapply(1:(nRows * nCols), function(i) {
      actionButton(
        inputId = paste("bouton", i),
        label = paste("X", i),
        width = 5,
        icon = icon("square", class = "fa-sharp fa-solid fa-square")
      )
    })
    # Organiser les boutons en grille
    tagList(div(class = "btn-grid",
                lapply(split(
                  boutons, ceiling(seq_along(boutons) / nCols)
                ), div, class = "button-row")))
  })
}
shinyApp(ui, server)
