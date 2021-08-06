//
//  CreateViewController.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) Request *editRequest;

@end

NS_ASSUME_NONNULL_END
