#### Imports ####

#Import libraries for data management and visualization
library(tidyverse)
library(reshape2)
library(scales)
library(viridis)
library(gtools)


#Import libraries for tables
library(kableExtra)


#Import libraries for bayesian networks
library(bnlearn)
library(Rgraphviz)
library(pROC)


#Methods from our pipeline
source("src/validate_scores.R")
source("src/build_models.R")
source("src/network_plots.R")
source("src/roc_plots.R")
source("src/comparison_plots.R")
source("src/inductive_causation.R")
source("src/inductive_causation_test.R")
set.seed(1)

#### Raw Data Import and Management ####

#We import our raw data from investing.com and onvista.de
#Calculated based on 30 day derivatives (near-term and next-term options)

raw.data <- read.csv("data.csv")
dim(raw.data)
head(raw.data, 3)


#For better readability we replace the indices with the names of the dedicated countries:
colnames(raw.data) <-
  c(
    "Date",
    "Australia",
    "Canada",
    "China",
    "France",
    "Germany",
    "Hongkong",
    "India",
    "Japan",
    "Russia",
    "Switzerland",
    "UK",
    "USA"
  )


#The index needs to be of type "Date"
raw.data <- fortify(raw.data)
raw.data$Date <- as.Date(raw.data$Date , format = "%Y-%m-%d")
head(raw.data, 3)


#To plot our volatility prices, we melt the dataframe
df <-
  melt(raw.data,
       "Date",
       variable.name = "Country",
       value.name = "Price")
#good font families to choose: "Optima", "Avenir" or "Baskerville"
ggplot(df, aes(x = Date, y = Price)) + ggtitle("Daily Implied Volatility") + ylab("Value in percent points") +
  geom_line(aes(color = Country), size = 0.2) +
  scale_color_viridis(discrete = TRUE) +
  # use date_breaks 
  scale_x_date(labels = date_format("%Y"), date_breaks = "12 months") +
  # rotate x-axis labels
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + theme_bw() + theme(
    text = element_text(family = "Optima"),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black")
  ) + theme(plot.title = element_text(face = "bold"))
ggsave("Exports/Data/Timeseries1.pdf", device = cairo_pdf)

#Our Timeseries is stationary, but we don't really care about the prices of the Implied Volatility Indices! We care about the *daily changes!* That's why we calculate the daily logarithmic returns. Also:
#$  log(a/b) = log(a)-log(b)$

raw.data  <- raw.data %>% fill(everything(), .direction = 'up')
raw.data  <-
  raw.data[order(as.Date(raw.data$Date , format = "%Y-%m-%d")), ]

log.data <-
  data.frame(cbind.data.frame(raw.data$Date[-1], diff(as.matrix(log(
    raw.data[, -1]
  )))))
colnames(log.data)[1] <- "Date"
log.data[log.data == 0] <- NA
# log returns:
head(log.data, 3)





# Let's plot our daily volatility changes!
df <-
  melt(log.data,
       "Date",
       variable.name = "Country",
       value.name = "Change")
#good font families to choose: "Optima", "Avenir" or "Baskerville"
ggplot(df, aes(x = Date, y = Change * 100)) + ggtitle("Daily Change of Implied Volatility") +  ylab("Change in percent points") +
  geom_line(aes(color = Country), size = 0.2) +
  scale_color_viridis(discrete = TRUE) +
  # use date_breaks 
  scale_x_date(labels = date_format("%Y"), date_breaks = "12 months") +
  # rotate x-axis labels
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + theme_bw() + theme(
    text = element_text(family = "Optima"),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black")
  ) + theme(plot.title = element_text(face = "bold"))
ggsave("Exports/Data/Timeseries2.pdf", device = cairo_pdf)



#But we don't care about the *amount* of change -- we only care *weather* it changes! Therefore we simplify our data frame and discretise it at the same time:
bin.data <- log.data
#negative values are assigned -1
bin.data[bin.data < 0] <- -1
#positive values are assigned 1 and 0s don't exist as there are no precise sideway movements in those large instruments
bin.data[-1][bin.data[-1] > 0] <- 1
head(bin.data, 3)

#Let's have a look at our distribution before we try to work with the data:

