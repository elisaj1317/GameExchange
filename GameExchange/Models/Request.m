//
//  Request.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "Request.h"

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

+ (void) postRequestImage: ( UIImage * _Nullable )image withName: ( NSString * _Nullable )name withLocation: ( NSString * _Nullable )location withRequests: ( NSArray * _Nullable )requests withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Request *newRequest = [Request new];
    newRequest.author = [PFUser currentUser];
    newRequest.image = [self getPFFileFromImage:image];
    newRequest.location = location;
    newRequest.itemSelling = name;
    newRequest.itemRequest = requests;
    newRequest.requestStatus = @"active";
    
    [newRequest saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
