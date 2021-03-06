library(XML)

setwd("/Users/marskar/GitHub/extractHTML")
getwd()

#TODO: How to deal with duplicates? How to fix broken links?

#Step1: Copy HTML from source in Chrome again - *DONE* saved as InvestorIDs.csv
#Step2: Create links and make sure links work for all rows

inv<-read.csv("InvestorIDs.csv", encoding = "Unicode", header = FALSE)
inv<-gsub("\x8d","c", inv$V1)
inv[87]
inv<-as.data.frame(inv)
#Remove front tag
head(inv)
InvID<-gsub("<option value=\"","", inv$inv)
head(InvID)
#Remove name and back tag
InvID<-gsub(">.*.>","", InvID)
head(InvID)
InvID<-gsub("[^0-9]", "", InvID)
head(InvID)
InvID<-grep("[0-9]", InvID, value = TRUE)
head(InvID)

InvName<-gsub("<.*?>","", inv$inv)
InvName<-gsub(".xfc.xbe.x99.x83.xa0.xb","c", InvName)
InvName[87]
head(InvName)

InvWebsite<-paste0("http://www.seed-db.com/investorgraph/investorview?investorid=",InvID)

df<-cbind(InvName,InvID,InvWebsite)

Acc<-read.csv("AcceleratorIDs.csv", encoding = "Unicode", header = FALSE)

#Remove front tag
head(Acc)
Acc<-Acc$V1
AccID<-gsub("<option value=\"","", Acc)
head(AccID)
#Remove name and back tag
AccID<-gsub(">.*.>","", AccID)
head(AccID)
AccID<-gsub("[^0-9]", "", AccID)
head(AccID)
AccID<-grep("[0-9]", AccID, value = TRUE)
head(AccID)

AccName<-gsub("<.*?>","", Acc)
head(AccName)
AccWebsite<-paste0("http://www.seed-db.com/investorgraph/acceleratorview?acceleratorid=",AccID)
AccWebsite[16]
df2<-cbind(AccName,AccID,AccWebsite)


write.csv(df, "InvNameIDwebsite.csv")
write.csv(df2, "AccNameIDwebsite.csv")


#this works 
#tbl<- readHTMLTable("http://www.seed-db.com/investorgraph/investorview?investorid=4903702712287232", which=1)
#write.csv(tbl, "406 Ventures.csv")

#try a for loop
# for(i in 1:7124) {
#   investor<-as.character(inv[i,1])
#   investorid<-inv[i,2]
#   url<-as.character(inv[i,3])
#   try(tbl<- readHTMLTable(url, which=1))
#   try(write.csv(tbl, paste0(investor,".csv")))
#   remove(tbl)
# }


#make a function then lapply

library(XML)

get.html <- function(i) {
  print(i)
  try(remove(tbl))
  if(!file.exists(paste0("./inv/",InvID[i],".csv"))){
    print("File does not exist. Making a new file.")
    try(tbl<- readHTMLTable(InvWebsite[i], which=1, stringsAsFactors = FALSE))
    try(write.csv(tbl, paste0("./inv/",InvID[i],".csv")))
    if(file.exists(paste0("./inv/",InvID[i],".csv"))){
      print("Success!")
    }
    else {print("Failed to create csv")
    }
  }else{print("File already exists, skipping to the next file.")}
}


lapply(1:7032,get.html)



get.html2 <- function(i) {
  print(i)
  try(remove(tbl))
  if(!file.exists(paste0("./acc/",AccID[i],".csv"))){
    print("File does not exist. Making a new file.")
    try(tbl<- readHTMLTable(AccWebsite[i], which=1, stringsAsFactors = FALSE))
    try(write.csv(tbl, paste0("./acc/",AccID[i],".csv")))
    if(file.exists(paste0("./acc/",AccID[i],".csv"))){
      print("Success!")
    }
    else {print("Failed to create csv")
    }
  }else{print("File already exists, skipping to the next file.")}
}


lapply(1:196,get.html2)

#tbl<- readHTMLTable("http://www.seed-db.com/investorgraph/investorview?investorid=4903702712287232", which=1)

setwd("~/GitHub/extractHTML/")
ls<-list.files("./csv/")
# dat<-read.csv(ls[10], header = TRUE)
# sum(as.numeric(gsub(",", "",dat[,4])))
# mean(as.numeric(gsub(",", "",dat[,4])))
# median(as.numeric(gsub(",", "",dat[,4])))
# nrow(dat)
# dat[,4]
# dat$Funding.roundsize....

# df[1,1]<-gsub(".csv","",ls[1])
# df[1,2]<-sum(as.numeric(gsub(",", "",dat[,4])))
# df[1,3]<-nrow(dat)
# df[1,4]<-mean(as.numeric(gsub(",", "",dat[,4])))
# df[1,5]<-median(as.numeric(gsub(",", "",dat[,4])))
# 
# ls<-list.files(pattern = "csv")
# 
# dat<-read.csv(ls[100])


