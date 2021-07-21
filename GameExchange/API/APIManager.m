//
//  APIManager.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/16/21.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.igdb.com/v4/";

@implementation APIManager

@synthesize access_token;


+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        [self authenticateWithCompletion:^(NSDictionary *data, NSError *error) {
            
            if(error) {
                NSLog(@"Error getting token: %@", error.localizedDescription);
            } else {
                NSLog(@"Got Data: %@", data);
                self.access_token = [data valueForKey:@"access_token"];
            }
            
        }];
      }
      return self;
}

- (void)authenticateWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    // get key and secret from Keys.plist file
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key= [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    // save client key for future requests
    self.client_key = key;
    
    // format request correctly
    NSString *urlString = [NSString stringWithFormat:@"https://id.twitch.tv/oauth2/token?client_id=%@&client_secret=%@&grant_type=client_credentials", key, secret];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               completion(dataDictionary, nil);

           }
       }];
    [task resume];
}

-(NSURL *)createURLwithEndpoint:(NSString *)endpoint {
    NSString *fullgameURLString = [NSString stringWithFormat:@"%@%@", baseURLString, endpoint];
    NSURL *gameURL = [NSURL URLWithString:fullgameURLString];
    return gameURL;
}

-(NSMutableURLRequest *)createRequestFormat {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    // set header
    [request setValue:[NSString stringWithFormat:@"%@", self.client_key] forHTTPHeaderField:@"Client-ID"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.access_token] forHTTPHeaderField:@"Authorization"];
    
    
    return request;
}

- (void)sendNetworkRequestWithPath:(NSURL *)pathURL withBody:(NSString *)requestBodyString completion:(void (^)(NSArray *data, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequestFormat];
    [request setURL:pathURL];
    
    NSData *requestBody = [requestBodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPBody:requestBody];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               completion(nil, error);
           }
           else {
               NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               completion(dataArray, nil);

           }
       }];
    [task resume];
}

- (void)getAutocompleteWithWord:(NSString *)word completion:(void (^)(NSArray *data, NSError *error))completion {
    NSURL *gameURL = [self createURLwithEndpoint:@"games"];
    NSString *fullrequestBody = [NSString stringWithFormat:@"fields name,rating; where name ~ *\"%@\"* & rating != null; sort rating desc; limit 10;", word];
    
    [self sendNetworkRequestWithPath:gameURL withBody:fullrequestBody completion:^(NSArray *data, NSError *error) {
            if(error != nil) {
                completion(nil, error);
            } else {
                completion(data, nil);
            }
    }];
}

- (void)getGamesWithCompletion:(void (^)(NSArray *data, NSError *error))completion {
    NSURL *gameURL = [self createURLwithEndpoint:@"games"];
    
    [self sendNetworkRequestWithPath:gameURL withBody:@"fields *;" completion:^(NSArray *data, NSError *error) {
            if(error != nil) {
                completion(nil, error);
            } else {
                completion(data, nil);
            }
    }];
}

- (void)managerDidInitialize {
    return;
}



@end
