rm(list=ls())

library(data.table) 
library(jtools) 
library(ggplot2)
library(texreg)
library(fixest)
library(xtable)


# Import data ------------------------------------------------------------------

setwd("PATH")

data <- read.csv("complete-final.csv", sep=",")

# Remove data with polarisation set to 1
# data <- subset(data,polarisation!=1)

# Transform variables ----------------------------------------------------------

data$lnpopdensity <- log(data$popdensity)
data$deprivation <- data$deprivation - 1
data$polarisation <- data$polarisation - mean(data$polarisation)

# Regressions ------------------------------------------------------------------

library(plm)
lmpol <- plm(polarisation ~ deprivation + forbornpct + lnpopdensity + cabmins + election + govshare + I(govshare^2), 
             index=c("region", "year"), model="within", effect="twoways", data = data, weights=data$popshare)

# Results ----------------------------------------------------------------------

library(stargazer)

stargazer(lmpol,type = "text")

# Diagnostics ------------------------------------------------------------------

# Heterskedasticity
# lmtest::bptest(lmpol)


# Correlation
# library(Hmisc)
# library(corrplot)
# library(dplyr)
# 
# datanum <- data.frame(data$polarisation, data$deprivation, data$lnpopdensity, data$forbornpct, data$cabmins, data$election, data$govshare)
# 
# datanum <- datanum %>%
#   rename(
#     polarisation = data.polarisation,
#     deprivation = data.deprivation,
#     lnpopdensity = data.lnpopdensity,
#     forbornpct = data.forbornpct,
#     cabmins = data.cabmins,
#     election = data.election,
#     govshare = data.govshare
#   )
# 
# datacor <- cor(as.matrix(datanum))
# 
# corrplot(datacor, tl.col = 'black')
# 
# stargazer(datacor, title="Correlation Matrix", type = "latex")

# Graphs -----------------------------------------------------------------------

# Effect of gov party share on polarisation
# f <- function(x){
#     return ( -0.380*x + 0.412*x^2 )
# }
# 
# fplot <- ggplot() + geom_function(fun=f) +
#           theme_bw() + xlab("govshare") + ylab("\U0394 polarisation") +
#           ggtitle("Governing-party effect on polarisation") +
#           theme(plot.title = element_text(hjust = 0.5))
# 
# fplot
