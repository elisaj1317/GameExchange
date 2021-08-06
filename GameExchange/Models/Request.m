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
    [newRequest setRequestwithImage:image withValues:dict];
    newRequest.author = [PFUser currentUser];
    
    [newRequest saveInBackgroundWithBlock: completion];
}

- (void)setRequestwithImage: (UIImage * _Nullable )image withValues:( NSDictionary * _Nullable )dict {
    self.author = [PFUser currentUser];
    UIImage *resizedImage = [Functions resizeImage:image withSize:CGSizeMake(300.0, 300.0)];
    self.image = [Functions getPFFileFromImage:resizedImage];
    self.itemSelling = dict[@"itemName"];
    self.platform = dict[@"platform"];
    self.genre = dict[@"genre"];
    self.location = dict[@"location"];
    self.itemRequest = dict[@"itemRequest"];
    self.requestStatus = @"active";
    self.offers = [NSArray array];
}

- (void)updateRequestwithImage: ( UIImage * _Nullable )image withValues: ( NSDictionary * _Nullable )dict  withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [self setRequestwithImage:image withValues:dict];
    
    [self saveInBackgroundWithBlock:completion];
}


@end
