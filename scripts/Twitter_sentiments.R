library(tidyverse)
library(tidytext)
library(twitteR)
library(textdata)

fn_twitter <- searchTwitter("#coronavirus",n=1000,lang="en")

fn_twitter_df <- twListToDF(fn_twitter) # Convert to data frame


tweet_words <- fn_twitter_df %>% select(id, text) %>% unnest_tokens(word,text)

# Create a list of stop words: a list of words that are not worth including

my_stop_words <- stop_words %>% select(-lexicon) %>% 
        bind_rows(data.frame(word = c("https", "t.co", "rt", "amp","4yig9gzh5t","fyy2ceydhi","78","fakenews")))

tweet_words_interesting <- tweet_words %>% anti_join(my_stop_words)

tweet_words_interesting %>% group_by(word) %>% tally(sort=TRUE) %>% slice(1:25) %>% ggplot(aes(x = reorder(word, n, function(n) -n), y = n)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + xlab("")
bing_lex <- get_sentiments("nrc")

fn_sentiment <- tweet_words_interesting %>% left_join(bing_lex)

sentimentTable <- fn_sentiment %>% filter(!is.na(sentiment)) %>% group_by(sentiment) %>% summarise(n=n()) %>% arrange(desc(n))

## Plot the most common sentiments in 1000 tweets with hashtag #coronavirus

gSentiment <- ggplot(sentimentTable, aes(sentiment, n))
histSentimentTwitter <- gSentiment + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 60, hjust = 1), plot.title = element_text(hjust = 0.5)) + xlab("") + ggtitle("Twitter #coronavirus Sentiments")

png(filename = "~/R/Covid_19/Covid_19/graphs/histSentimentTwitter.png")
histSentimentTwitter
dev.off()

knitr::kable(sentimentTable)

# source("Twitter_sentiments.R", echo = TRUE)
