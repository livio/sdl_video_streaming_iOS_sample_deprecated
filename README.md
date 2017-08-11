# Directions for Building
1. After downloading the project, navigate to the root of the project and install the SDL SDK for iOS by running `pod install` in the terminal (For more information about CocoaPods view our [installation instructions](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/)).
1. Connections to the SDL Core can be made via TCP or iAP. The app is setup to do both. Switch between connection types in the `AppDelegate` class.
1. If connecting via iAP make sure that background capabilities is enabled and that the SDL Protocol strings have been added to the app (For more information view our [SDK Configuration instructions](https://smartdevicelink.com/en/guides/iOS/getting-started/sdk-configuration/)).   
1. The video will only start playing on the SDL Core HMI when the **play** button is selected on the device app. If desired, the video can be played right at startup in the `setupPlayer()` method of the `HomeViewController` class.

# Changing the Video
1. Drag the video into the project 
1. The video must be added to **Bundle Resources**. Go to **Build Phases** -> **Copy Bundle Resources** and click on the plus sign icon. A dialog box will show up. Navigate to where the video is located and click on the video file.
1. If video streaming is lagging, the video may be too large and may need to be compressed.

# Notes
- This app is for testing porposes only.
- Touch events are not used in this app.
- This app streams a local video file. Setup will be different if streaming directly from the iOS device's camera (This is not handled in the example).
- Video use in project is sourced from [https://videos.pexels.com](https://videos.pexels.com). The video is licensed under the [Creative Commons Zero (CC0) license](https://videos.pexels.com/video-license).
