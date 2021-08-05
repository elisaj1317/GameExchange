//
//  DetailsViewController.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Request *request;
@property (assign) BOOL editable;

@end

NS_ASSUME_NONNULL_END
