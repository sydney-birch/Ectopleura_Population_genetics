#actinula local adaptation study - 2024


#collected larva from 3 sites and biolifm from 3 sites (cml, york, wells)

#all larvae exposed to low green light

#design: 3x3 factorial CRD with 4 replicates 
#collected 10 individuals for rad seq-  
#collected 3 biolfim replicates from each site and sequenced (9 samples total)


#Set working Dir
setwd("/Users/Sydney/Library/CloudStorage/GoogleDrive-sbirch1@charlotte.edu/My Drive/Postdoc_work/PRFB_Ectopleura_work/2024 Field Work/Settlement_R")

#read in, inspect, and re-classify the data
behav_dat <- read.csv("~/Library/CloudStorage/GoogleDrive-sbirch1@charlotte.edu/My Drive/Postdoc_work/PRFB_Ectopleura_work/2024 Field Work/Settlement_R/Settlement_data_2024.csv", stringsAsFactors=TRUE)

behav_dat$Biofilm_Location<-as.factor(behav_dat$Biofilm_Location) 
behav_dat$Actinula_location<-as.factor(behav_dat$Actinula_location) 
behav_dat$Treatment<-as.factor(behav_dat$Treatment) 
behav_dat$Rep<-as.factor(behav_dat$Rep) 

str(behav_dat)

#The ANOVA - Two Way
behav_mod<-lm(AUC ~ Biofilm_Location*Actinula_Location, behav_dat) 
anova(behav_mod)

#Analysis of Variance Table
#Response: AUC
                                   #Df Sum Sq Mean Sq F value    Pr(>F)    
#Biofilm_Location                    2 215.75 107.876  18.757 7.816e-06 ***
#Actinula_Location                   2 116.60  58.301  10.137 0.0005199 ***
#Biofilm_Location:Actinula_Location  4 530.68 132.669  23.068 2.232e-08 ***
#Residuals                          27 155.28   5.751                        
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


#visualize to get an idea of whats happening

#Biofilm location
boxplot(AUC ~ Biofilm_Location, behav_dat, main = "The Effect of Biofilm location on Settlement",
        xlab="Biofilm Location", ylab= "AUC of Settlement Percentage(over 24hrs)")

#actinula location
boxplot(AUC ~ Actinula_Location, behav_dat, main = "The Effect of Actinula location on Settlement",
        xlab="Actinula Location", ylab= "AUC of Settlement Percentage(over 24hrs)")



#Tukey
library(agricolae)

biofilm_comparison<-HSD.test(behav_mod, "Biofilm_Location")
#AUC groups
#Biofilm_Wells 14.175000      a
#Biofilm_CML   12.108333      a
#Biofilm_York   8.266667      b

actinula_comparison<-HSD.test(behav_mod, "Actinula_Location")
#AUC groups
#Actinula _Wells 13.975000      a
#Actinula _York  10.858333      b
#Actinula _CML    9.716667      b



#subset data and run tukey

#CML larvae
cml_larvae<- subset(behav_dat, behav_dat$Actinula_Location  == "Actinula _CML")
biofilm_comparison_cml<-HSD.test(cml_Dun, "Biofilm_Location")
#AUC groups
#Biofilm_CML   15.50      a
#Biofilm_Wells 11.60      a
#Biofilm_York   2.05      b

#york larvae
york_larvae<- subset(behav_dat, behav_dat$Actinula_Location  == "Actinula _York")
biofilm_comparison_york<-HSD.test(york_Dun, "Biofilm_Location")
#AUC groups
#Biofilm_York  14.325      a
#Biofilm_Wells 11.125      a
#Biofilm_CML    7.125      b

#Wells larvae
wells_larvae<- subset(behav_dat, behav_dat$Actinula_Location  == "Actinula _Wells")
biofilm_comparison_york<-HSD.test(wells_Dun, "Biofilm_Location")

#AUC groups
#Biofilm_Wells 19.800      a
#Biofilm_CML   13.700      b
#Biofilm_York   8.425      b

#Run Dunnetts
cml_Dun<-lm(AUC ~ Biofilm_Location, cml_larvae)
anova(cml_Dun)
library(multcomp)
test.dunnett=glht(cml_Dun,linfct=mcp(Biofilm_Location="Dunnett"))
confint(test.dunnett)


york_Dun<-lm(AUC ~ Biofilm_Location, york_larvae)
anova(york_Dun)
library(multcomp)
test.dunnett=glht(york_Dun,linfct=mcp(Biofilm_Location="Dunnett"))
confint(test.dunnett)

wells_Dun<-lm(AUC ~ Biofilm_Location, wells_larvae)
anova(wells_Dun)
library(multcomp)
test.dunnett=glht(york_Dun,linfct=mcp(Biofilm_Location="Dunnett"))
confint(test.dunnett)


tot_Dun<-lm(AUC ~ Biofilm_Location, behav_dat)
anova(tot_Dun)
library(multcomp)
test.dunnett=glht(tot_Dun,linfct=mcp(Biofilm_Location="Dunnett"))
confint(test.dunnett)



#interaction plots 
library(HH)
intxplot(AUC ~ Biofilm_Location, groups = Actinula_Location, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)

#easier to interpret 
intxplot(AUC ~ Actinula_Location, groups = Biofilm_Location, data=behav_dat, se=TRUE, ylim=range(behav_dat$AUC),
         offset.scale=500)


#Box plot with multiple groups
library(ggplot2)
ggplot(behav_dat, aes(x=Biofilm_Location, y=AUC, fill=Actinula_Location)) +
  geom_boxplot() + theme_classic() + scale_fill_manual(values=c("#E07A5F", "#3D405B","#81B29A"))

ggplot(behav_dat, aes(x=Actinula_Location, y=AUC, color=Actinula_Location)) + geom_boxplot() + 
  geom_jitter(shape=16, size= 2) +
  labs(x="Location", y = "AUC of Settlement Percentage (over 24hrs)", title="Larval Settlement Rates from reciprocal transplant settlement study" ) +
  guides(fill=guide_legend(title="Location Key")) + 
  scale_color_manual(values=c("#E9B44C", "#9B2915","#50A2A7"))+ 
  facet_wrap(~Biofilm_Location, scale="free") +
  theme(plot.title = element_text(size=22),axis.text=element_text(size=rel(1.5)), legend.key.size=unit(1.5,"cm"),
        axis.title=element_text(size=17), axis.text.x = element_text(angle = 45, hjust=1),
        legend.text=element_text(size=15), legend.title=element_text(size=15))



behav_mod2<-lm(AUC ~Treatment, behav_dat) 
anova(behav_mod2)
power.anova.test( groups = 2, 
                  within.var = 2.31, between.var= 26.717,
                  sig.level = 0.05, power=0.9)

library(pwr)
pwr.anova.test(k=12, f=.25, sig.level=0.05, power=0.80)


library(WebPower)
wp.kanova(ndf=3, f=5.4, ng=16,alpha = 0.05, power =0.80)



