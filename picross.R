#Librairies à utiliser
library(ggplot2)

#creation picross 5X5
p5X5<-readxl::read_xlsx("picross_5X5.xlsx",sheet = "snake",col_names = F)
p5X5
ggplot(p5X5,aes(x=V1,y=1)) +
  geom_point(color=1,size=4,shape=15)

