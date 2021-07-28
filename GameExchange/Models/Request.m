//
//  Request.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "Request.h"
#import "Functions.h"

@implementation Request

@dynamic author;
@dynamic location;
@dynamic image;
@dynamic itemSelling;
@dynamic itemRequest;
@dynamic requestStatus;
@dynamic platform;
@dynamic genre;
@dynamic offers;

+ (nonnull NSString *)parseClassName {
    return @"Request";
}

+ (void) postRequestImage: ( UIImage * _Nullable )image withValues: ( NSDictionary * _Nullable )dict  withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Request *newRequest = [Request new];
    newRequest.author = [PFUser currentUser];
    UIImage *resizedImage = [Functions resizeImage:image withSize:CGSizeMake(300.0, 300.0)];
    newRequest.image = [Functions getPFFileFromImage:resizedImage];
    newRequest.itemSelling = dict[@"itemName"];
    newRequest.platform = dict[@"platform"];
    newRequest.genre = dict[@"genre"];
    newRequest.location = dict[@"location"];
    newRequest.itemRequest = dict[@"itemRequest"];
    newRequest.requestStatus = @"active";
    newRequest.offers = [NSArray array];
    
    [newRequest saveInBackgroundWithBlock: completion];
}


@end
