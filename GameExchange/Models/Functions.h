//
//  Functions.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Functions : NSObject

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
