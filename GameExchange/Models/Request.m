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

+ (nonnull NSString *)parseClassName {
    return @"Request";
}

+ (void) postRequestImage: ( UIImage * _Nullable )image withName: ( NSString * _Nullable )name withPlatform: ( NSString * _Nullable)platform withLocation: ( NSString * _Nullable )location withRequests: ( NSArray * _Nullable )requests withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Request *newRequest = [Request new];
    newRequest.author = [PFUser currentUser];
    UIImage *resizedImage = [Functions resizeImage:image withSize:CGSizeMake(300.0, 300.0)];
    newRequest.image = [Functions getPFFileFromImage:resizedImage];
    newRequest.platform = platform;
    newRequest.location = location;
    newRequest.itemSelling = name;
    newRequest.itemRequest = requests;
    newRequest.requestStatus = @"active";
    
    [newRequest saveInBackgroundWithBlock: completion];
}


@end
