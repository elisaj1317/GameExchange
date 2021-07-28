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
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *itemSelling;
@property (nonatomic, strong) NSArray *itemRequest;
@property (nonatomic, strong) NSString *requestStatus;
@property (nonatomic, strong) NSArray *offers;

+ (void) postRequestImage: ( UIImage * _Nullable )image withValues: ( NSDictionary * _Nullable )dict  withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
