library(ggplot2)

setwd("PATH")

data <- read.csv("complete-final.csv", sep=",")

p <- ggplot(data, aes(x=deprivation)) + 
  geom_density()
p

p+ geom_vline(aes(xintercept=1),
              color="black", linetype="dashed", size=1) +
  theme_bw()
