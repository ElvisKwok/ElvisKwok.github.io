---
layout: post
title: KDD Cup 2015 Solution Report 
---

#{{ page.title }}  
<p class="meta">02 Mar 2016 - Guangzhou</p> 

---

#KDD Cup 2015 Solution Report

##1. Problem description

In KDD Cup 2015, we will predict students'  likelihood of dropout on XuetangX, one of the largest MOOC platforms in China. 

The goal of this competition is to predict the probability that whether a user will drop a course within next 10 days based on his or her prior activities. If a user C leaves no records for course C  in the log during the next 10 days, we define it as dropout from course C.

There are several data files given, including train data, test data, sampleSubmission.csv, object.csv  and date.csv. The train data consist of enrollment\_train.csv, log\_train.csv and truth\_train.csv. As to the test data, they include enrollment\_test.csv and log_test.csv.

With regard to the file enrollment\_train.csv, there are three attributes like Enrollment\_id, username and course\_id. Enrollment\_id is a unique ID corresponding to a combination of one student ID(USERNAME) and one course ID. And the file enrollment\_test.csv shares the same attributes as enrollment_train.csv.    

With regard to the file log\_train.csv, there are five attributes including enrollment\_id, time, source, event and object. The TIME indicates a particular operation’s time. The SOURCE indicates the operation’s source, which might be server or browser. The EVENT includes problem, video, access, wiki, discussion, navigate and page\_close. The OBJECT indicates which object to be operated.  And the file log\_test.csv shares the same attribute as log\_train.csv.

With regard to the truth\_train.csv, it provides us with the label of each train data, which indicates whether a user drop out a corresponding course.

With regard to the object.csv, this file’s attributes are course\_id, module\_id, category, children and start. The MODULE of a COURSE has some CATEGORIES, such about, problem, outline and so on. The MODULE is organized as a tree. That means a module may have other module as CHILDREN node. The START indicates when the module start.

With regard to the date.csv, it tells us the begin and end date of each specific course.

##2. Feature extracting

According to the data given and the problem, we finally extract 7 features for course dropout prediction as follows: LOG\_SUM, TIME\_DELTA, COURSE\_SUM\_EACH\_USER, USER\_SUM\_EACH\_COURSE, COURSE\_NOT\_QUIT\_RATIO, ACTIVE, EVENT\_WEIGHTED.

LOG\_SUM is a feature that shows how many times a ENROLLMENT\_ID is operated. This feature is really important, because we think if a user accesses a course, the user is more likely interested in that course. We got the score 0.83 only by using this feature.

TIME\_DELTA tells the time interval from the first operation to the last operation. From our perspective, if the time span is very small, the student is likely to drop out.

COURSE\_SUM\_EACH\_USER is a feature that calculates how many course a certain user selects.  We believe that a user would not  be likely to drop out if the user doesn’t select too little or too many courses.

USER\_SUM\_EACH\_COURSE indicates that how many students select the certain course. If a course is selected by many students, it denotes that this course is popular and interesting. We believe that students may not quit the course which this value is big.

COURSE\_NOT\_QUIT\_RATIO calculates the ratio that students will not drop out, as to a certain course.

ACTIVE is a feature that tells about whether a ENROLLMENT\_ID is active or not. We define the word active as the student has any record in the course during the last 7 days before the deadline of the course. If an ENROLLMENT\_ID is not active, we believe that it is probably to drop out.

EVENT\_WEIGHTED is a value that we calculate according to different event with different weight. The EVENT includes problem, video, access, wiki, discussion, navigate and page\_close. Weights we give to each event is as follows: 10, 9, 3, 4, 10, 2, 1. We think that different event has different importance. If a student figures out the course problem, watches video and participates in discussion frequently, we believe that this student is interested in the selected course. Weights we value is chose by experience and we get a fair good result by these weights after trying different values.

##3. Tools & Algorithm
 
This solution is implemented by the Python programming language.  Some useful tools are used, including scikit-learn, numpy and pandas.

scikit-learn  is an open source machine learning library for the Python programming language. It provides simple and efficient tools for data mining and data analysis. It features various classification, regression and clustering algorithms including support vector machines, logistic regression, naive Bayes, random forests, gradient boosting, k-means and DBSCAN, and is designed to interoperate with the Python numerical and scientific libraries NumPy and SciPy.

NumPy is the fundamental package for scientific computing with Python. It contains among other things, such as a powerful N-dimensional array object, sophisticated (broadcasting) functions, useful linear algebra, Fourier transform, and random number capabilities.

Pandas is a library providing high-performance, easy-to-use data structures and data analysis tools for the Python programming language. Pandas is a Python package providing fast, flexible, and expressive data structures designed to make working with “relational” or “labeled” data both easy and intuitive. It aims to be the fundamental high-level building block for doing practical, real world data analysis in Python. Additionally, it has the broader goal of becoming the most powerful and flexible open source data analysis / manipulation tool available in any language.

Apart from tools mentioned above, based on the analysis of this problem and experiment result, we choose Logistic Regression as the classification algorithm to predict the probability of dropout.  

Logistic regression, despite its name, is a linear model for classification rather than regression.  Logistic regression performs classification with generalized linear models. As for regression, the target value is expected to be a linear combination of the input variables. Logistic regression is also known in the literature as logit regression, maximum-entropy classification (MaxEnt) or the log-linear classifier. In this model, the probabilities describing the possible outcomes of a single trial are modeled using a logistic function.  The implementation of logistic regression in scikit-learn can be accessed from class LogisticRegression.   

Here we show the basic way to use logistic regression by using the library scikit-learn in our program. 
![img][1]

By importing the module of LogisticRegression, we can call the function LogisticRegression directly to generate a classifier. We train the classifier by giving the train data and the truth label provided. After training the classifier, we could use this classifier to predict the label of each item in test data.


##4. Result

The part of prediction result comes out as below. The first column is ENROLLMENT\_ID and the second column is the probability of drop out, predicted by our program.

![img][2]

The result of our solution is as below, we have tried 45 submissions and our best score is 0.8678479924461917.  The best score of this competition is 0.9091817339587759. 
[1]: /images/kdd_cup/1.png "example"
[2]: /images/kdd_cup/2.png "result"
