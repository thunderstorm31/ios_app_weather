
# How to run
* don't forget to update the team settings and choose another app identifier if you want to run the app on a real device

* in the folder `Weather/Supporting Files` a plist named `Keys.plist` should be added, the root object should be a dictionary ([String: String] type) and it should contain the key `openWeatherAppId`with the value for your open weather app id.  

# Notes
* I could not find `rain chances` anywhere in the today data so this is not displayed in the app.
* I did not use any of the icons from open weather, I used SF symbols since they scale properly
* Cities are not loaded from remote but from an embedded json, better solution might have been to store them in a database which could be updated
* The framework candidations folder
  * Core Logic and Core UI is code from some of my own private libraries, did add them since they make my work way easier but did not write the code new for this project
  * Open weather code is newly written code, normally I would have put this in a pod