#identify and count duplicates
df2<-data.frame(df2)
colnames(df2)<-colnames(df)

df3<-rbind(df, df2)

df3

NameCount <- data.frame(table(df3$InvName))
dups<-NameCount[NameCount$Freq > 1,]
dups<-dups[order(-dups$Freq),]
#initialize dataframe
df4<- data.frame(rep(NA,10), rep(NA,10))

# cr8df<-function(i){
#   df4[i,1]<-as.character(dups$Var1[i])
#   df4[i,2]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[1]
#   df4[i,3]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[2]
#   df4[i,4]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[3]
#   df4[i,5]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[4]
#   df4[i,6]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[5]
#   df4[i,7]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[6]
#   df4[i,8]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[7]  
#   print(i)
# }
# lapply(1:739,cr8df)

#Change df4 names
names(df4)[1]<-"InvName"
for(i in 1:7){
names(df4)[1+i]<-paste0("InvID",i)
}

#For some reason the apply method did not work all the way through
#I did it with a loop
for(i in 1:739){
  df4[i,1]<-as.character(dups$Var1[i])
  df4[i,2]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[1]
  df4[i,3]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[2]
  df4[i,4]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[3]
  df4[i,5]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[4]
  df4[i,6]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[5]
  df4[i,7]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[6]
  df4[i,8]<-as.vector(df3[which(df3$InvName==dups$Var1[i]),]$InvID)[7]  
  print(i)
}
#now I add csv to all ID values
for(i in 1:739){
  
  print(i)
  df4[i,-1][which(!is.na(df4[i,-1]))]<-paste0(df4[i,-1][which(!is.na(df4[i,-1]))],".csv")
  
}


setwd("./invacc")
getwd()

write.csv(df4, file="dups.csv")

setwd("./invacc")

df4$InvName[124]<-"blisce"

for (i in 1:739){
files<-df4[i,-1]
files<-files[!is.na(files)]
files<-files[file.size(files)>5]
files<-files[!is.na(files)]
df_list <- lapply(files, function(x) {
  if (file.size(x) > 5) {
    read.csv(x, skip=1, header=FALSE)
  }
})

write.csv(do.call(rbind,df_list), file = paste0("../dups/",df4$InvName[i],".csv"))
print(i)
}
df4$InvName[124]
#remove IDs with the same InvName
!(df3$InvName %in% dups$Var1)
df5<-df3[!(df3$InvName %in% dups$Var1),]

#Get stats from csvs in dups folder
#Turn df5 InvIDs into csv file names & use get stats from invacc
setwd("..")
ls<-list.files("./dups/")

#The loop below fails whenever there are missing values
#This generates lots of NAs in df7

#initialize dataframe
df7<- data.frame(rep(NA,10), rep(NA,10), rep(NA,10), rep(NA,10), rep(NA,10))
names(df7)<-c("Name","TotalInvestment", "NumberOfInvestments", "Mean", "Median")

for(i in 1:length(ls)){
  try(remove(dat))
  try(dat<-read.csv(paste0("./dups/",ls[i])))
  print(ls[i])
  df7[i,1]<-gsub(".csv","",ls[i])
  if(exists("dat")){
    df7[i,2]<-sum(as.numeric(gsub(",", "",dat[,5])))
    df7[i,3]<-nrow(dat)
    df7[i,4]<-mean(as.numeric(gsub(",", "",dat[,5])))
    df7[i,5]<-median(as.numeric(gsub(",", "",dat[,5])))
  }
}

# ls<-list.files("./csv/")
# ls<-gsub(".csv", "", ls)
# difs <- setdiff(InvName2,ls)
# uniq<-unique(InvName)
# difs <- setdiff(ls, InvName2)
# 
# '%nin%' <- Negate('%in%')
# 
# difs<-InvName2[InvName2 %nin% ls]
# 
# 
# max(df$TotalInvestment, na.rm=TRUE)
# #copy df, just in case
df3<-merge(df2,websites,by="Investor")
df3<-df3[,-6]

write.csv(df3,"../SeedDBinvestors.csv")
#pull.stats <- function(i)

#lapply(1:10,pull.stats)


#Command+Shift+c to comment out multiple selected lines
# install.packages("RCurl")
# library(RCurl)
# get.html <- function(i) {
#   print(i)
#   investor<-as.character(inv[i,1])
#   investorid<-inv[i,2]
#   url<-as.character(inv[i,3])
#   urldata <- getURL(url)
#   tbl<- readHTMLTable(urldata, stringsAsFactors = FALSE)
#   write.csv(tbl, paste0(investor,".csv"))
# }


# library(XML)
# url<-"https://www.linkedin.com/search/results/people/?facetPastCompany=%5B%221068%22%2C%221382%22%5D&keywords=Goldman%20Sachs&origin=FACETED_SEARCH&page=3"
# tbl<- readHTMLTable(url, which=1, stringsAsFactors = FALSE)
# download.file(url, destfile = "data.htm", method="auto")
# list.files()
# getwd()

