//
//  AppApi.m
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "AppApi.h"

/* API Constants */
static NSString * const kAppAPIBaseURLString = @"https://likeminded.co";

@interface AppApi ()

@end

@implementation AppApi

/* API Clients */

+ (AppApi *)sharedClient {
    
    static AppApi * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppApi alloc] initWithBaseURL:[NSURL URLWithString:kAppAPIBaseURLString]];
    });
    return [AppApi manager];
}

+ (AppApi *)sharedAuthorizedClient{
    return nil;
}

/* API Initialization */

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

/* API Deallocation */

- (void)dealloc {
    
}

#pragma mark- Call post url

- (AFHTTPRequestOperation *)callPostUrl:(NSDictionary *)aParams method:(NSString *)method
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];
    
    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];

            failureBlock(task, error);
        }
    }];
}


- (AFHTTPRequestOperation *)callPostUrlWithHeader:(NSDictionary *)aParams method:(NSString *)method
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
    [operationManager.requestSerializer setValue:auth_Token forHTTPHeaderField:AUTH_TOKEN];
    operationManager.requestSerializer.timeoutInterval = 210;
    return [operationManager POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];

            failureBlock(task, error);
        }
    }];
}

#pragma mark - Call get url with header

- (AFHTTPRequestOperation *)callGETUrlWithHeaderAuthentication:(NSDictionary *)aParams method:(NSString *)method
                                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
    [operationManager.requestSerializer setValue:auth_Token forHTTPHeaderField:AUTH_TOKEN];

    return [operationManager GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session*******%@",responseObject);
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}

#pragma mark - Call Get url only

- (AFHTTPRequestOperation *)callGETUrl:(NSDictionary *)aParams method:(NSString *)method
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];

    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}

#pragma Mark - Profile url with header

- (AFHTTPRequestOperation *)profileUrl:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url = [NSString stringWithFormat:@"%@/api/v1/profile",kAppAPIBaseURLString];
  
  AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
  NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
  [operationManager.requestSerializer setValue:auth_Token forHTTPHeaderField:AUTH_TOKEN];
  [operationManager.requestSerializer setValue:@"2" forHTTPHeaderField:@"belief"];
  
  return [operationManager GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    if(successBlock){
      @try {
        NSLog(@"Create Session");
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
  }];
}

- (AFHTTPRequestOperation *)callDeleteUrl:(NSDictionary *)aParams method:(NSString *)method
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
    [operationManager.requestSerializer setValue:auth_Token forHTTPHeaderField:AUTH_TOKEN];

    return [operationManager DELETE:strUrl parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];}


#pragma mark-call put url with header
- (AFHTTPRequestOperation *)callPutUrlWithHeader:(NSDictionary *)aParams method:(NSString *)method
                                          success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                          failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
    [operationManager.requestSerializer setValue:auth_Token forHTTPHeaderField:AUTH_TOKEN];

    return [operationManager PUT:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];

            failureBlock(task, error);
        }
    }];
}

- (AFHTTPRequestOperation *)callPutUr:(NSDictionary *)aParams method:(NSString *)method
                                         success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                         failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

    NSString *url = [NSString stringWithFormat:@"%@%@",kAppAPIBaseURLString, method];

    return [self PUT:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];

            failureBlock(task, error);
        }
    }];
}

#pragma mark- Process Exception and Failure Block

- (void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception{
    NSLog(@"Exception : %@",((NSException*)exception));
}

- (NSError *)processFailureBlock:(AFHTTPRequestOperation*) task blockError:(NSError*) error{
    NSLog(@"Error :%@",error);
    return nil;
}

@end
