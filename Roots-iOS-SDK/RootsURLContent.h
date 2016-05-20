//
//  RootsUrlContent.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/5/16.
//
//

@interface RootsURLContent : NSObject

@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *contentEncoding;
@property (strong, nonatomic) NSData *htmlSource;

@end