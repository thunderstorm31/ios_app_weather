
# How to run

* All the required files except the `Keys.plist` (see next step) are in the zip. You can also install the code by checking out `https://github.com/thunderstorm31/ios_app_weather`  
* in the folder `Weather/Supporting Files` a plist named `Keys.plist` should be added, the root object should be a dictionary ([String: String] type) and it should contain the key `openWeatherAppId`with the value for your open weather app id. 
* Update the team settings and choose another app identifier if you want to run the app on a real device
* There is one external depedency used in this app (swiftlint, a tool to enforce code styling/rules). The source is already packaged in the zip and the git repo.
* Open the `Weather.xcworkspace` workspace, select the target `Weather` and the relevant device or simulator and press run (cmd+r)

# Notes
* I could not find `rain chances` anywhere in the today data so this is not displayed in the app.
* I did not use any of the icons from open weather, I used SF symbols since they scale properly, also it was fun to try it out for an app since often I have to support iOS 9 andhigher
* Cities are not loaded from remote but from an embedded json, better solution might have been to store them in a database which could be updated with remote data. But I did not feel like this was a requirement for the assignment. 
* Some info about code in the `framework candidations` folder
  * Core Logic and Core UI is code from some of my own private libraries, did add some of that code since it makes my work way easier but did not write the code new for this project
  * Open weather code is newly written code, normally I would have put this in a pod/external framework
* I'm not a 100% happy with the design, but I will be honest I'm a developer, I can do some basics but advanced UI designing is not my expertise, like picking the exact nice colors for something. 
  For this I decided to stick with default apple provided colors   
