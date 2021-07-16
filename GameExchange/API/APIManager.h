//
//  APIManager.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/16/21.
//

#import <Foundation/Foundation.h>



@interface APIManager : NSObject

+ (instancetype)shared;
- (void)authenticateWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end



