library(zoo)
library(data.table)
library(lubridate)
library(forecast)
library(ggplot2)

tr<-read.csv("EICHERMOT.BO.csv")
View(tr)

tr$net<-tr$Close - tr$Open

x<-ts(tr$net, start = c(2016,1))
autoplot(x)