ggplot(gather(bin.data[-1], key, value), aes(value, fill = key)) +  ggtitle("Balanced Distribution by Country") +
  geom_histogram(bins = 3) + scale_fill_viridis(discrete = TRUE) +
  facet_wrap( ~ key, scales = 'free_x') + xlab("Value") + ylab("Observations") + theme(
    text = element_text(family = "Optima"),
    legend.position = "none",
    panel.spacing = unit(1.8, "lines"),
    strip.background = element_blank(),
    panel.background = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black")
  ) + theme(plot.title = element_text(face = "bold"))
ggsave("Exports/Data/Distribution.pdf", device = cairo_pdf)

#Let's remove the date index:
incomplete.data <- bin.data[-1]



#Let's define all the algorithms and scores we want to compare
#score-based algorithms, which use goodness-of-fit scores as objective functions to maximise
#hybrid algorithms that combine both score and constraint based approaches
#EM algorithm


# Score based algorithms
score.algorithms <- c("HC", "Tabu")
score.algorithms.names <- c("Hill-Climbing", "Tabu")


# Hybrid  algorithms
hybrid.algorithms <- c("h2pc", "mmhc", "rsmax2")
hybrid.algorithms.names <-
  c("Restricted Maximization",
    "Hybrid HPC",
    "Max-Min Hill-Climbing")


# Different Scores to optimize sorted by category and then alphabetically 
scores <-
  c( "AIC", "BIC" ,"Loglik","Pred-Loglik", "fNML", "qNML", "BDe","BDj","BDLa", "BDs", "mBDe", "K2")


#Let's split the data in **test** and **train** and drop all NA value for the test set, and also for the complete.training_data:


#randomly select rows
test <- sample(1:nrow(incomplete.data), nrow(incomplete.data) / 3)
train <- -test
incomplete.training_data <-
  as.data.frame(lapply(incomplete.data[train, ], as.factor))
incomplete.testing_data <-
  as.data.frame(lapply(incomplete.data[test, ], as.factor))

complete.data <- na.omit(incomplete.data)
complete.data <-
  as.data.frame(lapply(complete.data, as.factor))

complete.training_data <- na.omit(incomplete.training_data)
complete.testing_data <- na.omit(incomplete.testing_data)

# reset of index -- only for aesthetics
row.names(complete.training_data) <- NULL
row.names(complete.testing_data) <- NULL
row.names(incomplete.training_data) <- NULL


#for each model use ALL data to run k-fold validation and get loss, then plot loss descending
k = 10
boxplot <-
  validate_scores(complete.data, k, score.algorithms, scores, hybrid.algorithms)
#ca 10min, but there is a progress bar

#fill and col color to fit our style
#plot of our log likelihood loss per combination
p <- ggplot(boxplot, aes(reorder(Algorithm, Loss, median), Loss, fill = reorder(Algorithm, Loss, median), col = reorder(Algorithm, Loss, median))) +
  ggtitle("Log-Likelihood Loss per Algorithm and Score") +
  geom_boxplot(outlier.shape = NA) +
  scale_color_viridis(discrete=TRUE) +
  scale_fill_viridis(discrete = TRUE) +
  coord_cartesian(ylim = quantile(boxplot$Loss, c(0.15, 0.9))) +
  xlab("Algorithms and Scores") +
  ylab("Log-Likelihood Loss") +
  theme(
    axis.text.x = element_text(angle = 90, vjust=0.5,hjust = 1),
    text = element_text(family = "Optima"),
    legend.position = "none",
    strip.background = element_blank(),
    panel.background = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.title = element_text(face = "bold")
  )
dat <- ggplot_build(p)$data[[1]]
p + geom_segment(data = dat, aes(x = xmin, xend = xmax, y = middle, yend = middle),  color = "white", size=1.5, inherit.aes = F)
ggsave("Exports/Networks/Loss.pdf", device = cairo_pdf)


#Model averaging to receive more reliable structures by calculating confidence
n = 100 # >20 advised by Scutari (package author)
threshold = 0.7 # as advised in cited literature
AUROC <- build_models(incomplete.training_data,
                      complete.training_data,
                      n, threshold, score.algorithms, scores, hybrid.algorithms) 
#ca 25min for 100, but there is a progress bar

# function to generate plots for all models 
network_plots(permutation.list)

# function to conduct predictions and compare to test set 
roc_plots(complete.testing_data)
AUROC["SUM of AUROC"] <- rowSums(AUROC[,-1])
#final table with Area Under ROC curves as indicator for predictability
AUROC <- AUROC[order(-AUROC[["SUM of AUROC"]]), ]


#Now let's compare the 3 best Networks:
comparison_plots(AUROC)


