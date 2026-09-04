# Installing packages in R
  install.packages("ggplot2") 

# R tutorial
 Add "day of the week" column to your data with date:
 Let the data be tran and `tran$Date` is is date format (possibilities)
```
 tran$day <- weekdays(as.Date(tran$Date))
```

 Order your data by day of the week like this: (data is daily, day is DoW)
```
 daily$DoW <- factor(daily$DoW, levels= c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
 daily[order(daily$DoW), ]
```

 Plot frequency distribution of days of the week 
```
 barplot(table(tran$day))
```

 Create a sequence of weekdays, starting from today's day like this:
 Get today's date
 t <- Sys.Date()
 Create a sequence of 7 days by: adjust t+const to fix the starting day
 dayseq <- weekdays(seq.Date(t,t+6,by=1))
 Get the corresponding weekday value by
 weekdays(dayseq)
 or,
 daynames <- weekdays(dayseq, abbreviate=TRUE)

 Lesson Learned: IF you have a data with a variable name Category, and Catergoy can be either Grocery, Shopping or Travel, then first convert the variable into a factor using: data$Category <- factor(data$Category)
 Then you can use levels(data$Category) to see a vector with only 3 vars. You can change the factor data$Category the way you change a vector.

 The problem is to edit an entry in the data frame which is a category type. For example, if you want to change data[4,"Category"] to "hello", you cannot change it using data[4,"Category"] <- "hello" !!!
 Here is what to do:
 Change the type of Category varaible to character using:
 data$Category <- as.character(data$Category)
 Edit the value:
 data[4,"Category"] <- "hello"
 Change the variable type back to factor:
 data$Category <- factor(data$Category)

 So annoying!
 
 qqplot2 help:
 A line plot :
 qplot(x=Date, y=Amount, data=tran, geom=c('point','line'), color=Category, alpha = I(0.7))

 The following prints number of times we did grocery, shopping etc w.r.t. date
 qplot(factor(timeS), data=tran, geom="bar", fill=factor(Category))

 The following prints two side by side maps for each user. Each picture contains the count of grocer, Shopping and travel represented by different colors. The x-axis is time span.
 ggplot(tran, aes(timeS, fill=Category)) + geom_bar() + facet_wrap(~ User) 

 A slight invariant:
 ggplot(tran, aes(timeS, fill=User)) + geom_bar() + facet_wrap(~ Category)

 stat='identity' is the option that lets you plot y vs x instead of the defualt statistics count.

 Plot amount vs date/timeS, stacked with category
 ggplot(tran) + geom_bar(aes(timeS, Amount, fill=Category), stat='identity')

 Withe separate user:
 ggplot(tran) + geom_bar(aes(timeS, Amount, fill=Category), stat='identity') + facet_wrap(~ User)
 
 Seperate picture by category, both users in the same picture, 2rows of pictures
 ggplot(tran) + geom_bar(aes(x=timeS, y=Amount, fill=User), stat='identity') + facet_wrap(~ Category, nrow = 2)
 
 Facet_wrat w.r.t User of all categories with a greyscale of total amount of both users in the background
 ggplot(tran) + geom_bar(aes(timeS, Amount, fill=Category), stat='identity') + geom_bar(data=transform(tran, User=NULL), aes(x=timeS, y=Amount), stat='identity', alpha=I(0.2)) + facet_wrap(~User)

 To have a picture in the background of every facet, we need to create a facet without the facet variable. For example, in the previous case, transform(tran, User=NULL) gives you a data without the facet variable ~User. We plot a bar geometry of this data.
 
 Alternate representation with Category and User interchanged
  ggplot(tran) + geom_bar(aes(timeS, Amount, fill=User), stat='identity') + geom_bar(data=transform(tran, Category=NULL), aes(x=timeS, y=Amount), stat='identity', alpha=I(0.2)) + facet_wrap(~Category)
  
 In this context, manysum is nothing but
 ggplot(tran) + geom_bar(aes(timeS, Amount, fill=User), stat='identity')


