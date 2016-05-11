//
//  RootsFinder.m
//  Pods
//
//  Created by Sojan P.R. on 5/4/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RootsFinder.h"
#import "URLContent.h"
#import "AppLaunchConfig.h"
#import "AppRouter.h"

@interface RootsFinder ()

/**
 * Callback for Root finder events
 */
@property (nonatomic, assign) id<RootsEventsDelegate> rootsEventCallback;
@property (nonatomic, strong) RootsLinkOptions *options;

/**
 Uri to find roots
 */
@property (strong, nonatomic) NSString *actualUri;

/**
 * Web view to extract the App links
 */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation RootsFinder

- (instancetype) init {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc] init];
    }
    return self;
}

// Injecting Javascript to get the app links as JSONArray
// Source : https://github.com/BoltsFramework/Bolts-ObjC/blob/9067bd0b725f4b17c5204bf214055734cd71080e/Bolts/iOS/BFWebViewAppLinkResolver.m
static NSString *const METADATA_READ_JAVASCRIPT = @""
"(function() {"
"  var metaTags = document.getElementsByTagName('meta');"
"  var results = [];"
"  for (var i = 0; i < metaTags.length; i++) {"
"    var property = metaTags[i].getAttribute('property');"
"    if (property && property.substring(0, 'al:'.length) === 'al:') {"
"      var tag = { \"property\": metaTags[i].getAttribute('property') };"
"      if (metaTags[i].hasAttribute('content')) {"
"        tag['content'] = metaTags[i].getAttribute('content');"
"      }"
"      results.push(tag);""    }"
"  }"
"  return JSON.stringify(results);"
"})()";

- (void) findAndFollowRoots:(NSString *)url withDelegate:(id)callback andOptions:(RootsLinkOptions *)options {
    _rootsEventCallback = callback;
    _options = options;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Get the final redirected URL content
        URLContent *urlContent = [self getUrlContent:url];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Extract the Applink content by JS injection
            [self scrapeAppLinkContent:urlContent];
        });
    });
}

- (URLContent *) getUrlContent:(NSString *)url {
    _actualUri = url;
    NSString *redirectedUrl = url;
    URLContent *urlContent = [[URLContent alloc] init];
    NSURLResponse *response = nil;
    NSData *contentData = nil;
    
    while (redirectedUrl) {
        NSMutableURLRequest  * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [urlRequest setValue:@"al" forHTTPHeaderField:@"Prefer-Html-Meta-Tags"];
        if ([_options getUserAgent]) {
            [urlRequest setValue:[_options getUserAgent] forHTTPHeaderField:@"User-Agent"];
        }
        NSError * error = nil;
        contentData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if (error == nil) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger responseCode = [(NSHTTPURLResponse *) response statusCode];
                if(responseCode >= 300 && responseCode < 400) {
                    NSDictionary* headers = [(NSHTTPURLResponse *) response allHeaderFields];
                    redirectedUrl = [headers objectForKey:@"Location"];
                    continue;
                }
            }
        }
        redirectedUrl = nil;
    }
    
    urlContent.htmlSource = contentData;
    if (response) {
        urlContent.contentType = response.MIMEType;
        urlContent.contentEncoding = response.textEncodingName;
    }
    return urlContent;
}


- (void) scrapeAppLinkContent:(URLContent *)urlContent {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.webView];
    _webView.delegate = self;
    _webView.hidden = YES;
    [_webView loadData:urlContent.htmlSource
              MIMEType:urlContent.contentType
      textEncodingName:urlContent.contentEncoding
               baseURL:[NSURL URLWithString:@""]];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self ExtractAppLuanchConfigUsingJavaScript:webView];
}


- (void) ExtractAppLuanchConfigUsingJavaScript:(UIWebView *)webView {
    AppLaunchConfig *appLaunchConfig = [[AppLaunchConfig alloc]init];
    appLaunchConfig.actualUri = _actualUri;
    appLaunchConfig.targetAppFallbackUrl = _actualUri;
    
    NSString *jsonString = [webView stringByEvaluatingJavaScriptFromString:METADATA_READ_JAVASCRIPT];
    NSError *error = nil;
    NSArray *appLinkMetadataArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:0
                                                                      error:&error];
    appLaunchConfig = [AppLaunchConfig initialize:appLinkMetadataArray withUrl:_actualUri];
    if ([_options isUserOverridingFallbackRule]) {
        appLaunchConfig.alwaysOpenAppStore =  [_options getAlwaysFallbackToAppStore];
    }
    [AppRouter handleAppRouting:appLaunchConfig withDelegate:_rootsEventCallback];
}

@end