#And for the final output:
row.names(AUROC) <- NULL
Output <- AUROC
kable(AUROC,
      booktabs = T,
      format = "latex",
      digits = 4)
round(colMeans(Output[,-1]), 4)


#for our five best performing models in terms of AUC we plot strength as confidence (delta BIC score)
top.list <- as.list(AUROC[1:5, "Algorithm"])
x <- 0
for (j in top.list) {
  x <- x+1
  out <- paste0(j)
  fitted <-
    get(paste0("fitted.", gsub("[[:space:]]", "", out)))
  filename <- paste0("Exports/Networks/Strength", x, ".pdf")
  cairo_pdf(file = filename)
  par(pty = "s",
      family = "Optima",
      font = 1)
  strength.plot(bn.net(fitted),
                get(paste0("arcstr.", gsub(
                  "[[:space:]]", "", out
                ))),
                layout = "dot",
                main = "\n")
  par(pty = "s",
      family = "Optima",
      font = 2)
  title(main = out)
  dev.off()
}

# new data frame for final AUC
final.AUROC <-
  data.frame(as.data.frame(do.call(rbind, as.list(
    colnames(complete.training_data)
  ))))
colnames(final.AUROC) <- "Country"
# similiar structured approach as above
x <- 0
#| warning: false
for (i in top.list) {
  x <- x + 1
  z <- 0
  final.AUROC.list <- list()
  filename <- paste0("Exports/ROC/ROC", x, ".pdf")
  cairo_pdf(file = filename)
  par(pty = "s", family = "Optima")
  plot(
    NA,
    main = i,
    ylim = c(0, 1),
    xlim = c(1, 0),
    xlab = "Specificity",
    ylab = "Sensitivity",
    family = "Optima"
  )
  mypal <- viridis(ncol(complete.testing_data))
  legend(
    "bottomright",
    legend = unlist(colnames(complete.testing_data)),
    col = mypal,
    bty = "n",
    lty = 1,
    cex = 1
  )
  
  for (j in 1:ncol(complete.testing_data)) {
    z <- z + 1
    out <- paste0(colnames(complete.testing_data[j]))
    fitted <-
      get(paste0("fitted.", gsub("[[:space:]]", "", i)))
    prediction <-
      predict(
        fitted,
        colnames(complete.testing_data[j]),
        complete.testing_data,
        method = "bayes-lw",
        prob = TRUE
      )
    prediction.attributes <- attributes(prediction)$prob[1, ]
    roc.curve <-
      roc(
        response = complete.testing_data[[j]],
        predictor = prediction.attributes,
        levels = c(-1, 1),
        direction = ">"
      )
    par(pty = "s", family = "Optima")
    lines(
      main = colnames(complete.testing_data[j]),
      roc.curve,
      xlim = c(1, 0),
      ylim = c(0, 1),
      col = mypal[z],
      lwd = 0.8
    )
    app <- auc(roc.curve)
    ## save AUROC in column of country and add new row of e.g. "hc-bic" <- "j"+"—"+"k"
    final.AUROC.list <- append(final.AUROC.list, app)
    
  }
  
  new.data.frame <-
    data.frame(as.data.frame(do.call(rbind, final.AUROC.list)))
  colnames(new.data.frame) <- toString(unlist(top.list[x]))
  final.AUROC <- cbind(final.AUROC, new.data.frame)
  
  ## Finish PDF
  dev.off()
}
#output for latex
row.names(final.AUROC) <- NULL
Output <- final.AUROC
kable(final.AUROC,
      booktabs = T,
      format = "latex",
      digits = 6)
round(colSums(Output[,-1]), 6)


# for a more reliable and objective approach we use the top quantile instead of "top 3" or "top 5"
#Calculate where the cutoff for best 20% is (quantile) in terms of AUC
counter <- as.list(unname(quantile(AUROC[["SUM of AUROC"]], probs = seq(0, 1, 1/5))))
#and calculate up to what index this quantile reaches
counter <- nrow(AUROC[AUROC[["SUM of AUROC"]]>counter[5], ])

# run the inductive causation algorithm and plot all causal models with information on oriented arcs in %
causal_plots(AUROC, counter)

# test for unshielded colliders for inductive causation algorithm 
causal_test(AUROC, 1,1)


# tests for orientation rules for inductive causation algorithm
r1 = model2network("[a][b][n|a:b]")
r1 <- set.edge(r1, "n", "b")

