library(twitteR)
library(ROAuth)
library(XML)

# setup OAuth
consumer_key <- "7leSfmlaf2vJzFPJgXO7YUvLE"
consumer_secret <-"egFhhTWgPbuIXmf37dk9hfnbrPI4VnqzIcdCNy52ApZHKm7mS3"
Access_Token<-"4605707593-xlS8vOUyVqnXBdO0q9TzykugQHdXqIgkqiLU7rt"
Access_Token_Secret<-"OzB3qbeqTPLnQCkClTxRnM8BvJ1b8Gokxcdu7O3llw04X"

# configure RCurl options
RCurlOptions <- list(capath=system.file("CurlSSL", "cacert.pem", package = "RCurl"), ssl.verifypeer = FALSE)
options(RCurlOptions = RCurlOptions)

# setup twitter using Oauth
setup_twitter_oauth(consumer_key, consumer_secret,Access_Token,Access_Token_Secret)

# Retrieve 500 recent tweets for linkedin microsoft
tweet.collection <- searchTwitter("Eicher Motors", n=500)
length(tweet.collection)
save(tweet.collection, file="tweet.collection.RData")

#load("tweet.collection.RData")

# Explore tweet collection
class(tweet.collection)
length(tweet.collection) # actual number of retrieved tweets
str(tweet.collection)
head(tweet.collection, 2)
str(head(tweet.collection, 1))
length(tweet.collection)

# convert to data.frame
tweetFrame <- do.call("rbind", lapply(tweet.collection, as.data.frame))
head(tweetFrame)
str(tweetFrame)
summary(tweetFrame)
names(tweetFrame)
dim(tweetFrame)

# Convert to processable format
library(tm)

# Extract the text from tweets
tweet.corpus <- Corpus(VectorSource(tweetFrame$text))

tweet.corpus <- tm_map(tweet.corpus, PlainTextDocument)
#tweet.corpus[[10]]$content

# Perform different transformations 

toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})

## Convert to lower case
tweet.corpus <- tm_map(tweet.corpus, content_transformer(tolower))
tweet.corpus[[1]]$content


## Remove punctuations
tweet.corpus <- tm_map(tweet.corpus, removePunctuation)
tweet.corpus[[10]]$content
## Remove numbers
tweet.corpus <- tm_map(tweet.corpus, removeNumbers)
tweet.corpus[[10]]$content
## Remove URLs
removeURLs <- function(x) gsub("http[[:alnum:][:punct:]]*", "", x)
tweet.corpus <- tm_map(tweet.corpus, removeURLs)
tweet.corpus[[10]]$content

myStopWords <- stopwords('english')
## We can add stop words like, "internet" to the stopwords list
## myStopWords <- c(stopwords('english'), "internet")
## If required few words can be removed from the stopwords list
## myStopWords <- setdiff(myStopWords, c("internet"))
## remove stopwords from corpus
tweet.corpus <- tm_map(tweet.corpus, removeWords, myStopWords)
tweet.corpus[[10]]$content

save("tweet.corpus", file="Eicher.RData")
