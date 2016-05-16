//
//  DeepLinkRouter.h
//  Pods
//
//  Created by Sojan P.R. on 5/12/16.
//
//

#ifndef DeepLinkRouter_h
#define DeepLinkRouter_h


#endif /* DeepLinkRouter_h */

@interface DeepLinkRouter : NSObject

+ (void) registerForRouting:(NSString *) controllerId forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat;
+ (void) handleDeeplinkRouting:(NSURL *)url;

@end