r2 = model2network("[a|n][b|a:n][n]")
r2 <- set.edge(r2, "n", "b")

r3 = model2network("[a|n][b|a:c:n][c|n][n]")
r3 <- set.edge(r3, "n", "a")
r3 <- set.edge(r3, "n", "b")
r3 <- set.edge(r3, "n", "c")

r4 = model2network("[a|n][b|a:n][c|b:n][n]")
r4 <- set.edge(r4, "n", "a")
r4 <- set.edge(r4, "n", "b")
r4 <- set.edge(r4, "n", "c")


#repeat for r1 to r4
r <- r4
graphviz.plot(r, layout = "dot")
test <- orientation_rules(r)
graphviz.plot(test, layout = "dot")


#as russia seems to be completely random and have no major position within our graphs, now we can drop russia as a node and repeat some of our approach manually

incomplete.training_data$Russia <- NULL
complete.training_data$Russia <- NULL
complete.testing_data$Russia <- NULL


#only qnml provides both good distribution and orientation
res.boot.strength = boot.strength(
  complete.training_data,
  R = n,
  algorithm = "hc",
  algorithm.args = list(score = "qnml", optimized = TRUE),
  cpdag = FALSE
)
res <-
  averaged.network(res.boot.strength, threshold = 0.7)
arcs(res) <- directed.arcs(res) # ignore undirected arcs

`final.arcstr.Hill-Climbing–qNML` <- arc.strength(res, complete.training_data, criterion = "bic")
`final.fitted.Hill-Climbing–qNML` <- bn.fit(res, complete.training_data, criterion = "bic")
#x^2 arctrength for pvalues do not give much information

#again as averaged boot strap approach
res.boot.strength = boot.strength(
  complete.training_data,
  R = n,
  algorithm = "tabu",
  algorithm.args = list(score = "qnml", optimized = TRUE),
  cpdag = FALSE
)
res <-
  averaged.network(res.boot.strength, threshold = 0.7)
arcs(res) <- directed.arcs(res) # ignore undirected arcs

`final.arcstr.Tabu–qNML` <- arc.strength(res, complete.training_data, criterion = "bic")
`final.fitted.Tabu–qNML` <- bn.fit(res, complete.training_data, criterion = "bic")
#x^2 arctrength for pvalues do not give much information


top.list <- as.list(AUROC[3:4, "Algorithm"])
for (j in top.list) {
  out <- paste0(j)
  fitted <-
    get(paste0("final.fitted.", gsub("[[:space:]]", "", out)))
  filename <- paste0("Exports/Networks/", out, " final.pdf")
  cairo_pdf(file = filename)
  par(pty = "s",
      family = "Optima",
      font = 1)
  strength.plot(bn.net(fitted),
                get(paste0("final.arcstr.", gsub(
                  "[[:space:]]", "", out
                ))),
                layout = "dot",
                main = "\n")
  par(pty = "s",
      family = "Optima",
      font = 2)
  title(main = out)
  dev.off()
}


final.AUROC <-
  data.frame(as.data.frame(do.call(rbind, as.list(
    colnames(complete.training_data)
  ))))
colnames(final.AUROC) <- "Country"

#and including the dedicated ROC plots of the models per country
x <- 0
#| warning: false
for (i in top.list) {
  x <- x + 1
  z <- 0
  final.AUROC.list <- list()
  filename <- paste0("Exports/ROC/ROC_Final", x, ".pdf")
  cairo_pdf(file = filename)
  par(pty = "s", family = "Optima")
  plot(
    NA,
    main = i,
    ylim = c(0, 1),
    xlim = c(1, 0),
    xlab = "Specificity",
    ylab = "Sensitivity",
    family = "Optima"
  )
  mypal <- viridis(ncol(complete.testing_data))
  legend(
    "bottomright",
    legend = unlist(colnames(complete.testing_data)),
    col = mypal,
    bty = "n",
    lty = 1,
    cex = 1
  )
  
  for (j in 1:ncol(complete.testing_data)) {
    z <- z + 1
    out <- paste0(colnames(complete.testing_data[j]))
    fitted <-
      get(paste0("final.fitted.", gsub("[[:space:]]", "", i)))
    prediction <-
      predict(
        fitted,
        colnames(complete.testing_data[j]),
        complete.testing_data,
        method = "bayes-lw",
        prob = TRUE
      )
    prediction.attributes <- attributes(prediction)$prob[1, ]
    roc.curve <-
      roc(
        response = complete.testing_data[[j]],
        predictor = prediction.attributes,
        levels = c(-1, 1),
        direction = ">"
      )
    par(pty = "s", family = "Optima")
    lines(
      main = colnames(complete.testing_data[j]),
      roc.curve,
      xlim = c(1, 0),
      ylim = c(0, 1),
      col = mypal[z],
      lwd = 0.8
    )
    app <- auc(roc.curve)
    ## save AUROC in column of country and add new row of e.g. "hc-bic" <- "j"+"—"+"k"
    final.AUROC.list <- append(final.AUROC.list, app)
    
  }
  
  new.data.frame <-
    data.frame(as.data.frame(do.call(rbind, final.AUROC.list)))
  colnames(new.data.frame) <- toString(unlist(top.list[x]))
  final.AUROC <- cbind(final.AUROC, new.data.frame)
  
  ## Finish PDF
  dev.off()
}


