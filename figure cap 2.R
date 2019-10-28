# clear variables
rm(list = ls())

# used libraries
library(readr)
library(ggplot2)
library(dplyr)
library(dlm)

# Load database
data.1 <- read_csv("./data/UKdriversKSI.txt", col_types=list(col_double()))
colnames(data.1) = c("KSI")
data.1$logKSI <- log(data.1$KSI)
head(data.1)

data.2 <- read_table2("data/NorwayFinland.txt", col_types = list(col_double(), col_double(), col_double()))
head(data.1)

logKSI.ts <- ts(data.1$logKSI, start = c(1969), frequency=12)
logNorFatalities.ts <-  ts(log(data.2$Norwegian_fatalities), start = c(1970,1))


# 2.1 Deterministic Level
fit <- lm(logKSI ~ 1, data.1)
summary(fit)
data.1$res_det <- residuals(fit)
coefs <- round(as.numeric(coef(fit)),8)
error.var <- round(summary(fit)$sigma^2,8)

# par(mfrow=c(1,1))
# plot.ts(c(data.1), col = "darkgrey", xlab="",ylab = "log KSI",pch=3,cex=0.5,
#           cex.lab=0.8,cex.axis=0.7,xlim=c(0,200))
# abline(h=coefs[1] , col = "blue", lwd = 2, lty=2)
# legend("topright",leg = c("log UK drivers KSI",
#                             " deterministic level"),cex = 0.6,
#          lty = c(1, 2),col = c("darkgrey","blue"),
#          pch=c(3,NA), bty = "y", horiz = T)



captionText = "Figure 2.1: Deterministic level."
ggplot(data.1, aes(x=1:nrow(data.1), y=logKSI)) +
  geom_line(colour = "darkgrey") +
  geom_hline(yintercept = coefs, linetype="dashed", colour="blue", size = 0.8) +
  labs(title=NULL, # Title
       subtitle="", # Subtitle
       caption = captionText, # Caption
       y=NULL, 
       x=NULL,
       color=NULL) +
  xlim(0,200)


captionText = "Figure 2.2: Irregular component for deterministic level model."
# > par(mfrow=c(1,1))
# > plot(ts(residuals(fit)),ylab="",xlab="",xlim = c(0,200), col = "darkgrey",lty=2)
# > abline(h=0)

ggplot(data.1, aes(x=1:nrow(data.1), y=res_det)) +
  geom_line(linetype="dashed", colour = "darkgrey") +
  geom_hline(yintercept = 0, linetype="dashed", colour="blue", size = 0.8) +
  labs(title=NULL, # Title
       subtitle="", # Subtitle
       caption = captionText, # Caption
       y=NULL, 
       x=NULL,
       color=NULL) +
  xlim(0,200)




# To fit a stochastic level, there are several packages in R that can be used.
# I have used dlm for estimating the model parameters

fn <- function(params){
  # Create an n-th order polynomial DLM
  dlmModPoly(order= 1, dV= exp(params[1]) , dW = exp(params[2]))
}

# y: a vector, matrix, or time series of data.
# 
# parm: vector of initial values - for the optimization routine - of the unknown parameters.
# 
# build: a function that takes a vector of the same length as parm and returns 
# an object of class dlm, or a list that may be interpreted as such.
# 
fit <- dlmMLE(y = data.1$logKSI, parm = c(0,0), build =  fn)
mod <- fn(fit$par)
obs.error.var <- V(mod)
state.error.var <- W(mod)
mu.1 <- dropFirst( dlmFilter(data.1$logKSI, mod)$m )[1]

res <- residuals(dlmFilter(data.1$logKSI, mod), sd=F)
filtered <- dlmFilter(data.1$logKSI, mod)
smoothed <- dlmSmooth(filtered)
mu <- dropFirst(smoothed$s)
mu.1 <- mu[1]

par(mfrow=c(1,1))
plot.ts(data.1$logKSI, col = "darkgrey", xlab="",ylab = "log KSI",pch=3,cex=0.5,
        cex.lab=0.8,cex.axis=0.7,xlim=c(0,200))
lines(mu , col = "blue", lwd = 2, lty=2)
legend("topright",leg = c("log UK drivers KSI"," stochastic level"),
       cex = 0.6,lty = c(1, 2), col = c("darkgrey","blue"),
       pch=c(3,NA), bty = "y", horiz = T)



par(mfrow=c(1,1))
plot.ts(res,ylab="",xlab="", col = "darkgrey", main = "",cex.main = 0.8)
abline(h=0)

plot(logNorFatalities.ts)
logNorFatalities.ts[12] = NA
plot(logNorFatalities.ts)

# 2.3 The local level model and Norwegian fatalities
fit <- dlmMLE(logNorFatalities.ts, c(1,1), fn)
fit$par
mod <- fn(fit$par)
obs.error.var <- V(mod)
# [,1]
# [1,] 0.003268212
state.error.var <- W(mod)
# [,1]
# [1,] 0.004703001
filtered <- dlmFilter(logNorFatalities.ts, mod)
smoothed <- dlmSmooth(filtered)
mu <- dropFirst(smoothed$s)
mu.1 <- mu[1]
res <- residuals(filtered,sd=F)


par(mfrow=c(1,1))
temp <- window(cbind(logNorFatalities.ts,mu))
plot(temp , plot.type="single" , col =c("black","blue"),lty=c(1,2),
     xlab="",ylab = "log KSI")
legend("topright",leg = c("log UK drivers KSI"," stochastic level"),
       cex = 0.7, lty = c(1, 2),
       col = c("darkgrey","blue"),pch=c(3,NA),bty = "y", horiz = T)

