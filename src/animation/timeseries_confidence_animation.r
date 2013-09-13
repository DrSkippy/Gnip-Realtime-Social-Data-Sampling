##do NOT use Jin's workspace at /home/jinsub/2013-05-03_APtweet/data/

###############################
###############################BOUNDS
###############################
### Creating bounds per bin using approximation
#n = number of activities [n(1− 1/(9n) − 1.96/(3√n))^3 ,(n+1)(1− 1/(9(n+1)) + 1.96/(3√n+1))^3 ]
###
#i = row number 
#dataframe$count[i] = n 

#counts upper bound: dataframe$upper[i]<-dataframe$count[i]+1)*((1-(1/(9*(dataframe$count[i]+1)))+(1.96/(3*sqrt(dataframe$count[i]+1))))^3)
#counts lower bound: dataframe$lower[i]<-dataframe$count[i]*(1-1/(9*dataframe$count[i])-(1.96)/(3*(dataframe$count[i])^0.5))^3
bounds<-function(dataframe){
  for(i in 1:(nrow(dataframe))){
    if (i==1){dataframe$delta=as.numeric(difftime(dataframe$time[i+1],dataframe$time[i],tz,units="mins"))
    }
    dataframe$upper[i]<-((dataframe$count[i]+1)*((1-(1/(9*(dataframe$count[i]+1)))+(1.96/(3*sqrt(dataframe$count[i]+1))))^3))/dataframe$delta[i]
    dataframe$lower[i]<-(dataframe$count[i]*(1-1/(9*dataframe$count[i])-(1.96)/(3*(dataframe$count[i])^0.5))^3)/dataframe$delta[i]
  }
  dataframe$width<-abs(dataframe$lower-dataframe$upper)
  dataframe$rate<-dataframe$count/dataframe$delta
  return(dataframe)
}

#test (tumblr$count[1]+1)*(1-(1/(9*(tumblr$count[1]+1))+(1.96/(3*(tumblr$count[1])^0.5))))^3
# test tumblr$count[1]*(1-1/(9*tumblr$count[1])-(1.96)/(3*(tumblr$count[1])^0.5))^3

###DID NOT USE...idea for future: Creating bounds per bin using stadardized R function
library("MBESS", lib.loc="/home/blehman/R/library")
conf.limits.nc.chisq(Chi.Square=30, conf.level=.95, df=15) #http://rss.acs.unt.edu/Rdoc/library/MBESS/html/conf.limits.nc.chisq.html
chi.noncentral.conf(6,1,.95) #https://rforge.net/doc/packages/Deducer/chi.noncentral.conf.html

###############################
###############################ERROR BAR PLOTS
###############################
###############################FRESH BINS - all files pulled from shendrickson5: /home/blehman/2013-09-05_SamplingViz/rdata
###############################
t1<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.2min.csv",sep=",",header=T)
t1$info="activity rate"
t1$time<-as.POSIXct(t1$time)
t1<-bounds(t1)

t2<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.4min.csv",sep=",",header=T)
t2$info="activity rate"
t2$time<-as.POSIXct(t2$time)
t2<-bounds(t2)

t3<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.8min.csv",sep=",",header=T)
t3$info="activity rate"
t3$time<-as.POSIXct(t3$time)
t3<-bounds(t3)

t4<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.16min.csv",sep=",",header=T)
t4$info="activity rate"
t4$time<-as.POSIXct(t4$time)
t4<-bounds(t4)

t5<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.32min.csv",sep=",",header=T)
t5$info="activity rate"
t5$time<-as.POSIXct(t5$time)
t5<-bounds(t5)

t6<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.64min.csv",sep=",",header=T)
t6$info="activity rate"
t6$time<-as.POSIXct(t6$time)
t6<-bounds(t6)

t7<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.128min.csv",sep=",",header=T)
t7$info="activity rate"
t7$time<-as.POSIXct(t7$time)
t7<-bounds(t7)

t8<-read.delim("/home/blehman/2013-09-05_SamplingViz/rdata/tumblr.256min.csv",sep=",",header=T)
t8$info="activity rate"
t8$time<-as.POSIXct(t8$time)
t8<-bounds(t8)

mylist=list(t1[1:(nrow(t1)-1),],t2[1:(nrow(t2)-1),],t3[1:(nrow(t3)-1),],t4[1:(nrow(t4)-1),],t5[1:(nrow(t5)-1),],t6[1:(nrow(t6)-1),],t7[1:2,],t8)
for (i in 4:7){
  deltaTS=mylist[[i]][2,1]-mylist[[i]][1,1]
  print(ggplot(data=mylist[[i]],aes(x=time+deltaTS*.97,y=rate,color=info,fill=info,group=info))+
          geom_pointrange(aes(ymin=lower,ymax=upper,x=time+deltaTS*.97,position="identity"),color="white")+
          geom_pointrange(aes(ymin=lower,ymax=upper,x=time+deltaTS*.97-.001*deltaTS,position="identity"),color="white")+
          geom_pointrange(aes(ymin=lower,ymax=upper,x=time+deltaTS*.97+.001*deltaTS,position="identity"),color="white")+
          geom_line(data=t3,aes(x=time,y=rate),alpha=0.3,color="gray",size=3)+
          geom_point(size=7,color="white")+
          geom_point(size=6,color="tomato")+
          geom_segment(data=mylist[[i]],aes(x=time, y=0, xend=time+(deltaTS*.96), yend=0), alpha=0.7,color="tomato",size=3,show_guide=F)+
          theme(legend.title = element_text(size=15),
                legend.text = element_text(size = 15),
                plot.title = element_text(size=20),
                strip.text = element_text(size=18),
                axis.title.x = element_text(size=18),
                axis.title.y = element_text(size=19),
                axis.text.x = element_text(size = 15, colour = 'black', angle = 0),
                axis.text.y = element_text(size = 15, colour = 'black', angle = 0),
                legend.position = "right",
                panel.background = element_rect(fill = "#333333"),
                panel.grid.major = element_line(colour = "#454545"),
                panel.grid.minor = element_line(colour = "#454545"))+
          ylim(0,6.5)+
          scale_x_datetime(lim = c(as.POSIXct("2013-04-23 16:30:00", format="%Y-%m-%d %H:%M:%S"),as.POSIXct("2013-04-23 22:30:00", format="%Y-%m-%d %H:%M:%S")))+
          xlab("time of day")+
          ylab("activities/min")+
          ggtitle("Activity Rates - Uncertainty vs Signal")
  )}

