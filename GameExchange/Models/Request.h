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
@property (nonatomic, strong) NSString *itemSelling;
@property (nonatomic, strong) NSArray *itemRequest;
@property (nonatomic, strong) NSString *requestStatus;

@end

NS_ASSUME_NONNULL_END
