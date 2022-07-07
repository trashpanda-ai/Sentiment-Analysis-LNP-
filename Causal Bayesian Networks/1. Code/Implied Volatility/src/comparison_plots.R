# function to visually compare the networks
comparison_plots <- function(AUROC) {
  n <- 3
  z <- 0
  ## Top 3 Networks to compare
  for (i in AUROC[1:n, "Algorithm"]) {
    z <- z + 1
    assign(paste0("res.", z), bn.net(get(paste0(
      "fitted.", gsub("[[:space:]]", "", i)
    ))))
  }
  
  ## compare 1 and 2 / 1 and 3 / 2 and 3 with dedicated main title
  
  for (i in AUROC[1, "Algorithm"]) {
    filename <- paste0("Exports/Networks/Comparison1.pdf")
    cairo_pdf(file = filename)
    par(pty = "s",
        family = "Optima",
        font = 1)
    out <-
      paste0("«", AUROC[1, "Algorithm"], "»", " compared to «", AUROC[2, "Algorithm"], "»")
    graphviz.compare(res.1, res.2, layout = "dot", main = c("\n", "\n"))
    par(pty = "s",
        family = "Optima",
        font = 2)
    title(main = out)
    dev.off()
  }
  
  for (i in AUROC[1, "Algorithm"]) {
    filename <- paste0("Exports/Networks/Comparison2.pdf")
    cairo_pdf(file = filename)
    par(pty = "s",
        family = "Optima",
        font = 1)
    out <-
      paste0("«", AUROC[1, "Algorithm"], "»", " compared to «", AUROC[3, "Algorithm"], "»")
    graphviz.compare(res.1, res.3, layout = "dot", main = c("\n", "\n"))
    par(pty = "s",
        family = "Optima",
        font = 2)
    title(main = out)
    dev.off()
  }
  
  for (i in AUROC[1, "Algorithm"]) {
    filename <- paste0("Exports/Networks/Comparison3.pdf")
    cairo_pdf(file = filename)
    par(pty = "s",
        family = "Optima",
        font = 1)
    out <-
      paste0("«", AUROC[2, "Algorithm"], "»", " compared to «", AUROC[3, "Algorithm"], "»")
    graphviz.compare(res.2, res.3, layout = "dot", main = c("\n", "\n"))
    par(pty = "s",
        family = "Optima",
        font = 2)
    title(main = out)
    dev.off()
  }
  # final plot is an overlap of the top 3 networks
  for (i in AUROC[1, "Algorithm"]) {
    filename <- paste0("Exports/Networks/Comparison4.pdf")
    cairo_pdf(file = filename)
    par(pty = "s",
        family = "Optima",
        font = 1)
    e1 = empty.graph(colnames(complete.data))
    e = empty.graph(colnames(complete.data))
    arcs(e1) = compare(res.1, res.2, arcs = TRUE)$tp
    arcs(e) = compare(e1, res.3, arcs = TRUE)$tp
    graphviz.plot(e, layout = "dot", main = "\n")
    par(pty = "s",
        family = "Optima",
        font = 2)
    title(main = "Mutual Arcs of these networks")
    dev.off()
  }
}