# Animation code
# Originaly created by Jinsub
# TD:
#  - fig out and add data imports here
#    refer to shendrickson5.gnip.com:/mnt/jinsub/2013-05-30_APtweet
#
disqus.timeline$time<-as.POSIXct(disqus.timeline$time)
tumblr.timeline$time<-as.POSIXct(tumblr.timeline$time)
wp.com.timeline$time<-as.POSIXct(wp.com.timeline$time)

## joining data sets for ggplot use later
df.new<-rbind(disqus.timeline,tumblr.timeline,wp.com.timeline,stocktwit.timeline3,df2[601:750,])

df.new<-rbind(df.new,df2[601:750,])
df.new$gamma<-0

## creating publisher column
df.new$pub <-1
df.new$pub[1:141] <- "disqus"
df.new$pub[142:285] <- "tumblr"
df.new$pub[286:429]<- "wp"
df.new$pub[430:nrow(df.new)]<-"stocktwit"
df.new$pub<-factor(df.new$pub)




## adding in scaled values from scale.py in a new column called scale, need these because thats what the fitted gamma values are based off of in the fit.py -fgamma script

df.new$scale = 0
df.new$scale[1:141]<-disqus_gammafit2$V1
df.new$scale[142:285]<-tumblr_gammafit2$V1
df.new$scale[286:429]<-wp.com_gammafit2$V1
df.new$scale[430:574]<-stocktwit_expfit2$V1

## plots for each publisher ##
ggplot(disqus.timeline[,c(1,3)], aes(time, count)) + geom_line() +xlab("Time") +ylab("Filtered Activity") + labs(title='Disqus Timeline - AP Hack')

ggplot(tumblr.timeline[,c(1,3)], aes(time, count)) + geom_line() +xlab("Time") +ylab("Filtered Activity") + labs(title='Tumblr Timeline - AP Hack')

ggplot(wp.com.timeline[,c(1,3)], aes(time, count)) + geom_line() +xlab("Time") +ylab("Filtered Activity") + labs(title='WP Timeline - AP Hack')


df2$gamma<-1
df$gamma[2:141]<-disqus_gammafit2[,4]
df$gamma[143:285]<-tumblr_gammafit2[,4]
df$gamma[287:429]<-wp.com_gammafit2[,4]

df.new$gamma[430:574]<-stocktwit_expfit2[,4]

