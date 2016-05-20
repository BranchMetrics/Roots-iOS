# Roots App Connection SDK

This is a repository of open source Roots App Connection iOS SDK. You can find the Android version [here](https://github.com/BranchMetrics/Roots-Android-SDK). This library is meant to serve two functions, to help you start linking to other apps but also receive links from others.

**Linking externally**

At Branch, we've noticed that a lot of people have adopted the Facebook App Links standard for deep linking. You can see the rules documented [here](applinks.org). We've come up with a standard behavior for what to do when a link is clicked on mobile. Here is the behavior priority:

1. Attempt to open up the native mobile app
2. Fallback to the web site
2. [optional] Fallback to the App Store

**Receiving links**

On the other hand, the other thing we've noticed that it's very difficult to configure deep linking in native apps. We want to make it incredibly simple to map your URI path to the View Controller responsible for displaying the content, then make it simple to access the referring link and metadata.

## Try the demo apps

This is the readme file of for open source Roots App Linker iOS SDK. There's a full demo app embedded in this repository.
- Check out the project
- Run `pod install` in `Example/`
- Run `pod install` in `Example/Roots-SDK-Routing-TestBed`
- Open up `Example/Roots-iOS-SDK.xcworkspace`

## Installation

#### Available in CocoaPods

Roots is available through CocoaPods. To install it, simply add the following line to your Podfile:

```sh
pod "Roots"
```

#### Using the local library

Clone this repository and drag the `Roots-iOS-SDK` into your Xcode project.

## Connecting to another app

Use the following api to connect to an applications using a url.

```Objc
[Roots connect:url withDelegate:rootsEventDelegate andWithOptions:rootsLinkOptions]
```

That's all! The library will take care of the rest. The App Links are automatically parsed from the web link to determine the routing configuration. It will first try to open the app and then fallback to the web URL (or Play Store depending on configuration). You can specify the fallback preference using the `RootsLinkOptions` object.

If you’d like to listen to routing lifecyle events, add a `RootsEventsDelegate` to listen to the app connection states as follows.

## Configuring in-app routing

To setup in-app routing when the app is opened by Universal Links, Facebook App Links or any URI scheme path, follow the steps below:

##### Add routing filters in the AppDelegate

The destination view controllers should be registered to a routing filter in the AppDelegate didFinishLaunchingWithOptions. In the routing filter, wildcard fields are specified by `*` and parameters are specified with in `{}`. The SDK will capture the parameters with their values and make them available once the view controller loads.

```Objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure controllers for deeplinking
    [RootsDeepLinkRouter registerForRouting:@"MyControllerID" forAppLinkKey:@"al:ios:url" withValueFormat:@"myscheme://*/user/{User_ID}/{Name}"];
    [RootsDeepLinkRouter registerForRouting:@"MyControllerID" forAppLinkKey:@"al:web:url" withValueFormat:@"https://my_awesome_site.com/*/{user_id}"];
    return YES;
}
```

Also, the router must receive the deep link path in `openURL`.

```Objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [RootsDeepLinkRouter openUrl:url];
    return YES;
}
```

And the router must receive the path of the universal link in `continueUserActivity`.

```Objc
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    [RootsDeepLinkRouter continueUserActivity:userActivity];
    return YES;
}
```

To receive the parameters, implement `RootsRoutingDelegate` in  your ViewControllers and add method `configureControlWithRoutingData` as follows:

```Objc
- (void) configureControlWithRoutingData:(NSDictionary *) routingParams {
    // routingParams will have the parameters specified in the filter format and their corresponding values in the app link data.
    // Configure your UI with the routingParams here.
}
```
