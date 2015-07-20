//
//  AppApi.h
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppApi : AFHTTPRequestOperationManager

+ (AppApi *)sharedClient ;
+ (AppApi *)sharedAuthorizedClient;
- (id)initWithBaseURL:(NSURL *)url;


- (AFHTTPRequestOperation *)callPostUrl:(NSDictionary *)aParams method:(NSString *)method
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callPostUrlWithHeader:(NSDictionary *)aParams method:(NSString *)method
                                          success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                          failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)profileUrl:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callGETUrlWithHeaderAuthentication:(NSDictionary *)aParams method:(NSString *)method
                                         success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                         failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callGETUrl:(NSDictionary *)aParams method:(NSString *)method
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callDeleteUrl:(NSDictionary *)aParams method:(NSString *)method
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)callPutUr:(NSDictionary *)aParams method:(NSString *)method
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callPutUrlWithHeader:(NSDictionary *)aParams method:(NSString *)method
                                          success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                          failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;



@end