hack<-as.POSIXct('2013-04-23 17:05:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")
fit<-as.POSIXct('2013-04-23 21:00:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")

# gamma fit plots# 
ggplot(df.new, aes(time, count)) + 
  geom_line(color="#66FFCC",size=1) +
  xlab("Time") +
  ylab("Filtered Activity") +
  labs(title="AP Hack Timeline",cex=15)+
  facet_grid(pub~.,scales="free_y") +
  geom_vline(xintercept=c(as), color='#E56D25', size=1, alpha=1, linetype = "longdash")+
  geom_vline(xintercept=as.numeric(hack), color='#FFCC00', size=0.5, alpha=1, linetype = "longdash")+
  geom_line(aes(x=time, y=gamma), size=1,alpha=0.9 ,color='#FF3333')+
  theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1),legend.position = "none", panel.background = element_rect(fill = "#333333"),panel.grid.major = element_line(colour = "#444444"),panel.grid.minor = element_line(colour = "#757575"))+
  xlim(as.POSIXct('2013-04-23 12:00:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")
       ,as.POSIXct('2013-04-24 12:00:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")
  )

ggplot(df.new[df.new$pub=="twitter",],aes(time,count))+
  geom_line(color="#66FFCC",size=1)+
  xlab("Time")+
  ylab("Filtered Activity")+
  labs(title="AP Hack Timeline - Twitter")+
  labs(title="AP Hack Timeline",cex=15)+
  geom_vline(xintercept=as.numeric(hack), color='#FFCC00', size=0.5, alpha=1, linetype = "longdash")+
  geom_line(aes(x=time, y=gamma), size=1,alpha=0.9 ,color='#FF3333')+
  theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1),legend.position = "none", panel.background = element_rect(fill = "#333333"),panel.grid.major = element_line(colour = "#444444"),panel.grid.minor = element_line(colour = "#757575"))+
  xlim(as.POSIXct('2013-04-23 17:00:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")
       ,as.POSIXct('2013-04-23 19:00:00', tz="GMT", format="%Y-%m-%d %H:%M:%S")
  )
png("APHack-TwitterZoom.png",width=600,height=600)

## workaround... gamma fitter.. ripped from skippy's py code ## use if -r on fit.py is giving problems

gamma.fitter<-function(x,x0=0.125389,a=1.247240,b=0.050841,Az=2.058150){ # insert gamma parameters here
  arg = x - x0
  if(arg < 0){
    return(0.0)
  }
  c = b^(-a)
  return(Az * c * arg^(a-1.0)*exp(-arg/b)/gamma(a))
}

# fitter until 21:00 - dependent on your data
#assumes column names gamma and scale
### remember to change range of FOR loop to match the pub

trunc.fit<-function(dataframe){
  for(i in 286:429){ ### this is where you change the indices of your df to correspond with rows of each publisher
    dataframe$gamma[i]<-gamma.fitter(dataframe$scale[i])
  }
  return(dataframe)
}

df.new<-trunc.fit(df.new)



##### PROJECT PART 2 - 5 HR 5 PUB STACK w/ confidence intervals
disqus.timeline.5hr<-disqus.timeline.5hr[17:166,]
tumblr.timeline.5hr<-tumblr.timeline.5hr[-151,]
wp.com.timeline.5hr<-wp.com.timeline.5hr[8:157,]
stocktwit.timeline.5hr<-stocktwit.timeline.5hr[1:150,]

df2<-rbind(disqus.timeline.5hr,tumblr.timeline.5hr,wp.com.timeline.5hr,stocktwit.timeline.5hr,twitter.timeline.5hr.b)

df2$time<-as.POSIXct(df2$time)

df2$pub <-1
df2$pub[1:150] <- "disqus"
df2$pub[151:300]<- "tumblr"
df2$pub[301:450]<-"wp"
df2$pub[451:600]<-"stocktwit"
df2$pub[601:750]<-"twitter"
df2$pub<-factor(df2$pub)


### plotting and adding poisson generalised additive model poisson smoother
library(mgcv) #package with GAM poisson model

ggplot(df2[df2$pub==c("disqus","tumblr","wp"),], aes(time,count)) + 
  geom_line(color="#66FFCC",size=1,alpha=0.1)+
  xlab("Time") +
  ylab("Filtered Activity") +
  labs(title="AP Hack Timeline",cex=15)+
  facet_grid(pub~.,scales="free_y") +
  geom_vline(xintercept=as.numeric(hack), color='#FFCC00', size=0.5, alpha=1, linetype = "longdash")+
  geom_line(aes(x=time, y=gamma), size=1,alpha=0.7, color='#FF3333')+
  theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1),legend.position = "none", panel.background = element_rect(fill = "#333333"),panel.grid.major = element_line(colour = "#444444"),panel.grid.minor = element_line(colour = "#444444"))+
  geom_errorbar(aes(ymin=df.ar.disqus$lower,ymax=df.ar.disqus$upper,x=df.ar.disqus$time),subset(df2,pub=="disqus"),col="#FF3300",width=0.25,size=5,alpha=0.7)+
  geom_point(aes(df.ar.disqus$time,df.ar.disqus$m),subset(df2,pub=="disqus"),col="#66FFCC",shape=16,size=2)+
  geom_errorbar(aes(ymin=df.ar.tumblr$lower,ymax=df.ar.tumblr$upper,x=df.ar.disqus$time,y=df.ar.tumblr$m),subset(df2,pub=="tumblr"),col="#FF3300",width=1,size=5,alpha=0.7)+
  geom_point(aes(df.ar.tumblr$time,df.ar.tumblr$m),subset(df2,pub=="tumblr"),col="#66FFCC",shape=16,size=2)+
  geom_errorbar(aes(ymin=df.ar.wp$lower,ymax=df.ar.wp$upper,x=df.ar.disqus$time),subset(df2,pub=="wp"),col="#FF3300",width=0.25,size=5,alpha=0.7)+
  geom_point(aes(df.ar.wp$time,df.ar.wp$m),subset(df2,pub=="wp"),col="#66FFCC",shape=16,size=2)+
  geom_hline(aes(yintercept=20),col="green",alpha=0,subset(df2,pub=="disqus"))+
  geom_hline(aes(yintercept=30),col="green",alpha=0,subset(df2,pub=="tumblr"))+
  geom_hline(aes(yintercept=15),subset(df2,pub=="wp"),alpha=0,col="green")+
  geom_text(aes(x=as.POSIXct('2013-04-23 21:45:00', tz="GMT", format="%Y-%m-%d %H:%M:%S"),y=17,label="bucket size 75"),size=4,col="#BBBBBB",subset(df2,pub=="disqus"),family="Archer")



