# ROC plots
roc_plots <- function(complete.testing_data) {
  # progress bar as the function takes some time
  p <- 0
  pb <- txtProgressBar(min = 0, 
                       max = ncol(complete.testing_data), 
                       style = 3,    
                       width = 50,   
                       char = "=")   
  for(i in 1:ncol(complete.testing_data)) {
    #iterate through the columns -- here countries
    AUROC.list <- list()
    filename <-
      paste0("Exports/ROC/", colnames(complete.testing_data[i]), ".pdf")
    cairo_pdf(file = filename)
    par(pty = "s", family = "Optima")
    #start plot with style, axis and titles
    plot(
      NA,
      main = colnames(complete.testing_data[i]),
      ylim = c(0, 1),
      xlim = c(1, 0),
      xlab = "Specificity",
      ylab = "Sensitivity",
      family = "Optima"
    )
    #color palatte and legend
    mypal <- viridis(length(unlist(permutation.list)))
    legend(
      "bottomright",
      legend = unlist(permutation.list),
      col = mypal,
      bty = "n",
      lty = 1,
      cex = 0.63
    )
    z <- 0
    #iterate through our models and plot the curve for each
    for (j in permutation.list) {
      z <- z + 1
      out <- paste0(j)
      fitted <- get(paste0("fitted.", gsub("[[:space:]]", "", out)))
      #make prediction with model
      prediction <-
        predict(
          fitted,
          colnames(complete.testing_data[i]),
          complete.testing_data,
          #bayesian prediction with all the available nodes 
          method = "bayes-lw",
          prob = TRUE
        )
      #assign the probs
      prediction.attributes <- attributes(prediction)$prob[1, ]
      #plot the roc curve
      roc.curve <-
        roc(
          response = complete.testing_data[[i]],
          predictor = prediction.attributes,
          levels = c(-1, 1),
          direction = ">"
        )
      par(pty = "s", family = "Optima")
      lines(
        main = colnames(complete.testing_data[i]),
        roc.curve,
        xlim = c(1, 0),
        ylim = c(0, 1),
        col = mypal[z],
        lwd = 0.8
      )
      #AUROC value
      app <- auc(roc.curve)
      ## save AUROC in list
      AUROC.list <- append(AUROC.list, app)
      
    }
    ## save AUROC in column of country and add new row for each model
    new.data.frame <-
      data.frame(as.data.frame(do.call(rbind, AUROC.list)))
    colnames(new.data.frame) <- colnames(complete.testing_data[i])
    AUROC <<- cbind(AUROC, new.data.frame)
    
    ## Finish PDF
    dev.off()
    p <- p+1
    setTxtProgressBar(pb, p)
  }
  #close progress bar
  close(pb)
}