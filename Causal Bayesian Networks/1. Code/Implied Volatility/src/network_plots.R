#Function to export a plotted network to PDF with similar style to Latex
bn_plot <- function(bn, mainname, filename, subname) {
  cairo_pdf(file = filename)
  par(pty = "s",
      family = "Optima",
      font = 1)
  submain <-paste0("\n","\n", "  ",subname)
  graphviz.plot(bn, layout = "dot", main = submain)
  par(pty = "s",
      family = "Optima",
      font = 2)
  mainname <-paste0(mainname, "    "," \n")
  title(main = mainname)
  dev.off()
}

#Iteration through all networks
network_plots <- function(permutation.list) {
  for (j in permutation.list) {
    mainname <- paste0(j)
    fitted <- get(paste0("fitted.", gsub("[[:space:]]", "", mainname)))
    filename <- paste0("Exports/Networks/", mainname, ".pdf")
    bn_plot(fitted, mainname, filename, "")
  }
} 