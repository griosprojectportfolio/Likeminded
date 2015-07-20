//
//  AppApi.m
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "AppApi.h"

/* API Constants */
static NSString * const kAppAPIBaseURLString = @"http://echo.jsontest.com/title/ipsum/content/blah";

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

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

/* API Deallocation */

-(void)dealloc {
    
}

#pragma mark- Login User

- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@",kAppAPIBaseURLString];
    
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

#pragma mark- SignUp User

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@",kAppAPIBaseURLString];
    
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

#pragma mark- Forgot password

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@",kAppAPIBaseURLString];
    
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


#pragma mark- Process Exception and Failure Block

-(void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception{
    NSLog(@"Exception : %@",((NSException*)exception));
}

- (NSError*)processFailureBlock:(AFHTTPRequestOperation*) task blockError:(NSError*) error{
    //Common Method for error handling
    // Do some thing for error handling
    NSLog(@"Error :%@",error);
    return nil;
}


@end
