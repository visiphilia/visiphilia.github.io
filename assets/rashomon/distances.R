library(ggplot2)

d <- read.csv("distances.csv", stringsAsFactor=FALSE)
d <- read.csv("distances-new.csv", stringsAsFactor=FALSE)
d <- read.csv("Rashomon/distances-new.csv", stringsAsFactor=FALSE)
d <- read.csv("Rashomon/distances-new-tweak.csv", stringsAsFactor=FALSE)
# Make into a matrix
d <- rbind(d,d)
for (i in 1:(nrow(d)/2)) {
  d$V1[i+nrow(d)/2] <- d$V2[i]
  d$V2[i+nrow(d)/2] <- d$V1[i]
}
   
qplot(V1, V2, data=d, fill=d, geom="tile") + theme_bw() + 
  theme(aspect.ratio=1)
qplot(V1, V2, data=d, fill=d, geom="tile", alpha=I(0.5)) + geom_text(aes(label=d)) +
  theme_bw() + 
  theme(aspect.ratio=1)
qplot(V1, V2, data=d, geom="text", label=d) + theme_bw() + 
  theme(aspect.ratio=1)

d <- d[order(d$V1,d$V2),]
dm <- matrix(NA, 21, 21)
rownames(dm) <- sort(unique(d$V1))
colnames(dm) <- sort(unique(d$V1))
k <- 0
for (i in 1:21) 
  for (j in 1:21) {
    if (i != j) {
    k <- k+1
    dm[i,j] <- d[k,3]
    }
  }
#dm[as.numeric(d$V1), as.numeric(d$V2)] <- d[,3]
diag(dm) <- 0
d.mds <- cmdscale(dm, k=3)
write.csv(d.mds, file="mds.csv")

# Check results, look at which distancs are most mismatched
d.mds.d <- dist(d.mds)
d <- read.csv("Rashomon/distances-new-tweak.csv", stringsAsFactor=FALSE)
library(dplyr)
d <- arrange(d, V1, V2)
dif <- as.numeric(d[,3]-d.mds.d)
qplot(dif, geom="histogram")
d[which(dif< (-60)),]
dif[which(dif< (-60))]
d[which(dif>50),]
dif[which(dif>50))]
# Surprisingly it is MNU, and then to P!! So should be ok