#geom_line(aes(df.ar.tumblr$time,df.ar.tumblr$lower),col="#FF3333",linetype="longdash",subset(df2,pub=="tumblr"))+
#geom_line(aes(df.ar.tumblr$time,df.ar.tumblr$upper),col="#FF3333",linetype="longdash",subset(df2,pub=="tumblr"))+
#geom_line(aes(df.ar.wp$time,df.ar.wp$lower),col="#FF3333",linetype="longdash",subset(df2,pub=="wp"))+
#geom_line(aes(df.ar.wp$time,df.ar.wp$upper),col="#FF3333",linetype="longdash",subset(df2,pub=="wp"))
#geom_smooth(method = 'gam', family = 'poisson',formula = y~s(x),data = subset(df2, pub ==c("disqus","tumblr","wp")),col='#FF3333')
###

df2$ar<-0

activity_rate<-function(dataframe){ ### pass in subset of dataframe, with dataframe cut by pub
  for(i in 2:nrow(dataframe)){
    dataframe$ar[i]<-sum(dataframe$count[1:i])/(2*(i-1))
  }
  return(dataframe)
}

#### make BUCKETS of size divisible into 150 
buckets<-c(1,2,3,5,10,15,25,30,50,75)


### CI point calculations ##
bounds<-function(dataframe,d){
  dataframe$lower<-NA # initialising columns in dataframe with NAs
  dataframe$n<-NA
  dataframe$upper<-NA
  dataframe$width<-NA
  dataframe$m<-NA
  for(i in 1:(nrow(dataframe)/d)){  
    m <-mean(dataframe$count[(i*d-(d-1)):((i*d-(d-1))+(d-1))])
    n <-sum(dataframe$count[(i*d-(d-1)):((i*d-(d-1))+(d-1))])
    lower.final <- (n*(1-(1/(9*n))-(1.96/(3*(n^0.5))))^3)/(d)
    dataframe$lower[((i*d-(d-1))+(d-1))] <- lower.final
    upper.final <-((n+1)*(1-(1/(9*(n+1)))+1.96/(3*(n+1)^0.5))^3)/(d)
    dataframe$upper[((i*d-(d-1))+(d-1))]<-upper.final
    dataframe$m[((i*d-(d-1))+(d-1))]<-m 
    dataframe$n[((i*d-(d-1))+(d-1))]<-n 
  }
  dataframe$width<-abs(dataframe$lower-dataframe$upper)
  return(dataframe)
}


## second bound function for shrinking CIs plot for bin size 75
bounds2<-function(dataframe,d){
  dataframe$lower<-NA
  dataframe$n<-NA
  dataframe$upper<-NA
  dataframe$width<-NA
  dataframe$m<-NA
  lead_zero = 0
  j=1
  while(dataframe$count[j]==0){
    lead_zero = lead_zero + 1
    j = j + 1
  }
  for(i in 1:length(dataframe$count)){
    if(dataframe$count[i]!=0){
      lead_zero <- i-1
    }
    break()
  }
  for(i in 1:(nrow(dataframe)/2)){
    n <-sum(dataframe$count[1:i])
    lower.final <- (n*(1-(1/(9*n))-(1.96/(3*(n^0.5))))^3)/abs((i-lead_zero))
    dataframe$lower[i] <- lower.final
    upper.final <-((n+1)*(1-(1/(9*(n+1)))+1.96/(3*(n+1)^0.5))^3)/abs((i-lead_zero))
    dataframe$upper[i]<-upper.final
    dataframe$n[i]<-n 
  }
  for(i in ((nrow(dataframe)/2)+1):(nrow(dataframe))){  
    n <-sum(dataframe$count[((nrow(dataframe)/2)+1):i])
    lower.final <- (n*(1-(1/(9*n))-(1.96/(3*(n^0.5))))^3)/(i-((nrow(dataframe)/2)))
    dataframe$lower[i] <- lower.final
    upper.final <-((n+1)*(1-(1/(9*(n+1)))+1.96/(3*(n+1)^0.5))^3)/(i-((nrow(dataframe)/2)))
    dataframe$upper[i]<-upper.final
    dataframe$n[i]<-n 
  }
  dataframe$width<-abs(dataframe$lower-dataframe$upper)
  return(dataframe)
}




####

#### BOUNDS  in a list ###
# each list for each pub has folds for each dataframe with its corresponding CI calculations (like key-value pairs in python)
df.disqus.all<-list()
df.tumblr.all<-list()
df.wp.all<-list()
for(i in 1:length(buckets)){
  df.disqus.all[[i]]<-assign(paste("df.disqus.final", buckets[i],sep=""), bounds(df.ar.disqus,buckets[i]))
  df.tumblr.all[[i]]<-assign(paste("df.tumblr.final", buckets[i]), bounds(df.ar.tumblr,buckets[i]))
  df.wp.all[[i]]<-assign(paste("df.wp.final", buckets[i]), bounds(df.ar.wp,buckets[i]))
}