# final run of the inductive causation algorithm
res.1 <- inductive_causation(`final.fitted.Hill-Climbing–qNML`)
res.2 <- inductive_causation(`final.fitted.Tabu–qNML`)

for (i in AUROC[1, "Algorithm"]) {
  filename <- paste0("Exports/Networks/Causal/Final Causal.pdf")
  cairo_pdf(file = filename)
  par(pty = "s",
      family = "Optima",
      font = 1)
  out <-
    paste0("«Causal ", AUROC[3, "Algorithm"], "»", " compared to «Causal ", AUROC[4, "Algorithm"], "»")
  graphviz.compare(res.1, res.2, layout = "dot", main = c("\n", "\n") )
  par(pty = "s",
      family = "Optima",
      font = 2)
  title(main = out)
  dev.off()
}



### Additional Exports for the thesis ###
# Export to txt to later summarize the conditional probability tables
for (i in AUROC[1:5, "Algorithm"]) {
  filename <- paste0("Exports/Networks/", i, " .txt")
  sink(file = filename)
  print(get(paste0("fitted.", gsub(
    "[[:space:]]", "", i
  ))))
  sink(file = NULL)
}

# Conditional Probabilities by Query Sampling - 100000 observations for each of the 25 individual samples (executions) 
df <-
  data.frame(
    event = c(
      '(Germany=="1")',
      '(Switzerland=="1")',
      '(UK=="-1")',
      '(Hongkong=="1")',
      '(China=="1")',
      '(USA=="1")'
    ),
    evidence = c(
      '(France=="1")',
      '(France=="1" & Germany=="1")',
      '(France=="-1" & Germany=="-1" & Switzerland=="-1")',
      '(China=="1" & Switzerland=="1")',
      '(USA=="1" & Switzerland=="1")',
      '(China=="1" & Germany=="1")'
    )
  )
# loop through all rows of our df with events and evidence and sample each the original and the learned BN for best comparison
for (i in 1:nrow(df)) {
  # use text for the function cpquery, as it has some bugs
  
  # EM Hill Climbing
  pastetext = paste("cpquery(`fitted.EM–Hill-Climbing`, ",
                    df$event[i],
                    ", ",
                    df$evidence[i],
                    ",n=100000",
                    ")")
  # Average the result of 100.000 observations with 25 executions to gather a stable final result
  my.sum = 0
  reps = 25
  
  for (j in 1:reps) {
    current = eval(parse(text = pastetext))
    my.sum = my.sum + current
  }
  # new column for results
  df$hc[i] = my.sum / reps
  
  # EM Tabu
  pastetext = paste("cpquery(`fitted.EM–Tabu`, ",
                    df$event[i],
                    ", ",
                    df$evidence[i],
                    ",n=100000",
                    ")")
  my.sum = 0
  
  for (j in 1:reps) {
    current = eval(parse(text = pastetext))
    my.sum = my.sum + current
  }
  # new column for results
  df$tabu[i] = my.sum / reps
  
  # Hillclimbing qnml
  pastetext = paste("cpquery(`fitted.Hill-Climbing–qNML`, ",
                    df$event[i],
                    ", ",
                    df$evidence[i],
                    ",n=100000",
                    ")")
  my.sum = 0
  
  for (j in 1:reps) {
    current = eval(parse(text = pastetext))
    my.sum = my.sum + current
  }
  # new column for results
  df$qnml[i] = my.sum / reps
  
}

# Export to latex
kable(df,
      digits = 3,
      booktabs = T,
      format = "latex")

