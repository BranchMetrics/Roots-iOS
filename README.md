# Roots AppLinker iOS SDK

This is a repository of open source Roots App Linker iOS SDK, and the information presented here serves as a reference manual for Roots App Linker SDK.

## Get the Demo App

This is the readme file of for open source Roots App Linker iOS SDK. There's a full demo app embedded in this repository. Check out the project and run the `Roots-SDK-TestBed` for a demo.

## Installation
#### Available in CocoaPods
Roots App Linker is available through CocoaPods. To install it, simply add the following line to your Podfile:
```Objc
pod "Roots"
```
#### Download the Raw Files
You can also install by downloading the raw files below.

Download code from here: https://s3-us-west-1.amazonaws.com/branchhost/Roots-iOS-SDK.zip

The testbed project: https://s3-us-west-1.amazonaws.com/branchhost/Roots-SDK-TestBed.zip

## Connect To External Application
Use the following api to connect to an applications using a url.

```Objc
[Roots connect:url withDelegate:rootsEventDelegate andWithOptions:rootsLinkOptions]
```

That's all sdk will take care of the rest. If any configured app installed it will be opened. It will fallback to the web URL if no app found. You can specify the link preference using `RootsLinkOptions`.
If you’d like to listen to routing lifecyle events, add a `RootsEventsDelegate` to listen to the app connection states as in the above example.


## Configuring In-app Routing
To setup in-app routing when the app is opened by Universal App Link or Facebook App Links follow the below two steps

##### Enable in-app routing
In your `AppdDelegate` class

```Objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [RootsDeepLinkRouter handleDeeplinkRouting:url];
    return YES;
}
```
##### Add Routing Filters
The View controllers for routing should specified in `AppdDelegate` class as follows

```Objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure controllers for deeplinking
    [RootsDeepLinkRouter registerForRouting:@"MyControllerID" forAppLinkKey:@"al:ios:url" withValueFormat:@"myscheme://*/user/{User_ID}/{Name}"];
    [RootsDeepLinkRouter registerForRouting:@"MyControllerID" forAppLinkKey:@"al:web:url" withValueFormat:@"https://my_awesome_site.com/*/{user_id}"];
    return YES;
}
```

SDK will check the View Controller filters and launch the matching View Controller.
In the routing filter the wildcard fields are specified by `*` and the parameters are specified with in `{}`. SDK capture the parameters and their values and add is provided to the View Controller as a dictionary.
To receive the deep link parameters implement `RootsRoutingDelegate` in  your ViewControllers and add method `configureControlWithRoutingData` as follows

```Objc
- (void) configureControlWithRoutingData:(NSDictionary *) routingParams {
    // routingParams will have the parameters specified in the filter format and their corresponding values in the app link data.
    // Configure your UI with the routingParams here.
}
```
