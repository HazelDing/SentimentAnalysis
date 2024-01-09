# Sentiment Analysis
I. Project Review:

Sentiment analysis is a natural language processing technique used to determine whether data is positive, negative, or neutral. Sentiment analysis is often performed on textual data to help businesses monitor brand and product sentiment in customer feedback and understand customer needs. The project is devided into two parts: part one conducts data analysis using R, and part two fits machine learning models and analyzes why the models make false prdictions as well. 

II. Project Sections:

Part One: data analysis using R

Part Two: Machine Learning models

a. Random Forest Classification

b. Naive Bayes Classifier

III. Conclusion:

Naïve Bayes Classifier has higher accuracy of 82.94% than Random Forest. Therefore, we concluded that Naïve Bayes Classifier was the optimal model to make prediction of polarity for text data compared to the performance of Random Forest model. During the training process, we want to dig deep into the root causes why models make wrong predictions.

Five Assumptions that why models make false predictions:

1. Negative wording
   
2. Some special meaning of words
   
3. Multiple interpretations of words
   
4. Contrast and contradiction situations
   
5. Ambiguous expressions

IV. Business Insights:

1. The dataset contains reviews of different topics, such as, food, movies, phone, headset, and other products.
2. The frequent occurrence of positive terms such as "phone," "food," and "service," as well as the prevalence of negative expressions like "bad," "worst," and "disappointed," serves as valuable indicators for investigating product and service quality. These commonly used words not only offer insights into customer sentiments but also pinpoint specific areas that may necessitate attention or improvement.
3. The overall sentiment scores are positive using bing et al and NRC functions despite that the number of negative reviews is more than positive reviews in the dataset.
   
V. Recommendations

1. Identify specific instances or areas where negative words like "bad," "disappointed," and "worse" are mentioned. Address these concerns promptly and work towards improvements. 
2. Consider implementing a customer loyalty program or offering incentives for customers who leave positive reviews. This can encourage more satisfied customers to share their positive experiences.
3. Keep an eye on reviews of competitors in the same industry. Understanding what customers appreciate or dislike about similar products/services can provide insights for differentiation and improvement.

VI. Visualization

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/77fe6d56-a337-4b6f-9c91-9612b83166de)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/1bfd1c54-723c-4af5-89ad-b5192fe73e4c)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/5cce46e0-f685-4055-bfb1-e925ad508432)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/aec4b447-3f3d-41a5-b3a3-8c2e3bc446f9)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/cf582a20-826b-4b19-a84d-1db253971ae3)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/22b16c29-468e-4d4e-b3fd-0c4e57647158)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/dfbbcd51-3d2f-4872-b341-e381fff55c31)

![image](https://github.com/HazelDing/SentimentAnalysis/assets/149340952/440f011c-18d5-4e8b-91e7-97d5a59d88db)











