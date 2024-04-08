

server <- function(input, output, session) {

  ## IMPORT ----

  myReactives <- reactiveValues()


  alerte <- reactiveVal()
  alerte(TRUE)

  ## Sauvegarde ----

  # INITIALISATION ----

  # solution cachée au début

  shinyjs::disable("submit")

  ### Initialisation des éléments ----

  p5X5<-as.data.frame(readxl::read_xlsx("picross_5X5.xlsx",sheet = "snake",col_names = FALSE))
  p5X5[2,1]=0
  p5X5[1,2]=0

  ind_vert <- apply(p5X5, MARGIN=2, function(x){attributes(gregexpr("1+", paste(x,collapse=""))[[1]])[["match.length"]]})
  ind_hor <- apply(p5X5, MARGIN=1, function(x){attributes(gregexpr("1+", paste(x,collapse=""))[[1]])[["match.length"]]})

  ind_vert = stri_list2matrix(ind_vert, byrow=FALSE)
  ind_hor = stri_list2matrix(ind_hor, byrow=TRUE)

  ind_vert[which(ind_vert==-1)]=0 # Pour les cas où une colonne/ligne est vide, il y avait un pb
  ind_hor[which(ind_hor==-1)]=0

  ind_vert = apply(ind_vert, MARGIN=2, function(x){c(rep(NA, length(which(is.na(x)))), x[1:length(x)-length(which(is.na(x)))])})

  ind_vert[is.na(ind_vert)]=" "
  ind_hor[is.na(ind_hor)]=" "

  ### Message début ----

  observe({

    if (alerte() == TRUE) {

      shinyalert("Jouer à Shiny Picross !", "<p style='font-size: 100%'>

      Bienvenue dans le merveilleux monde de la relaxation et du casse-tête !
             <br><br>

      Ce mini-jeu dans lequel vous pouvez choisir plusieurs niveaux de difficulté et tailles de grille
      vous assurera des heures et des heures de bonheur et d'épanouissement.
             <br><br>

      Sponsorisé par Mario.

      <br><br>
      Sandrine & Linus.
             </p>
             ", type = "success", size="m", html=T, confirmButtonText="C'est parti !", confirmButtonCol='#B74d53') #B74d53 #f3969a #074c87


    }

    alerte(FALSE)

  })

  # Texte
  output$description_accueil <-renderUI(HTML("<b>Les règles du Picross :</b><br/><br/>
                                             Le but d'un Picross est de colorer les cases de la grille afin de faire apparaître une image.  <br/>
                                             Les nombres à gauche et au dessus de la grille sont là pour vous aider à déduire les cases à colorer. <br/><br/>
                                             Sélectionnez d'abord le niveau de difficulté et la taille de la grille souhaités avant de rejoindre la page \"Jouer\".<br/>
                                             Si Vous souhaitez lancer une nouvelle partie, choisissez \"Quitter\" dans l'onglet Jouer, avant de revenir ici choisir les nouveaux paramètres.<br/>
                                             Il est possible d'obtenir un lien de sauvegarde via l'onglet \"Sauvegarder\". "))# renderUI(HTML(paste(description_aventure(), collapse="<br/>")))


  ## CREATION PARTIE ----

  ## Select difficulté ----
  output$select_difficulte <- renderUI({ # Choisissez un niveau de difficulté
    radioButtons('select_difficulte', '', choiceNames=c("Facile", "Difficile"), choiceValues=c("facile", "difficile"), selected = character(0))
  })

  ## Select taille ----
  output$select_taille <- renderUI({ # Choisissez une taille de grille
    radioButtons('select_taille', '', choiceNames=c("5x5", "10x10"), choiceValues=c("5x5", "10x10"), selected = character(0))
  })

  ###Choix de la grille en fonction des options ----
  # observeEvent(input$submit , {
  #   }
  # })

  ### Création grille ----
  output$matrice_boutons <- renderUI({
    nRows <- 5    # Définir le nombre de lignes
    nCols <- 5    # Définir le nombre de colonnes
    # Créer une matrice de boutons
    boutons <- lapply(1:(nRows * nCols), function(i) {
      actionButton(inputId = paste0("bouton", i), label = "")
    })
    # Organiser les boutons en grille
    tagList(div(class = "btn-grid",
                lapply(split(boutons, ceiling(seq_along(boutons) / nCols)), div, class = "button-row")))
  })

  ### Création indications verticales ----
  output$matrice_ind_vert <- renderUI({
    nRows <- dim(ind_vert)[1]    # Définir le nombre de lignes
    nCols <- dim(ind_vert)[2]    # Définir le nombre de colonnes
    # Créer une matrice de boutons
    boutons <- lapply(1:(nRows * nCols), function(i) {
      actionButton(inputId = paste0("ind_vert", i), label = HTML(paste0("<b>",t(ind_vert)[i], "</b>")), style="background-color: #fff; border-color: #2e6da4") #color: #337ab7;
    })
    # Organiser les boutons en grille
    tagList(div(class = "btn-grid",
                lapply(split(boutons, ceiling(seq_along(boutons) / nCols)), div, class = "button-row")))
  })

  ### Création indications horizontales ----
  output$matrice_ind_hor <- renderUI({
    nRows <- dim(ind_hor)[1]    # Définir le nombre de lignes
    nCols <- dim(ind_hor)[2]    # Définir le nombre de colonnes
    # Créer une matrice de boutons
    boutons <- lapply(1:(nRows * nCols), function(i) {
      actionButton(inputId = paste0("ind_hor", i), label = HTML(paste0("<b>",t(ind_hor)[i], "</b>")), style="background-color: #fff; border-color: #2e6da4") #color: #337ab7;
    })
    # Organiser les boutons en grille
    tagList(div(class = "btn-grid",
                lapply(split(boutons, ceiling(seq_along(boutons) / nCols)), div, class = "button-row")))
  })


  boutons <- reactiveVal()
  boutons(rep(0,5*5))

  lapply(
    X = 1:25,
    FUN = function(i){
      observeEvent(input[[paste0("bouton", i)]], {
        boutons_tempo = boutons()

        if (boutons_tempo[i] == 0){
          boutons_tempo[i]=1
          runjs(paste0('document.getElementById("bouton', i, '").style.backgroundColor = "black";'))
        }
        else if (boutons_tempo[i] == 1){
          boutons_tempo[i]=2
          runjs(paste0('document.getElementById("bouton', i, '").style.backgroundColor = "#d0d1d2";'))
        }
        else{
          boutons_tempo[i]=0
          runjs(paste0('document.getElementById("bouton', i, '").style.backgroundColor = "#f3969a";'))
        }

        boutons(boutons_tempo)

      })
    }
  )


  #Vérifier

  # Comparer   unname(unlist(p5X5)) et boutons()


  ## Afficher solution ----
  # observeEvent(input$verifier , {
  #
  #   shinyjs::show(id = "")
  # })







  ## Activation submit --------------------

  observe({
    if (is.null(input$select_difficulte) | is.null(input$select_taille)){
      shinyjs::disable("submit")
    } else{
      shinyjs::enable("submit")
    }

  })


}
