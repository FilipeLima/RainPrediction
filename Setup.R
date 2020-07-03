library(ggplot2)
library(lubridate)
library(dplyr)
library(readr)

dir.create("./data")

unzip("Medicoes_convencionais.zip",exdir="./data")

arquivos <- list.files("./data") 
setwd("./data")

for (i in 1:length(arquivos) ){
  unzip(arquivos[i])
  unlink(arquivos[i])
}

chuvas_T_00834007 <- read_delim("chuvas_T_00834007.txt",
";", escape_double = FALSE, locale = locale(date_format = "%d/%m/%Y",
decimal_mark = ",", grouping_mark = ""),
na = "empty", trim_ws = TRUE, skip = 10)

chuvas_T_00834007$Month <- as.factor(month(chuvas_T_00834007$Data,label=T))
chuvas_total <- select(chuvas_T_00834007,list=c(Data,Maxima,Total,Month))
names(chuvas_total) <- c("Data","Maxima","Total","Month")

setwd(".")

png("boxplot.png", width=1280, height=720)
g <- ggplot(chuvas_total,aes(Data,Total,color=Month))
g+geom_boxplot()+facet_grid(.~Month)+theme(axis.text.x = element_text(angle=90))+labs(x="Ano",y="Precipitação",title="Precipitação Mensal em Recife")
dev.off()

png("pointplot.png", width=1280, height=720)
g <- ggplot(chuvas_total,aes(Data,Total,color=Month))
g+geom_point()+geom_smooth(method='lm',se=FALSE)+facet_grid(.~Month)+theme(axis.text.x = element_text(angle=90))+labs(x="Ano",y="Precipitação",title="Precipitação Mensal em Recife")
dev.off()

png("barplot.png", width=1280, height=720)
g <- ggplot(chuvas_total[1:100,],aes(x=Data,y=Total,fill=Month))
g+geom_bar(stat="identity")+theme(axis.text.x = element_text(angle=90))+labs(x="Ano",y="Precipitação",title="Precipitação Mensal em Recife")
dev.off()
