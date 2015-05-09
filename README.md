# Colissimo Tracker #

Colissimo Tracker is a very simple app to track the delivery of a package with Colissimo (a french post service).
This is the first app I developed using the TDD approach, after reading [Test-Driven iOS Development](http://www.amazon.com/Test-Driven-iOS-Development-Developers-Library/dp/0321774183) written by Graham Lee.

### What is this repository for? ###

My goal is to share an example of how an iOS app can be unit tested. I do not plan to maintain this repository, so the API used in the project could not work anymore by the time.

### How do I get set up? ###

Just download the project, open it and launch the tests (Product > Test or Cmd+U).
If you want to use it for your own tracking ID, change the **tracking ID** in the **TrackerTableViewController.m** file, at **line 37** and you're good to go.

### Credits ###

I've used an [unofficial API](http://api.ntag.fr/colissimo/doc.php) to support Colissimo tracking, developed by [Basile Bruneau](http://www.ntag.fr). Thanks to him.