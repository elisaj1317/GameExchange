//
//  Request.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Request : PFObject <PFSubclassing>


@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *itemSelling;
@property (nonatomic, strong) NSArray *itemRequest;
@property (nonatomic, strong) NSString *requestStatus;

+ (void) postRequestImage: ( UIImage * _Nullable )image withName: ( NSString * _Nullable )name withPlatform: ( NSString * _Nullable)platform withLocation: ( NSString * _Nullable )location withRequests: ( NSArray * _Nullable )requests withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
