### Tests are split in colliders and orientations ###
causal_test <- function(AUROC, i, n) {
  x <- 0
  for (j in AUROC[i:n, 1]) {
    x <- x + 1
    out <- paste0(j)
    fitted <-
      get(paste0("fitted.", gsub("[[:space:]]", "", out)))
    bn <- bn.net(fitted)
    #compare the unshielded colliders of the Bayesian network with the resulting causal plots
    expression <-
      unshielded.colliders(bn, arcs = FALSE, debug = FALSE)
    return(expression)
  }
}

# orientation rules are the same as the inductive causation algorithm without the colliders
orientation_rules <- function(my_bn) {
  bn <- my_bn
  r <-""
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
          if (r == ""){
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

## Test cases to be applied in main class ##

# r1 = model2network("[a][b][n|a:b]")
# r1 <- set.edge(r1, "n", "b")
# 
# r2 = model2network("[a|n][b|a:n][n]")
# r2 <- set.edge(r2, "n", "b")
# 
# r3 = model2network("[a|n][b|a:c:n][c|n][n]")
# r3 <- set.edge(r3, "n", "a")
# r3 <- set.edge(r3, "n", "b")
# r3 <- set.edge(r3, "n", "c")
# 
# r4 = model2network("[a|n][b|a:n][c|b:n][n]")
# r4 <- set.edge(r4, "n", "a")
# r4 <- set.edge(r4, "n", "b")
# r4 <- set.edge(r4, "n", "c")
# 
# 
# #repeat for r1 to r4
# graphviz.plot(r1, layout = "dot")
# test <- orientation_rules(r1)
# graphviz.plot(test, layout = "dot")