######

#six.min.diff<-function(dataframe){
# dataframe$six.bin<-0
#for(i in 4:nrow(dataframe)){
#  dataframe$six.bin[i]<-abs(dataframe$n[i]-dataframe$n[i-3])/6
#  }
#  return(dataframe)
#}

#### take into account time (count vs rate conversion)
#sig.checker<-function(dataframe){
#  dataframe$sig<-0
#  for(i in 5:nrow(dataframe)){
#    if(dataframe$six.bin[i] > 3*dataframe$width[i]){
#      dataframe$sig[i]<-1
#    }
#  }
#  return(dataframe)
#}
#
df.ar.disqus<-bounds(df.ar.disqus)

df.ar.disqus<-activity_rate(df2[1:150,]) ####
df.ar.disqus$lower<-0 
df.ar.disqus$upper<-0
df.ar.disqus$n<-0
df.ar.disqus$width<-abs(df.ar.disqus$lower-df.ar.disqus$upper)
df.ar.disqus$six.bin<-0

six.min.diff(df.ar.disqus) ###

################
df.ar.tumblr<-activity_rate(df2[151:300,])
df.ar.wp<-activity_rate(df2[df2$pub=="wp",])
df.ar.stocktwit<-activity_rate(df2[df2$pub=="stocktwit",])
df.ar.twitter<-activity_rate(df2[df2$pub=="twitter",])



df.ar.disqus<-six.min.diff(df.ar.disqus)
df.ar.tumblr<-six.min.diff(df.ar.tumblr)
df.ar.wp<-six.min.diff(df.ar.wp)
df.ar.stocktwit<-six.min.diff(df.ar.stocktwit)
df.ar.twitter<-six.min.diff(df.ar.twitter)

sig.checker(df.ar.disqus)
sig.checker(df.ar.tumblr)
sig.checker(df.ar.wp)
sig.checker(df.ar.stocktwit)
sig.checker(df.ar.twitter)

cbind(df2[1:150,],df.ar.disqus$lower,df.ar.disqus$upper)
cbind(df2[df2$pub=="tumblr",],df.ar.tumblr$lower,df.ar.tumblr$upper)
cbind(df2[df2$pub=="wp",],df.ar.wp$lower,df.ar.wp$upper)



#### latest 5pubframe maker### for loop to create all the frames

for(i in 1:length(buckets)){
  if(i >=5){
    ci_size=5
  }
  else{
    ci_size=1
  }
  png(filename = paste(sep="","5pubframes",i, ".png"), width = 600, height = 800, units = 'px') ### paste function creates new variable names according to i
  print(ggplot(df2[df2$pub==c("disqus","tumblr","wp"),], aes(time,count)) +  ## for ggplot to work in a loop, need to explicitly print to screen
          geom_line(color="#66FFCC",size=1,alpha=0.1)+
          xlab("Time") +
          ylab("Filtered Activity") +
          labs(title="AP Hack Timeline - 95% CI",cex=15)+
          facet_grid(pub~.,scales="free_y") +
          geom_vline(xintercept=c(as), color='#E56D25', size=1, alpha=1, linetype = "longdash")+
          geom_vline(xintercept=as.numeric(hack), color='#FFCC00', size=0.5, alpha=1, linetype = "longdash")+
          theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1),legend.position = "none", panel.background = element_rect(fill = "#333333"),panel.grid.major = element_line(colour = "#444444"),panel.grid.minor = element_line(colour = "#444444"))+
          geom_point(aes(df.disqus.all[[i]]$time,df.disqus.all[[i]]$m),subset(df2,pub=="disqus"),col="#66FFCC",shape=16,size=2)+
          geom_point(aes(df.tumblr.all[[i]]$time,df.tumblr.all[[i]]$m),subset(df2,pub=="tumblr"),col="#66FFCC",shape=16,size=2)+
          geom_point(aes(df.wp.all[[i]]$time,df.wp.all[[i]]$m),subset(df2,pub=="wp"),col="#66FFCC",shape=16,size=2)+
          geom_errorbar(aes(ymin=df.disqus.all[[i]]$lower,ymax=df.disqus.all[[i]]$upper,x=df.disqus.all[[i]]$time),subset(df2,pub=="disqus"),col="#FF3300",width=0.1,size=ci_size,alpha=0.5)+
          geom_errorbar(aes(ymin=df.tumblr.all[[i]]$lower,ymax=df.tumblr.all[[i]]$upper,x=df.tumblr.all[[i]]$time),subset(df2,pub=="tumblr"),col="#FF3300",width=0.1,size=ci_size,alpha=0.5)+
          geom_errorbar(aes(ymin=df.wp.all[[i]]$lower,ymax=df.wp.all[[i]]$upper,x=df.wp.all[[i]]$time),subset(df2,pub=="wp"),col="#FF3300",width=0.1,size=ci_size,alpha=0.5)+
          geom_hline(aes(yintercept=20),col="green",alpha=0,subset(df2,pub=="disqus"))+
          geom_hline(aes(yintercept=30),col="green",alpha=0,subset(df2,pub=="tumblr"))+
          geom_hline(aes(yintercept=15),subset(df2,pub=="wp"),alpha=0,col="green")+
          geom_text(aes(x=as.POSIXct('2013-04-23 21:45:00', tz="GMT", format="%Y-%m-%d %H:%M:%S"),y=17,label=paste("bucket size:",buckets[i])),size=4,col="#BBBBBB",subset(df2,pub=="disqus"),family="Archer")
  )
  dev.off()
}

