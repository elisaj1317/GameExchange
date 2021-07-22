//
//  Functions.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MaterialActivityIndicator.h"
#import "MaterialTextControls+FilledTextFields.h"

NS_ASSUME_NONNULL_BEGIN

@interface Functions : NSObject

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (MDCActivityIndicator *)startActivityIndicatorAtPosition:(CGPoint)position;
+ (void)setUpWithBlueMDCTextField:(MDCFilledTextField *)textField;

@end

NS_ASSUME_NONNULL_END
