//
//  AutocompleteView.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "MaterialTextControls+FilledTextFields.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AutocompleteViewDelegate

- (void)fetchDataWithInView:(UIView *)view withWord:(NSString *)wordToSearch;

@end

@interface AutocompleteView : UIView 

@property (weak, nonatomic) IBOutlet MDCFilledTextField *textField;

@property (strong, nonatomic) NSMutableArray *startData;
@property (strong, nonatomic) NSMutableArray *autocompleteArray;
@property (nonatomic, weak) id<AutocompleteViewDelegate> delegate;

- (void)resetAutocomplete;
- (void)hideAutocomplete;
- (void)showTableView;


@end

NS_ASSUME_NONNULL_END
