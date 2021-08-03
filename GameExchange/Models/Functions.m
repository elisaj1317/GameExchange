//
//  Functions.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "Functions.h"

@implementation Functions

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

+ (MDCActivityIndicator *)startActivityIndicatorAtPosition:(CGPoint)position {
    MDCActivityIndicator *activityIndicator = [[MDCActivityIndicator alloc] init];
    [activityIndicator sizeToFit];
    activityIndicator.center = position;
    UIColor *royalBlue = [UIColor colorNamed:@"royalBlue"];
    activityIndicator.cycleColors = @[royalBlue];

    // To make the activity indicator appear:
    [activityIndicator startAnimating];

    return activityIndicator;
}

+ (void)setUpWithBlueMDCTextField:(MDCFilledTextField *)textField {
    UIColor *royalBlue = [UIColor colorNamed:@"royalBlue"];
    textField.tintColor = royalBlue;
    [textField setFloatingLabelColor:royalBlue forState:MDCTextControlStateEditing];
    [textField setUnderlineColor:royalBlue forState:MDCTextControlStateEditing];
}

+ (UIAlertController *)createErrorWithMessage:(NSString *)message{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:okAction];
    return errorAlert;
}

+ (NSMutableString *)stringWithArray:(NSArray *)array {
    NSMutableString *string = [NSMutableString string];
    
    if (array.count == 0) {
        [string appendString:@"None"];
    } else {
        for (NSString *item in array) {
            [string appendString:[NSString stringWithFormat:@", %@", item]];
        }
        [string deleteCharactersInRange:NSMakeRange(0, 2)];
    }
    
    return string;
}

@end
