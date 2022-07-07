# Build all models through averaging $n$ bootstrapped models and only accepting those arc with significance threshold above $threshold$
build_models <-
  function(incomplete.training_data,
           complete.training_data,
           n,
           threshold,
           score.algorithms,
           scores,
           hybrid.algorithms) {
    
    #empty list to save all possible permutations
    permutation.list <<- list()
    #Progressbar as this function takes significant time
    p <- 0
    t <- 
    pb <- txtProgressBar(min = 0,      
                         max = length(score.algorithms)*length(scores)+length(hybrid.algorithms)+length(score.algorithms), 
                         style = 3,    
                         width = 50,   
                         char = "=")   
    i <- 0
    for (a in score.algorithms) {
      i <- i + 1
      #iterate through all algorithms and scores 
      for (s in scores) {
        #pred log like score on separated test set, so it needs a separated case
        if (s == "Pred-Loglik") {
          ll1 <-
            sample(1:nrow(complete.training_data),
                   nrow(complete.training_data) / 3)
          ll2 <- -ll1
          ll1_data <-
            as.data.frame(lapply(complete.training_data[ll1, ], as.factor))
          ll2_data <-
            as.data.frame(lapply(complete.training_data[ll2, ], as.factor))
          #new test train split
          out <- paste0(score.algorithms.names[i], " – ", s)
          #name of plot
          permutation.list <<- append(permutation.list, out)
          #permutation list
          #boot strap approach 
          res.boot.strength = boot.strength(
            ll1_data,
            R = n,
            algorithm = tolower(a),
            algorithm.args = list(
              score = tolower(s),
              newdata = ll2_data,
              optimized = TRUE
              #optimized for faster results (reuse sampled scores)
            ),
            cpdag = FALSE
            # we do not care about the equivalence class YET. Thus we want a bayesian network
          )
          #averaged network from bootstrapped approach
          res <-
            averaged.network(res.boot.strength, threshold = threshold)
          arcs(res) <- directed.arcs(res) 
          #assign arc strength and network
          assign(paste0("fitted.", gsub("[[:space:]]", "", out)),
                 bn.fit(res, ll1_data),
                 envir = parent.frame())
          assign(
            paste0("arcstr.", gsub("[[:space:]]", "", out)),
            arc.strength(res, ll1_data, criterion = "bic"),
            envir = parent.frame()
          )
          p <- p+1
          setTxtProgressBar(pb, p)
          
        }
        
        else{
          out <- paste0(score.algorithms.names[i], " – ", s)
          permutation.list <<- append(permutation.list, out)
          #permutation list
          #boot strap approach 
          res.boot.strength = boot.strength(
            complete.training_data,
            R = n,
            algorithm = tolower(a),
            algorithm.args = list(score = tolower(s), optimized = TRUE),
            #optimized for faster results (reuse sampled scores)
            cpdag = FALSE
            # we do not care about the equivalence class YET. Thus we want a bayesian network
          )
          #averaged network from bootstrapped approach
          res <-
            averaged.network(res.boot.strength, threshold = threshold)
          #assign arc strength and network
          arcs(res) <- directed.arcs(res) # ignore undirected arcs
          assign(paste0("fitted.", gsub("[[:space:]]", "", out)),
                 bn.fit(res, complete.training_data),
                 envir = parent.frame())
          assign(
            paste0("arcstr.", gsub("[[:space:]]", "", out)),
            arc.strength(res, complete.training_data, criterion = "bic"),
            envir = parent.frame()
          )
          p <- p+1
          setTxtProgressBar(pb, p)
        }
      }
    }
    
    #Hybrid
    i <- 0
    for (a in hybrid.algorithms) {
      i <- i + 1
      out <- paste0(hybrid.algorithms.names[i])
      permutation.list <<- append(permutation.list, out)
      #permutation list
      #boot strap approach 
      res.boot.strength = boot.strength(
        complete.training_data,
        R = n,
        algorithm = tolower(a),
        cpdag = FALSE
        # we do not care about the equivalence class YET. Thus we want a bayesian network
      )
      #averaged network from bootstrapped approach
      res <- averaged.network(res.boot.strength, threshold = threshold)
      arcs(res) <- directed.arcs(res) # ignore undirected arcs
      #assign arc strength and network
      assign(paste0("fitted.", gsub("[[:space:]]", "", out)),
             bn.fit(res, complete.training_data),
             envir = parent.frame())
      assign(paste0("arcstr.", gsub("[[:space:]]", "", out)),
             arc.strength(res, complete.training_data, criterion = "bic"),
             envir = parent.frame())
      p <- p+1
      setTxtProgressBar(pb, p)
    }
    
    #EM
    i <- 0
    for (a in score.algorithms) {
      i <- i + 1
      start = bn.fit(empty.graph(names(incomplete.training_data)), incomplete.training_data)
      out <- paste0("EM – ", score.algorithms.names[i])
      #permutation list
      permutation.list <<- append(permutation.list, out)
      # structural EM
      res <-
        structural.em(incomplete.training_data,
                      maximize = tolower(a),
                      start = start)
      #assign arc strength and network
      assign(paste0("fitted.", gsub("[[:space:]]", "", out)),
             bn.fit(res, incomplete.training_data),
             envir = parent.frame())
      assign(
        paste0("arcstr.", gsub("[[:space:]]", "", out)),
        arc.strength(res, complete.training_data, criterion = "bic"),
        envir = parent.frame()
      )
      p <- p+1
      setTxtProgressBar(pb, p)
    }
    #prepare the dataframe with the permutation list
    df <- data.frame(as.data.frame(do.call(rbind, permutation.list)))
    colnames(df) <- "Algorithm"
    close(pb)
    return(df)
  }
