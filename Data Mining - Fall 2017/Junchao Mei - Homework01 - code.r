# import libraries
library(ggplot2)
library(MASS)
library(locfit)

# load data
data.file = 'H:/Data_Mining/HW1/DirectMarketing.csv'
data.file_new = 'H:/Data_Mining/HW1/DirectMarketing_new.csv'
dm <- read.csv(data.file, header=TRUE, sep=',')
dm_new <- read.csv(data.file_new, header=TRUE, sep=',')
dm[1:3,]
class(dm)
dim(dm)
dim(dm_new)

# 2(a)
any(is.na(dm))
##dm_new1 <- na.omit(dm)
##any(is.na(dm_new1))
##dim(dm_new1)
any(is.na(dm_new))

# 2(b)
summary(dm)
sd(dm$Salary); sd(dm$Children);sd(dm$Catalogs); sd(dm$AmountSpent)

# 2(c)
ggplot(dm, aes(x=AmountSpent)) + geom_density() + labs(title = "Density Plot of [AmountSpent]")
ggplot(dm, aes(x=Salary)) + geom_density() + labs(title = "Density Plot of [Salary]")

# 2(d)
cor(dm$Salary, dm$AmountSpent)
cor(dm$Children, dm$AmountSpent)
cor(dm$Catalogs, dm$AmountSpent)
ggplot(dm, aes(x=Salary, y=AmountSpent)) + geom_point() + labs(title = "Scatter Plot of [AmountSpent~Salary]")
ggplot(dm, aes(x=Children, y=AmountSpent)) + geom_point() + labs(title = "Scatter Plot of [AmountSpent~Children]")
ggplot(dm, aes(x=Catalogs, y=AmountSpent)) + geom_point() + labs(title = "Scatter Plot of [AmountSpent~Catalogs]")

# 2(e)
#cdplot(dm$Age ~ dm$AmountSpent, dm=3)
ggplot(dm, aes(x=AmountSpent, fill=Age)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Age]")
ggplot(dm, aes(x=AmountSpent, fill=Gender)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Gender]")
ggplot(dm, aes(x=AmountSpent, fill=OwnHome)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~OwnHome]")
ggplot(dm, aes(x=AmountSpent, fill=Married)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Married]")
ggplot(dm, aes(x=AmountSpent, fill=Location)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Location]")
ggplot(dm, aes(x=AmountSpent, fill=History)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~History]")
ggplot(dm, aes(x=AmountSpent, fill=Children_)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Children_]")
ggplot(dm, aes(x=AmountSpent, fill=Catalogs_)) + geom_density(alpha=.2) + labs(title = "Conditional Density Plot of [AmountSpent~Catalogs_]")

# 2(f)
#Age (Yes, significantly different means)
mean(dm_new[which(dm_new$Age=='Middle'),]$AmountSpent)
mean(dm_new[which(dm_new$Age=='Young'),]$AmountSpent)
mean(dm_new[which(dm_new$Age=='Old'),]$AmountSpent)
#Gender (No)
mean(dm_new[which(dm_new$Gender=='Male'),]$AmountSpent)
mean(dm_new[which(dm_new$Gender=='Female'),]$AmountSpent)
#OwnHome (Yes)
mean(dm_new[which(dm_new$OwnHome=='Own'),]$AmountSpent)
mean(dm_new[which(dm_new$OwnHome=='Rent'),]$AmountSpent)
#Married (Yes)
mean(dm_new[which(dm_new$Married=='Married'),]$AmountSpent)
mean(dm_new[which(dm_new$Married=='Single'),]$AmountSpent)
#Location (No)
mean(dm_new[which(dm_new$Location=='Close'),]$AmountSpent)
mean(dm_new[which(dm_new$Location=='Far'),]$AmountSpent)
#History (Yes)
mean(dm_new[which(dm_new$History=='None'),]$AmountSpent)
mean(dm_new[which(dm_new$History=='Low'),]$AmountSpent)
mean(dm_new[which(dm_new$History=='Medium'),]$AmountSpent)
mean(dm_new[which(dm_new$History=='High'),]$AmountSpent)
#Children (No)
mean(dm_new[which(dm_new$Children_=='zero'),]$AmountSpent)
mean(dm_new[which(dm_new$Children_=='one'),]$AmountSpent)
mean(dm_new[which(dm_new$Children_=='two'),]$AmountSpent)
mean(dm_new[which(dm_new$Children_=='three'),]$AmountSpent)
#Catalogs_ (Yes)
mean(dm_new[which(dm_new$Catalogs_=='six'),]$AmountSpent)
mean(dm_new[which(dm_new$Catalogs_=='twelve'),]$AmountSpent)
mean(dm_new[which(dm_new$Catalogs_=='eighteen'),]$AmountSpent)
mean(dm_new[which(dm_new$Catalogs_=='twenty-four'),]$AmountSpent)

