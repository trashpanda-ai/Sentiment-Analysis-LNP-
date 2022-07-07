#Inductive causation based on Pearl and Meek
inductive_causation <- function(my_bn) {
  #Start with skeleton of BN -- our PDAG
  bn <- skeleton(bn.net(my_bn))
  #underlying network of the Bayesian network for the unshielded colliders
  my_bn <- bn.net(my_bn)
  #local variables to indicate whether something changed and thus a new plot needs to be generated
  r <- ""
  co <- FALSE
  # for nodes n in PDAG
  for (n in nodes(bn)) {
    # if neighbours(n) > 1
    if (length(nbr(bn, n)) > 1) {
      #list of neighbors
      x <- nbr(bn, n)
      #permutation of all neighbors of length 2
      perm.list <- permutations(length(x), 2, x, repeats = FALSE)
      #iterate through all permutations a, b
      for (z in 1:(length(perm.list) / 2)) {
        a <- perm.list[z, 1]
        b <- perm.list[z, 2]
        # if no edge/arc between a and b && only edge between n-a and n-b
        # the approach doesnt seem intuitive, but there is no faster way to check for arcs than dropping or adding those in a copy of the network and then compare them
        updated <- drop.edge(bn, a, b, )
        updated <- drop.arc(updated, a, b)
        updated <- set.edge(updated, a, n)
        updated <- set.edge(updated, b, n)
        res <- paste0(all.equal(updated, bn))
        check <- "TRUE"
        # and only if old bn has these orientations
        updated_bn <- set.arc(my_bn, a, n, check.cycles = FALSE)
        updated_bn <-
          set.arc(updated_bn, b, n, check.cycles = FALSE)
        res_bn <- paste0(all.equal(updated_bn, my_bn))
        if ((check == res) & (check == res_bn)) {
          # if no edge/arc between a and b && only edge between n-a and n-b
          res1 <-
            try(set.arc(bn, a, n, check.cycles = TRUE), silent = TRUE)
          res2 <-
            try(set.arc(bn, b, n, check.cycles = TRUE), silent = TRUE)
          #try blocks to make sure our PDAG remains acyclical
          if (!(class(res1) == "try-error") &
              !(class(res2) == "try-error")) {
            bn <- set.arc(bn, a, n)
            bn <- set.arc(bn, b, n)
            # collider has been added and thus we can plot the change
            co <- TRUE
          }
        }
        if (co == TRUE) {
          # Only for visualisations
          out <- paste0("Colliders - ", n, " - ", a, " - ", b)
          filename <-
            paste0("Exports/Networks/Causal/Iteration/", out, ".pdf")
          bn_plot(bn, out, filename, "")
          # so we can set the variable "co" to FALSE again
          co <- FALSE
        }
      }
    }
    
  }
  
  new_arcs <- TRUE
  i <- 0
  # while loop: only if no more arcs can be oriented, the loop terminates
  while (new_arcs == TRUE) {
    i <- i + 1
    new_arcs <- FALSE
    for (n in nodes(bn)) {
      # if length(nbr(n))>1:
      if (length(nbr(bn, n)) > 1) {
        x <- nbr(bn, n)
        perm.list <- permutations(length(x), 2, x, repeats = FALSE)
        #for all permutations (a, b) of nbr(n) with l=2
        for (z in 1:(length(perm.list) / 2)) {
          a <- perm.list[z, 1]
          b <- perm.list[z, 2]
          updated <- drop.edge(bn, a, b)
          updated <- drop.arc(updated, a, b)
          # if no edge/arc between a,b then
          res <- paste0(all.equal(updated, bn))
          check <- "TRUE"
          # the approach doesnt seem intuitive, but there is no faster way to check for arcs than dropping or adding those in a copy of the network and then compare them
          if ((check == res)) {
            updated <- drop.edge(bn, n, b)
            # if not (b->n or n->b), so if edge not arc
            res <- paste0(all.equal(updated, bn))
            if (!(check == res)) {
              updated <- set.arc(bn, a, n, check.cycles = FALSE)
              # if a->n R1
              res <- paste0(all.equal(updated, bn))
              if ((check == res)) {
                # try n -> b and new_arcs = TRUE || R1
                res <-
                  try(set.arc(bn, n, b, check.cycles = TRUE), silent = TRUE)
                #try blocks to make sure our PDAG remains acyclical
                if (!(class(res) == "try-error")) {
                  bn <- set.arc(bn, n, b)
                  new_arcs <- TRUE
                  #set dedicated rule for the plots
                  r <- " - R1"
                }
              }
            }
          }
          # to make sure only one change per iteration happens for better visualisations
          if (r == "") {
            updated <- drop.edge(bn, n, b)
            # if not (b->n or n->b), so if edge not arc
            res <- paste0(all.equal(updated, bn))
            if ((!(check == res))) {
              # if b in descendants(bn, "n")  R2
              des <- paste0(is.element(b, descendants(bn, n)))
              if ((check == des)) {
                # try n -> b and new_arcs = TRUE || R2
                res <-
                  try(set.arc(bn, n, b, check.cycles = TRUE), silent = TRUE)
                #try blocks to make sure our PDAG remains acyclical
                if (!(class(res) == "try-error")) {
                  bn <- set.arc(bn, n, b)
                  new_arcs <- TRUE
                  #set dedicated rule for the plots
                  r <- " - R2"
                }
              }
            }
          }
        }
      }
      #rules 3 and 4 only for 3 nodes or more
      if (length(nbr(bn, n)) > 2) {
        x <- nbr(bn, n)
        perm.list <- permutations(length(x), 3, x, repeats = FALSE)
        #for all permutations (a, b) of nbr(n) with l=2
        for (z in 1:(length(perm.list) / 3)) {
          a <- perm.list[z, 1]
          b <- perm.list[z, 2]
          c <- perm.list[z, 3]
          # if a -> b and c -> b and n - b for r3
          # if a -> b and b -> c and n - c for r4
          # check for common rules
          updated1 <- drop.edge(bn, n, a)
          updated2 <- drop.edge(bn, n, b)
          updated3 <- drop.edge(bn, n, c)
          updated <- set.arc(bn, a, b, check.cycles = FALSE)
          res1 <- paste0(all.equal(updated1, bn))
          res2 <- paste0(all.equal(updated2, bn))
          res3 <- paste0(all.equal(updated3, bn))
          res <- paste0(all.equal(updated, bn))
          check <- "TRUE"
          if ((!((check == res1) |
                 (check == res2) |
                 (check == res3))) & (check == res)) {
            # if c->b then n->b
            updated <- set.arc(bn, c, b, check.cycles = FALSE)
            res <- paste0(all.equal(updated, bn))
            if ((check == res)) {
              res <- try(set.arc(bn, n, b, check.cycles = TRUE), silent = TRUE)
              #try blocks to make sure our PDAG remains acyclical
              if (!(class(res) == "try-error")) {
                bn <- set.arc(bn, n, b)
                new_arcs <- TRUE
                #set dedicated rule for the plots
                r <- " - R3"
              }
            }
            #if b->c then n->c
            updated <- set.arc(bn, b, c, check.cycles = FALSE)
            res <- paste0(all.equal(updated, bn))
            if ((check == res)) {
              res <- try(set.arc(bn, n, c, check.cycles = TRUE), silent = TRUE)
              #try blocks to make sure our PDAG remains acyclical
              if (!(class(res) == "try-error")) {
                bn <- set.arc(bn, n, c)
                new_arcs <- TRUE
                #set dedicated rule for the plots
                r <- " - R4"
              }
            }
          }
        }
      }
      if (!(r == "")) {
        # Only for visualisations while iterating
        out <- paste0("Orientation - ", n, r, " - ", i)
        filename <-
          paste0("Exports/Networks/Causal/Iteration/", out, ".pdf")
        bn_plot(bn, out, filename, "")
        #set dedicated rule back to empty
        r <- ""
      }
    }
    
    
  }
  
  return(bn)
}

#Final export of plots with indicator of how many arcs can be oriented in the subtitle
causal_plots <- function(AUROC, n) {
  x <- 0
  for (j in AUROC[1:n, 1]) {
    x <- x + 1
    out <- paste0(j)
    fitted <-
      get(paste0("fitted.", gsub("[[:space:]]", "", out)))
    bn <- inductive_causation(fitted)
    undirected <- as.numeric(length((undirected.arcs(bn))) / 4)
    directed <- as.numeric(length((directed.arcs(bn))) / 2)
    total <- undirected + directed
    result <- round(((directed / total) * 100), digits = 0)
    # directed of total edges are oriented (result %)
    out <- paste0("Causal Network from ", out)
    filename <- paste0("Exports/Networks/Causal/Causal", x, ".pdf")
    submain <-
      paste0(directed, " of ", total, " edges are oriented (", result, "%)")
    bn_plot(bn, out, filename, submain)
  }
}