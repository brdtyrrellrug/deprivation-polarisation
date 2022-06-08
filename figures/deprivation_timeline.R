rm(list=ls())

library(matrixStats)
library(ggplot2)
library(dplyr)
library(reldist)
library(grid)
library(gridExtra)

##### Normal ===================================================================

# Import data

setwd("PATH")

depdata <- read.csv(".\\Deprivation_Constituencys\\deprivation2yr.csv", sep=",")
depdata = subset(depdata, select = -c(constituency) )

popdata <- read.csv(".\\Controls\\pop\\popshare2yr.csv", sep=",")
popdata = subset(popdata, select = -c(region) )

data <- read.csv("complete-final.csv")


# Split data

depmax <- colMaxs(as.matrix(depdata[sapply(depdata, is.numeric)]))
depmin <- colMins(as.matrix(depdata[sapply(depdata, is.numeric)]))
depmed <- colMedians(as.matrix(depdata[sapply(depdata, is.numeric)]))
depmean <- colMeans(as.matrix(depdata[sapply(depdata, is.numeric)]))

# Quartiles
depq1 <- data %>%
  group_by(yearstart) %>% 
  summarise(quantile(deprivation, probs = c(0.25)))

depq1 <- depq1$`quantile(deprivation, probs = c(0.25))`
depq3 <- data %>%
  group_by(yearstart) %>% 
  summarise(quantile(deprivation, probs = c(0.75)))
depq3 <- depq3$`quantile(deprivation, probs = c(0.75))`


year <- seq(as.Date("2005-01-01"), as.Date("2018-01-01"), "2 years")

depdf <- data.frame(year, depmax, depmed, depmin, depq1, depq3, depmean)


# Plot

deplot <- ggplot() +
  geom_ribbon(data=depdf, aes(year, ymin=depmin,ymax=depq1), fill="#edf8b1", 
              alpha=0.5) +
  geom_ribbon(data=depdf, aes(year, ymin=depq1,ymax=depmed), fill="#7fcdbb", 
              alpha=0.5) +
  geom_ribbon(data=depdf, aes(year, ymin=depmed,ymax=depq3), fill="#1d91c0", 
              alpha=0.5) +
  geom_ribbon(data=depdf, aes(year, ymin=depq3,ymax=depmax), fill="#0c2c84", 
              alpha=0.5) +
  # geom_hline(yintercept=1, linetype="dashed", color="black", size=1) +
  geom_line(data=depdf, aes(x=year,y=depmean), color = "black",linetype="dashed", size = 1) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_date(date_breaks = "1 year",date_labels = "%Y") +
  ylab("Relative Deprivation") +
  xlab("Year") +
  ggtitle("Regional Quartiles")

##### Print ====================================================================

grid.arrange(deplot, top=textGrob("Relative Economic Deprivation, England & Wales",gp=gpar(fontsize=18)))
