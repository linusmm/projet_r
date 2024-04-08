library(shiny)
library(plotly)
library(ggplot2)
library(shinyjs)
library(DT)
library(shinythemes)
library(shinyAce)
library(png)
library(patchwork)
library(RColorBrewer)
library(shinydashboard)
library(leaflet)
library(bslib)
library(shinyWidgets)
library(caTools)
library(shinyalert)
library(stringi)

function(request){navbarPage(

  #tags$b(textOutput("titre_dialogue")),
  #           textOutput("dialogue"),
  #htmlOutput("dialogue"),

  tags$link(
    rel = "stylesheet",
    href="https://fonts.googleapis.com/css?family=Tangerine"
  ),

  tags$style(
    "
  * {
font-family: Lucida Sans;
font-size: 15px;
  }

    .custom_description {
    font-size: 17px;
    font-family: Lucida Sans;
      border-radius: 15px;
border-style: solid;
border-color: #560000;

 padding: 15px

    }

  .btn {
    height: 60px;
    width: 60px;
    border: 10px;
    margin-top: 2px;
    margin-bottom: 2px;
    margin-left: 2px;
    margin-right: 2px;
  }

  }
  "
  ),


  theme = bs_theme(version = 4, bootswatch = "minty"),

  collapsible = T,

  useShinyjs(),

  ## PAGE ACCUEIL ET OPTIONS ----
  tabPanel(

    #Name
    "Sélection des options",

    fluidRow(
      style="opacity:1; background-color: white ;margin-top: 0px; width: 100%;",
      column(5,offset=0, align="justify",

             fluidRow(
               br(),
               ### Image Mario ----
               img(src="image.png",height='320px',width='380px'),
               hr(),

               ### Sélection taille et difficulté ----
               shinydashboard::box(id = "selection_box", width=12,

                                   tags$b("Choisissez un niveau de difficulté"),br(),
                                   uiOutput("select_difficulte"),

                                   tags$b("Choisissez une taille de grille"),br(),
                                   uiOutput("select_taille"),
               ),
               actionButton('submit', label = "Sélectionner", style= "width: 35%; height: 100%"),
             )
      ),

      # ),


      column(6,offset=0, align="justify",
             br(),

             ### Description ----
             htmlOutput("description_accueil", class="custom_description"),
             br(),
             br(),

      )),

    br(),br(),


    #Black line?
    # fluidRow( style=" opacity: 0.8 ; background-color: white ; margin-top: 0px ; width: 100%; "  ), br(),

    # === Last bandeau for the logos
    # fluidRow(
    #
    #   # Set the style of this page
    #   style=" opacity: 0.8 ; background-color: black ; margin-top: 0px ; width: 100%; ",
    #   br()
    # )

    #Close the tabPanel
  ),


  ## PAGE JOUER ----
  tabPanel(
    #actionButton('choice_deplacement', label = "Se déplacer"),

    #Name
    "Jouer",

    fluidRow(
      column(6,offset=0, align="justify",
      ### Indications verticales ----
      uiOutput("matrice_ind_vert"),
      br(),
      )
    ),
    fluidRow(
      ### Indications verticales ----
      # fluidRow(
      #   uiOutput("matrice_ind_vert"),
      #
      # ),

      ### Picross ----
        column(5,offset=0, align="justify",
               uiOutput("matrice_boutons"),
        ),

      ### Indications horizontales ----

      column(3,offset=0, align="justify",
             uiOutput("matrice_ind_hor"),
      br(), br(), br(),

     # shinydashboard::box(id = "description_quete", width=4, status="primary", collapsible=T, htmlOutput("description_quete", class="custom_description_quete")),
    )
    )


  ),
  #
  # ## PAGE SAUVEGARDE ----
  # tabPanel(
  #
  #   #Name
  #   "Sauvegarder",
  #
  #   fluidRow(
  #     bookmarkButton()
  #   )
  #
  #
  # ),







  #Close the shinyUI
)}
#))
