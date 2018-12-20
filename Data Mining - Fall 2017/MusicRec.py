import pandas as pd
train = pd.read_csv('/Users/meng/Documents/DM/kaggle/train.csv')
train_x = train.iloc[:,0:5]
# replace NA values with mode of a DataFrame column
for column in train_x.columns:
    train_x[column].fillna(train_x[column].mode()[0], inplace=True)

test_x = pd.read_csv('/Users/meng/Documents/DM/kaggle/test.csv')
# replace NA values with mode of a DataFrame column
for column in test_x.columns:
    test_x[column].fillna(test_x[column].mode()[0], inplace=True)

x = pd.concat([train_x,test_x.iloc[:,1:6]],axis = 0)
# chage string to categorical variables
import pandas as pd
x_encode = pd.concat([x['msno'].astype('category').cat.codes.to_frame(name='msno'),
                      x['song_id'].astype('category').cat.codes.to_frame(name='song_id'),
                      pd.get_dummies(x['source_system_tab'],prefix='sst'),
                      pd.get_dummies(x['source_screen_name'],prefix='ssn'),
                      pd.get_dummies(x['source_type'],prefix='st')],axis = 1)
train_x_encode = x_encode.iloc[0:7377418,:]
test_x_encode = x_encode.iloc[7377418:9934208,:]

#SVM model: costs too much time
from sklearn.svm import SVC
clf = SVC()
clf.fit(train_x_encode, train.iloc[:,5])
pred = clf.predict_proba(test_x_encode)
result = pd.concat([test_x['id'],pd.DataFrame(pred[:,1], columns = ['target'])],axis = 1)
result.to_csv('submit_svm.csv',index = False)