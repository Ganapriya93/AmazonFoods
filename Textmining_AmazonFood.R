reviews<-read.csv("Reviews.csv")
install.packages("tm")
library(tm)
corpus<-Corpus(VectorSource(reviews$Text))
corpus<-tm_map(corpus,tolower)
corpus[[1]]
corpus<-tm_map(corpus,removePunctuation)
corpus[[1]]
corpus<-tm_map(corpus,removeWords,c(stopwords('english')))
corpus[[1]]
corpus<-tm_map(corpus,stripWhitespace)
#stemming
corpus<-tm_map(corpus, stemDocument)
#install.packages("SnowballC")
#document matrix
#convertin to text docs
corpus<-tm_map(corpus,PlainTextDocument)
frequencies<-DocumentTermMatrix(corpus)
frequencies

#remove sparse terms - freq<3
sparse<-removeSparseTerms(frequencies,1-3/nrow(frequencies))
#docs and terms
dim(sparse)
class(sparse)
subset<-sparse[,1:5000]

#freq of 1st 5000 terms in corpus
freq<-colSums(as.matrix(subset))
length(freq)

ord<-order(freq,decreasing = TRUE)
ord

m<-as.matrix(subset)
write.csv(m,file='matrix.csv')

#most and least freq words
freq[head(ord)]
freq[tail(ord)]

#word cloud
library(wordcloud)
set.seed(100)
wordcloud(names(freq),freq = freq,max.words = 5000,scale=c(6,.1),colors=brewer.pal(6,'Dark2'))

#remove numbers, ignore words upto length 4, include all columns instead of 5000