#' lancement du jeu de Picross
#'
#' @param ui ui
#' @param server server
#'
#' @return lance la grille de picross avec solution
#' @export
#'
#' @examples exemple
lauch_picross <- function(ui, server) {
  shiny::shinyApp(ui = app_ui(), server = app_server)
  #shinyApp(app_ui, app_server)
}

