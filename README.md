# twitterClient

This is a simple app that emulates a Twitter front end.
Core Data is used in lieu of a actual remote backend although the notion of 
network calls is maintained through some of the messages presented to the user 
as a result of error conditions and in some of the values returned from the "backend".

The app is composed of a few UIViewControllers that encapsulate the front end 
features that are required for this exercise. Data is managed through the 
DataManager object. This is a Singleton that handles all communication between 
Core Data and NSUserDefaults. It has a simple interface that accommodates all 
CRUD related functionality required by the app. It also contains a few methods that 
exist only for the purposes of testing. 

There is also a small extension (DateExtensions.swift) that contains a few methods 
which extend the NSDate to facilitate translating NSDate objects to Strings and Strings
to NSDate objects.

At launch of the app the AppDelegate sets UINavigationBar appearance for the app and 
checks to see if this is the first time that app has been launched, using a value 
stored in NSUserDefaults. If it is the first launch some initial data is loaded into 
Core Data via a few JSON files. This data consists of user information and a set of tweets belonging 
to that user. There is currently only one user loaded but the app can support others.

The user is presented with a login view, (LoginViewController). Here they are able to 
enter their username and password and attempt to login. In the spirit of this being a 
networked app there is a "Reachability" check to ensure that the user has a network 
connection. If the user doesn't have a network connection they are presented with an 
Alert message informing them of this. There is also error handling for the input of 
incorrect credentials. 

Once the user has successfully logged in they are presented with the 
ViewTweetsViewController. This view uses the DataManager to retrieve all tweets 
from Core Data that are in the logged in user's "feed". This is done in viewDidLoad().
In viewWillAppear() all new tweets are retrieved from Core Data and added to the 
list of presented tweets. The tweets are presented in a UITableView and are sorted 
so that the most recent ones are at the top of the table. The table view contains a 
custom UITableViewCell (TweetCell). In cellForRowAtIndexPath() a cell is dequeued and then handed 
the data that it needs to populate it's views. In the navigation bar of the ViewTweetsViewController 
there are two buttons, one to allow the user to add a new tweet and another to allow the user
to log out of the app. Logging out brings the user back to the login view and deletes the value in 
NSUserDefaults used to track the current user. The add new tweet button presents a modal view 
that allows the user to enter a new tweet.

When the user is selects the add tweet button they are presented with a simple UI that 
allows them to enter a new tweet. There is also a button that allows them to cancel out of the 
view. The AddTweetViewController implements the UITextViewDelegate and implements the 
textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String)
function to ensure that the tweet the user enters does not exceed 140 characters. 
Once the user selects the "tweet" button the new tweet is added to Core Data, (marking it as a "new" 
tweet) and the view is dismissed. Upon dismissal the user is presented with the View Tweets view 
and the new tweet is included at the top of the list of tweets.

I wrote a small set of tests for this app. They test the DataManager's interface to ensure that it is 
functioning as expected. I implemented a simple error handling scheme which presents the user with messages 
should an error in the DataManager be encountered. 

The governing principal I tried to adhere to when writing this app, as I do in all the code I write, is to implement 
the simplest thing that will work. I also took the notions of object responsibility and encapsulation into consideration. 