##### creating shrinking CI interval plot

df.ar.disqus<-bounds2(df.ar.disqus,1)
df.ar.tumblr<-bounds2(df.ar.tumblr,1)
df.ar.wp<-bounds2(df.ar.wp,1)

#### creating the two points needed for the shrinking interval plot and running bounds2 function
df.ar.disqus<-bounds(df.ar.disqus,75)
avg75.disqus<-vector(mode="numeric",length=150)
avg75.disqus[]<-NA
avg75.disqus[75]<-df.ar.disqus$m[75]
avg75.disqus[150]<-df.ar.disqus$m[150]
df.ar.disqus<-bounds2(df.ar.disqus,1)

df.ar.tumblr<-bounds(df.ar.tumblr,75)
avg75.tumblr<-vector(mode="numeric",length=150)
avg75.tumblr[]<-NA
avg75.tumblr[75]<-df.ar.tumblr$m[75]
avg75.tumblr[150]<-df.ar.tumblr$m[150]
df.ar.tumblr<-bounds2(df.ar.tumblr,1)


df.ar.wp<-bounds(df.ar.wp,75)
avg75.wp<-vector(mode="numeric",length=150)
avg75.wp[]<-NA
avg75.wp[75]<-df.ar.wp$m[75]
avg75.wp[150]<-df.ar.wp$m[150]
df.ar.wp<-bounds2(df.ar.wp,1)


## creating final plot##
png("shrink_CI.png",width=600)
ggplot(df2[df2$pub==c("disqus","tumblr","wp"),], aes(time,count)) + 
  geom_line(color="#66FFCC",size=1,alpha=0.1)+
  xlab("Time") +
  ylab("Filtered Activity") +
  labs(title="Shrinking CIs with Increasing Bin size",cex=15)+
  facet_grid(pub~.,scales="free_y") +
  geom_vline(xintercept=as.numeric(hack), color='#FFCC00', size=0.5, alpha=1, linetype = "longdash")+
  geom_line(aes(x=time, y=gamma), size=1,alpha=0.7, color='#FF3333')+
  theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1),legend.position = "none", panel.background = element_rect(fill = "#333333"),panel.grid.major = element_line(colour = "#444444"),panel.grid.minor = element_line(colour = "#444444"))+
  geom_errorbar(aes(ymin=df.ar.disqus$lower,ymax=df.ar.disqus$upper,x=df.ar.disqus$time),subset(df2,pub=="disqus"),col="#FF3300",width=0.25,size=2.5,alpha=0.3)+
  geom_point(aes(df.ar.disqus$time,avg75.disqus),subset(df2,pub=="disqus"),col="#66FFCC",shape=16,size=2)+
  geom_errorbar(aes(ymin=df.ar.tumblr$lower,ymax=df.ar.tumblr$upper,x=df.ar.disqus$time),subset(df2,pub=="tumblr"),col="#FF3300",width=0.25,size=2.5,alpha=0.3)+
  geom_point(aes(df.ar.tumblr$time,avg75.tumblr),subset(df2,pub=="tumblr"),col="#66FFCC",shape=16,size=2)+
  geom_errorbar(aes(ymin=df.ar.wp$lower,ymax=df.ar.wp$upper,x=df.ar.disqus$time),subset(df2,pub=="wp"),col="#FF3300",width=0.25,size=2.5,alpha=0.3)+
  geom_point(aes(df.ar.tumblr$time,avg75.wp),subset(df2,pub=="wp"),col="#66FFCC",shape=16,size=2)
dev.off()
