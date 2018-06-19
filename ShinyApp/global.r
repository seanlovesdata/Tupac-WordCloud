#install.packages("tm")
#install.packages("wordcloud")
#install.packages("memoise")

library(tm)
library(wordcloud)
library(memoise)

# The list of valid books
books <<- list("2Pacalypse Now" = "2PacalypseNowFull",
               "All Eyez On Me" = "AllEyezOnMeFull",
               "Makaveli - The Don Killuminati: The 7 Day theory" = "7DayTheoryFull",
               "Strictly 4 My Niggas" = "Strictly4MyNiggasFull",
               "Thug Life" = "ThugLifeFull",
               "All Albums" = "StudioAlbumsCombinedClean")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(book %in% books))
    stop("Unknown book")

  text <- readLines(sprintf("./%s.txt", book),
    encoding="UTF-8")

  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
         c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))

  myDTM = TermDocumentMatrix(myCorpus,
              control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

