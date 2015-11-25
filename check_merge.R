


# R script to analyse the results of VCF merging

setwd("/media/hannes/2nd/Podi_trans/SNP_calling")

data <- read.table("test", sep = "\t", header = F)

length(which(data$V26 == "ooiiii"))

length(which(data$V26 == "iiooii"))

length(which(data$V26 == "ooooii"))

length(which(data$V26 == "ioioii"))

length(which(data$V26 == "iooiii"))

length(which(data$V26 == "oiioii"))

length(which(data$V26 == "oioiii"))
head(data)


digitsum <- function(x) sum(floor(x / 10^(0:(nchar(x) - 1))) %% 10)

a <- sapply(data$V26, function(x) digitsum(as.numeric(x)))
dim(data)
length(a)
barplot(table(a))

str(data)


require(combinat)
?permn

b <- permn(c("i", "i", "i", "o", "o", "o"))
#paste(b[[1]], collapse = "")
#?unlist
c <- sapply (b, function(x) paste(x, collapse = ""))
d <- unique(c)

e <- sapply(1:length(d), function(x) c(d[x], length(which(data$V26 == d[x]))))

barplot(as.numeric(e[2,]), names = e[1,])

