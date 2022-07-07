#validation of potential scores by k-fold cross validation
validate_scores <-
  function(complete.data,
           k,
           score.algorithms,
           scores,
           hybrid.algorithms) {
    #empty global lists
    name.list <- list()
    loss.list <- list()
    
    #Progress bar as the function takes some time
    p <- 0
    pb <- txtProgressBar(
      min = 0,
      max = length(score.algorithms) * length(scores) +
        length(hybrid.algorithms),
      style = 3,
      width = 50,
      char = "="
    )
    
    #iterate through all algorithms and scores
    n <- 0
    for (a in score.algorithms) {
      n <- n + 1
      for (s in scores) {
        #pred log like score on separated test set, so it needs a separated case
        if (s == "Pred-Loglik") {
          ll1 <-
            sample(1:nrow(complete.data),
                   nrow(complete.data) / 3)
          ll2 <- -ll1
          ll1_data <-
            as.data.frame(lapply(complete.data[ll1,], as.factor))
          ll2_data <-
            as.data.frame(lapply(complete.data[ll2,], as.factor))
          #new test train split
          out <- paste0(score.algorithms.names[n], " – ", s)
          name.list <- append(name.list, out)
          #permutation list
          #k-fold cross validation
          cv.res <-
            bn.cv(
              ll1_data,
              bn = tolower(a),
              loss = "logl",
              fit = "mle",
              runs = k,
              algorithm.args = list(
                score = tolower(s),
                newdata = ll2_data,
                optimized = TRUE
              )
            )
          #save the loss as a list
          Log.Like.Loss <- list(c(loss(cv.res)))
          loss.list <- append(loss.list, Log.Like.Loss)
          p <- p + 1
          setTxtProgressBar(pb, p)
          
        }
        else{
          out <- paste0(score.algorithms.names[n], " – ", s)
          name.list <- append(name.list, out)
          #permutation list
          #k-fold cross validation
          cv.res <-
            bn.cv(
              complete.data,
              bn = tolower(a),
              loss = "logl",
              fit = "mle",
              runs = k,
              algorithm.args = list(score = tolower(s))
            )
          #save the loss as a list
          Log.Like.Loss <- list(c(loss(cv.res)))
          loss.list <- append(loss.list, Log.Like.Loss)
          p <- p + 1
          setTxtProgressBar(pb, p)
          
        }
      }
    }
    
    #Hybrid
    n <- 0
    for (a in hybrid.algorithms) {
      n <- n + 1
      out <- paste0(hybrid.algorithms.names[n])
      name.list <- append(name.list, out)
      #permutation list
      #k-fold cross validation
      cv.res <- bn.cv(
        complete.data,
        bn = tolower(a),
        loss = "logl",
        fit = "mle",
        # "bayes"
        runs = k
      )
      #save the loss as a list
      Log.Like.Loss <- list(c(loss(cv.res)))
      loss.list <- append(loss.list, Log.Like.Loss)
      p <- p + 1
      setTxtProgressBar(pb, p)
      
    }
    #save the lists of loss as dataframe and return
    names <- name.list[seq_len(length(name.list))]
    df <- data.frame(unlist(names), unlist(loss.list))
    names(df) <- c("Algorithm", "Loss")
    close(pb)
    return(df)
  }