# 3(a)
fit = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+Salary+Children+History+Catalogs)
summary(fit)
mean.mse = mean((rep(mean(dm$AmountSpent),length(dm$AmountSpent)) - dm$AmountSpent)^2)
model.mse = mean(residuals(fit)^2)
rmse = sqrt(model.mse)
rmse
r2 = 1 - (model.mse / mean.mse)
r2

# 3(b)
#[linear]
fit_linear0 = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+Salary+Children+History+Catalogs)
summary(fit_linear0)
stepAIC(fit_linear0, direction="backward")
fit_linear = lm(data=dm, AmountSpent ~ Gender+Location+Salary+Children+History+Catalogs)
summary(fit_linear)
#leave-one-out cross-validation for out-of sample evaluation
n = length(dm$AmountSpent)
error = dim(n)
formula = AmountSpent ~ Gender+Location+Salary+Children+History+Catalogs
for (k in 1:n)
{
  train1 = c(1:n)
  train = train1[train1 != k]
  m2 = lm(formula, data = dm_new[train, ])
  pred = predict(m2, newdata = dm_new[-train, ]) 
  obs = dm_new$AmountSpent[-train]
  error[k] = obs - pred
}
rmse_linear = sqrt(mean(error^2))
rmse_linear
#[poly]
#(if consider interactive terms)#fit_poly0 = lm(data=dm, AmountSpent ~ polym(Salary,Children,Catalogs, degree=2, raw=TRUE))
#find optimal degrees
r2_Children = list()
for (i in 1:3)
{
  fit_poly0 = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+History+poly(Salary,degree=18)+poly(Children,degree=i)+poly(Catalogs,degree=3))
  r2_Children = c(r2_Children,summary(fit_poly0)$r.squared)
}
I = seq(1:3)
plot(I,r2_Children) #set degree of Children = 2
r2_Catalogs = list()
for (i in 1:3)
{
  fit_poly0 = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+History+poly(Salary,degree=18)+poly(Children,degree=2)+poly(Catalogs,degree=i))
  r2_Catalogs = c(r2_Catalogs,summary(fit_poly0)$r.squared)
}
I = seq(1:3)
plot(I,r2_Catalogs) #set degree of Catalogs = 2
r2_Salary = list()
for (i in 1:18)
{
  fit_poly0 = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+History+poly(Salary,degree=i)+poly(Children,degree=2)+poly(Catalogs,degree=2))
  r2_Salary = c(r2_Salary,summary(fit_poly0)$r.squared)
}
I = seq(1:18)
plot(I,r2_Salary) #set degree of Salary = 5
#polynomial fitting
fit_poly0 = lm(data=dm, AmountSpent ~ Age+Gender+OwnHome+Married+Location+History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2))
summary(fit_poly0)
stepAIC(fit_poly0, direction="backward")
fit_poly = lm(data=dm, AmountSpent ~ Location+History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2))
summary(fit_poly)
#leave-one-out cross-validation for out-of sample evaluation
n = length(dm$AmountSpent)
error = dim(n)
formula = AmountSpent ~ Location+History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2)
for (k in 1:n)
{
  train1 = c(1:n)
  train = train1[train1 != k]
  m2 = lm(formula, data = dm_new[train, ])
  pred = predict(m2, newdata = dm_new[-train, ]) 
  obs = dm_new$AmountSpent[-train]
  error[k] = obs - pred
}
rmse_poly = sqrt(mean(error^2))
rmse_poly

# 3(c)
fit = lm(data=dm, AmountSpent ~ Location+History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2))
fit_Location = lm(data=dm, AmountSpent ~ History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2))
AIC(fit_Location)-AIC(fit)
fit_History = lm(data=dm, AmountSpent ~ History+poly(Salary,degree=5)+poly(Children,degree=2)+poly(Catalogs,degree=2))
AIC(fit_History)-AIC(fit)
fit_Salary = lm(data=dm, AmountSpent ~ Location+History+poly(Children,degree=2)+poly(Catalogs,degree=2))
AIC(fit_Salary)-AIC(fit)
fit_Children = lm(data=dm, AmountSpent ~ Location+History+poly(Salary,degree=5)+poly(Catalogs,degree=2))
AIC(fit_Children)-AIC(fit)
fit_Catalogs = lm(data=dm, AmountSpent ~ Location+History+poly(Salary,degree=5)+poly(Children,degree=2))
AIC(fit_Catalogs)-AIC(fit)
