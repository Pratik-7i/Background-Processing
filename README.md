# Background Tasks

Apple introduced a new framework called `BackgroundTasks` for scheduling background work. This new framework does better support for tasks that are needed to be done in the background. There are two types of background tasks: `BGAppRefreshTask` and `BGProcessingTask`.

- `BGAppRefreshTask` is for short-duration tasks that expect quick results, such as fetching data from the server. *BGAppRefreshTask* can have **30 seconds** to complete its job. *BGAppRefreshTask* can be used for following tasks:
    - Fetching a social feeds from the server
    - Fetching news feed

- `BGProcessingTask` is for tasks that might be time-consuming, such as downloading a large file or synchronizing data. Your app can use one or both of these. *BGProcessingTask* can have **more than a minute** to complete its job. *BGProcessingTask* can be used for following tasks:
    - Core ML training 
    - Data synchronization
    - Database cleanup

In the demo using *BGAppRefreshTask*, weather information is fetched from the server as following screenshots:

![IMG_8854](https://user-images.githubusercontent.com/96768526/170833023-afd7674f-3b58-4b44-8654-aaa6b95454f0.PNG)
![IMG_8674](https://user-images.githubusercontent.com/96768526/170833254-a53fd80e-40c2-4814-8a01-7187c66e5c01.PNG)
![IMG_8664](https://user-images.githubusercontent.com/96768526/170833140-fd1b71f9-718e-4ffc-b17b-63046b4d08b3.PNG)

In the demo using *BGProcessingTask*, total number of photos and videos are fetched from the photo library as following screenshots:

## Purpose

iOS allows app to refresh it content even when it is sent to background. iOS can intelligently study the user’s behaviour and schedule background tasks to the moment right before routine usage. It is useful for app to retrieve the latest information from its server and display to user right when app is resumed to foreground. Examples are social media app (Facebook, Instagram & WhatsApp) and news app. Following is illustration of foreground and background task:

![1400](https://user-images.githubusercontent.com/96768526/170824992-33f362df-4399-472a-aa95-8a090deec43b.png)

## Implementation

### # Enable Background Tasks

To configure your app to allow background tasks, enable the background capabilities that you need, and then create a list of unique identifiers for each task.

To add the capabilities:

- Click Signing & Capabilities.
- Expand the Background Modes section. If the target doesn’t have a Background Modes section, click + Capability, and then select Background Modes.
- If you’re using BGAppRefreshTask, select ”Background fetch.“
- If you’re using BGProcessingTask, select ”Background processing.“

![3262152@2x](https://user-images.githubusercontent.com/96768526/170824969-cb6808c1-bf00-4025-a0f4-6cf6e72e7699.png)

To create this list, add the identifiers to the Info.plist file.

- Open the project navigator and select your target.
- Click Info and expand Custom iOS Target Properties.
- Add a new item to the list and choose ”Permitted background task scheduler identifiers“.
- Add the string for each authorized task identifier as a separate item in the array.
 
![3262151@2x](https://user-images.githubusercontent.com/96768526/170825096-ce1d28c3-dae6-4b9c-8e4c-a08b0377b44b.png)

### # Register a task

For each task, provide the *BGTaskScheduler* object with a launch handler (a small block of code that runs the task) and a unique identifier. Register all of the tasks before the end of the app launch sequence. To register background tasks, inside the *application(_:didFinishLaunchingWithOptions)* method, we should add the following command.

```swift
// For Background fetch
BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.pratik.backgrounds.BGFetch", using: nil) { task in
    self.handleAppRefresh(task: task as! BGAppRefreshTask)
}

// For Background processing
BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.pratik.backgrounds.BGProcessing", using: nil) { task in
    self.handleBackgroundProcessing(task: task as! BGProcessingTask)
}
```

### # Schedule a task

To submit a task request for the system to launch your app in the background at a later time, use *submit(_:)*.

```swift
// For Background fetch

func scheduleAppRefresh() {
   let request = BGAppRefreshTaskRequest(identifier: "com.pratik.backgrounds.BGFetch")
   
   // Fetch no earlier than 15 minutes from now
   request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
   do {
      try BGTaskScheduler.shared.submit(request)
   } catch {
      print("Could not schedule app refresh: \(error)")
   }
}

// For Background processing

func scheduleBackgroundProcessing() {
   let request = BGProcessingTaskRequest(identifier: "com.pratik.backgrounds.BGProcessing")
   
   // Fetch no earlier than 15 minutes from now
   request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
   // System will launch your app only when the device has a network connection
   request.requiresNetworkConnectivity = false
   
   // System will launch your app only while the device is connected to external power
   request.requiresExternalPower = false
   
   do {
      try BGTaskScheduler.shared.submit(request)
   } catch {
      print("Could not schedule background processing: \(error)")
   }
}
```
### # Run a task

When the system opens your app in the background, it calls the launch handler to run the task.

```swift
// For Background fetch

func handleAppRefresh(task: BGAppRefreshTask) {

   // Schedule a new refresh task
   self.scheduleAppRefresh()

   // Provide the background task with an expiration handler that cancels the operation
   task.expirationHandler = {
      task.setTaskCompleted(success: false)
   }

   // Do some data fetching and inform the system
   let isFetchSuccess = true // or false if task failed                                                                         
   task.setTaskCompleted(success: isFetchSuccess)
 }
 
// For Background processing

func handleBackgroundProcessing(task: BGProcessingTask) {
    // Schedule a new refresh task.
    self.scheduleBackgroundProcessing()
    ...
}
```
### # Simulate a task

The delay between the time you schedule a background task and when the system launches your app to run the task can be many hours. While developing your app, you can use a private functions to start a task.

To launch a task:

- Pause app at any point after submitting the BGTask to BGTaskScheduler
- Run the following command at the Terminal in Xcode
```swift
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"YOUR_TASK_IDENTIFIER"]
```
- Resume back your app. You can see the completion handler of the registered BGTask is then triggered.

