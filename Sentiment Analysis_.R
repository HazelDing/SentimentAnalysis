# Libraries #######################################################################
library(dplyr) #Data manipulation (also included in the tidyverse package)
library(tidytext) #Text mining
library(tidyr) #Spread, separate, unite, text mining (also included in the tidyverse package)
library(widyr) #Use for pairwise correlation
library(reshape2) # Turn the data frame into a matrix 
library(tokenizers)
library(stringr)

# Visualizations
library(ggplot2) #Visualizations (also included in the tidyverse package)
library(wordcloud) # Visualization words as cloud
library(ggraph)
library(igraph)

#Define some colors to use throughout
my_colors <- c("slategray","#4E79A7", "#F28E2B", "#76B7B2",  
               "#59A14F","#EDC948", "#B07AA1", 
               "#9C755F","#BAB0AC", "#6EB5FF",
               "seagreen","darkolivegreen")

# Data Cleaning #####################################################################
# Read dataset
df = read.csv(file.choose(), sep = ",")
head(df)

# Set up Random number seeds
set.seed(12345)
rpois(5,3)

# Check missing value
is.null(df)

# Remove numbers from sentence
df_clean <- df %>%
  mutate(Sentence = as.character(Sentence), # Convert to character
         Sentence = gsub("\\d", "", Sentence))

# Convert string from uppercase to lowercase
df_clean <- df_clean %>% 
  mutate(Sentence = tolower(Sentence))

head(df_clean)

# Get rid of all signs from sentences
df_clean$Sentence <- str_replace_all(df_clean$Sentence, "[^[:alnum:][:space:]]", "")
head(df_clean)


# Create tidy text format: Unnested, Stop words  
df_tidy <- df_clean %>% 
  mutate(Sentence = as.character(Sentence)) %>%
  unnest_tokens(word, Sentence) %>%
  anti_join(stop_words)

glimpse(df_tidy)
head(df_tidy)

# Count the number of negative and positive words

wordcounts <- df_tidy %>%
  group_by(Polarity) %>% 
  summarize(words = n()) 
  
wordcounts <- wordcounts %>%
  mutate(ratio = words / sum(words))

summary(wordcounts)

wordcounts

ggplot(wordcounts, aes(x = factor(Polarity), y = words, fill = factor(Polarity))) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = my_colors) +
  geom_text(aes(label= words, vjust = -0.4, hjust = 0.4)) +
  labs(title = "The Number of Positive and Negative Reviews",
       x = "Polarity",
       y = "Count")

# Display the most common used words
word_most = df_tidy %>% 
  count(word,sort=TRUE) %>% 
  slice_max(n = 10, order_by = n) %>%
  arrange(desc(n))
word_most

# plot bar chart
ggplot(word_most, aes(x = reorder(word,n), y = n, fill = word)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Most Common Words",
       x = "Word",
       y = "Count")+
  coord_flip()

# Positive polarity dataframe
df_pos <- df_tidy %>% 
  filter(Polarity == 1)
head(df_pos)

# Define the most common word in positive polarity
word_most_pos = df_pos %>% 
  count(word,sort=TRUE) %>% 
  slice_max(n = 10, order_by = n) %>%
  arrange(desc(n))
word_most_pos

ggplot(word_most_pos, aes(x = reorder(word,n), y = n, fill = word)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Most Common Words in Positive Polarity",
       x = "Word",
       y = "Count")+
  coord_flip()

# Negative polarity dataframe
df_neg <- df_tidy %>% 
  filter(Polarity == 0)
head(df_neg)

# Define the most common word in negative polarity
word_most_neg = df_neg %>% 
  count(word,sort=TRUE) %>% 
  slice_max(n = 10, order_by = n) %>%
  arrange(desc(n))
word_most_neg

ggplot(word_most_neg, aes(x = reorder(word,n), y = n, fill = word)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Most Common Words in Negative Polarity",
       x = "Word",
       y = "Count")+
  coord_flip()

# Calculate frequency of each word
frequency_df <- df_tidy %>%
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(word) %>%
  mutate(proportion = n / sum(n)) %>%
  select(word, proportion) %>% 
  arrange(desc(proportion)) %>% 
  slice_head(n = 10)
frequency_df

# Download df_tidy to check whether it's been cleaned
write.csv(df_tidy, "C:/Users/hazel/Downloads/review.csv", row.names = FALSE)

# Sentiment Analysis ####################################################################
# Top 10 joyful words
nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")

# Detect the top 10 joyful words and plot it
df_tidy %>%
  inner_join(nrc_joy) %>% # Use nrc_joy function
  count(word, sort = TRUE) %>% 
  slice_head(n=10) %>% 
  ggplot(aes(x = reorder(word, n), y = n, fill = word)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Joyful Words",
       x = "Words",
       y = "Frequency") +
  theme_minimal()

# Detect the different top 10 joyful words and plot it
df_tidy %>%
  inner_join(nrc_joy) %>%
  count(word, sort = FALSE) %>% # False meaning randomly select words by their order
  slice_head(n=10) %>% 
  ggplot(aes(x = reorder(word, n), y = n, fill = word)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Joyful Words Selected by Data Position",
       x = "Words",
       y = "Frequency") +
  theme_minimal()

# Calculate overall positive VS negative review
afinn <- df_tidy %>% 
  inner_join(get_sentiments("afinn")) %>% 
  group_by(index = row_number() %/% 9228) %>% 
  summarise(sentiment = sum(value)) %>% 
  mutate(method = "AFINN")
afinn

# Calculate net sentiment
bing_and_nrc <- bind_rows(
  df_tidy %>% 
    inner_join(get_sentiments("bing")) %>%
    mutate(method = "Bing et al."),
  df_tidy %>% 
    inner_join(get_sentiments("nrc") %>% 
                 filter(sentiment %in% c("positive", 
                                         "negative"))
    ) %>%
    mutate(method = "NRC")) %>%
  count(method, index = row_number() %/% 9228, sentiment) %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = 0) %>% 
  mutate(sentiment = positive - negative)
bing_and_nrc

# Get positive and negative words
bing_word_counts <- df_tidy %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

# Select top 10 sentimental words
bing_word_10 <- bing_word_counts %>% 
  slice_head(n=10)

# Plot top 10 sentimental words
ggplot(bing_word_10, aes(x=reorder(word, n), y= n, fill=sentiment))+
  geom_bar(stat = 'identity') +
  scale_fill_manual(values = my_colors) +
  labs(title = "Top 10 Most common positive and negative words",
       x = "Words",
       y = "Counts") +
  theme_minimal()

# Plot sentimental words by positive and negative
bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  scale_fill_manual(values = my_colors) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(title = "Most Common Negative and Positive Words")+
  labs(x = "Contribution to sentiment",
       y = NULL)

# Plot the most common words by wordcloud
df_tidy %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 50))

df_tidy %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("gray20", "gray80"),
                   max.words = 50)

# Tokenize text to sentences#################################################

# Tokenized sentences
df_sentence <- tibble(text = df_clean$Sentence) %>% 
  unnest_tokens(sentence, text, token = "sentences")
head(df_sentence)

# The most paired words
word_pairs <- df_tidy %>% 
  pairwise_count(word, Polarity, sort = TRUE) %>% 
  group_by(item1)
print(word_pairs,n= 50000)





  
  

