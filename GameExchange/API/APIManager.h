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
- (void)getGameAutocompleteWithWord:(NSString *)word completion:(void (^)(NSArray *data, NSError *error))completion;
- (void)getPlatformAutocompleteWithWord:(NSString *)word completion:(void (^)(NSArray *data, NSError *error))completion;
- (void)getGenreAutocompleteWithWord:(NSString *)word completion:(void (^)(NSArray *data, NSError *error))completion;
- (void)getGamesWithCompletion:(void (^)(NSArray *data, NSError *error))completion;

@end



