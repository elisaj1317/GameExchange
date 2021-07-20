//
//  APIManager.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/16/21.
//

#import <Foundation/Foundation.h>



@interface APIManager : NSObject

@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *client_key;

+ (instancetype)shared;
- (void)getAutocompleteWithWord:(NSString *)word completion:(void (^)(NSDictionary *, NSError *))completion;
- (void)getGamesWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end



