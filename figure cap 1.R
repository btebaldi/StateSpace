# clear variables
rm(list = ls())

# used libraries
library(readr)
library(ggplot2)

# Load database
data <- read_csv("./data/UKdriversKSI.txt", col_types=list(col_double()))
colnames(data) = c("KSI")
head(data)

data$logKSI <- log(data$KSI)
data$trend <- 1:nrow(data)

fit <- lm(logKSI ~ trend, data)
summary(fit)
coefs <- round(as.numeric(coef(fit)),8)
error.var <- round(summary(fit)$sigma^2,8)
f.stat <- round(summary(fit)$fstatistic[1],8)

data$residual = residuals(fit)

captionText = "Figure 1.1: Scatter plot of the log of the number of UK drivers KSI \nagainst time (in months), including regression line."

ggplot(data, aes(x=trend, y=logKSI)) +
  geom_point(shape = 3) +
  geom_abline(slope = coefs[2], intercept = coefs[1], linetype="dashed", colour="blue", size = 0.8) +
  labs(title="log UK drivers KSI against time(in months)", # Title
       subtitle="", # Subtitle
       caption = captionText, # Caption
       y='log KSI', 
       x=NULL,
       color=NULL) +
  xlim(0,200)



captionText = "Figure 1.2: Log of the number of UK drivers KSI plotted as a time series."
ggplot(data, aes(x=trend, y=logKSI)) +
  geom_line(colour = "darkgrey") +
  labs(title="log UK drivers KSI", # Title
       subtitle="", # Subtitle
       caption = captionText, # Caption
       y=NULL, 
       x=NULL,
       color=NULL) +
  xlim(0,200)


captionText = "Figure 1.3: Residuals of classical linear regression of \nthe log of the number of UK drivers KSI on time."
ggplot(data, aes(x=trend, y=residual)) +
  geom_line(colour = "darkgrey") +
  geom_abline(slope = 0, intercept = 0) +
  labs(title="residuals", # Title
       subtitle="", # Subtitle
       caption = captionText, # Caption
       y=NULL, 
       x=NULL,
       color=NULL) +
  xlim(0,200)

# par(mfrow=c(1,1))
acf(data$residual, 15, main="")
# "Figure 1.5: Correlogram of classical regression residuals."
