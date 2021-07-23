//
//  AutocompleteView.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "MaterialTextControls+FilledTextFields.h"

NS_ASSUME_NONNULL_BEGIN

@interface AutocompleteView : UIView 

@property (weak, nonatomic) IBOutlet MDCFilledTextField *textField;
@property (strong, nonatomic) NSMutableArray *autocompleteArray;


- (void)resetAutocomplete;
- (void)hideAutocomplete;


@end

NS_ASSUME_NONNULL_END
