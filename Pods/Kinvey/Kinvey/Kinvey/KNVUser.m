//
//  KNVUser.m
//  Kinvey
//
//  Created by Victor Barros on 2016-03-04.
//  Copyright © 2016 Kinvey. All rights reserved.
//

#import "KNVUser+Internal.h"

@interface KNVUser ()

@property (nonatomic, strong) __KNVUser *user;

@end

#define KNVUserDispatchCompletionHandler(completionHandler, user, error) if (completionHandler) completionHandler(user ? [[KNVUser alloc] initWithUser:user] : nil, error)

@implementation KNVUser

-(instancetype)initWithUser:(__KNVUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

+(id<KNVRequest>)existsWithUsername:(NSString *)username
                  completionHandler:(KNVUserExistsHandler)completionHandler
{
    return [self existsWithUsername:username
                             client:[KNVClient sharedClient]
                  completionHandler:completionHandler];
}

+(id<KNVRequest>)existsWithUsername:(NSString *)username
                             client:(KNVClient *)client
                  completionHandler:(KNVUserExistsHandler)completionHandler
{
    return [__KNVUser existsWithUsername:username
                                  client:client.client
                       completionHandler:completionHandler];
}

+(id<KNVRequest>)loginWithUsername:(NSString *)username
                          password:(NSString *)password
                 completionHandler:(KNVUserUserHandler)completionHandler
{
    return [self loginWithUsername:username
                          password:password
                            client:[KNVClient sharedClient]
                 completionHandler:completionHandler];
}

+(id<KNVRequest>)loginWithUsername:(NSString *)username
                          password:(NSString *)password
                            client:(KNVClient *)client
                 completionHandler:(KNVUserUserHandler)completionHandler
{
    return [__KNVUser loginWithUsername:username
                               password:password
                                 client:client.client
                      completionHandler:^(__KNVUser * _Nullable user, NSError * _Nullable error)
    {
        KNVUserDispatchCompletionHandler(completionHandler, user, error);
    }];
}

+(id<KNVRequest>)destroyWithUserId:(NSString *)userId
                 completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [self destroyWithUserId:userId
                              hard:true
                            client:[KNVClient sharedClient]
                 completionHandler:completionHandler];
}

+(id<KNVRequest>)destroyWithUserId:(NSString *)userId
                            client:(KNVClient *)client
                 completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [self destroyWithUserId:userId
                              hard:true
                            client:client
                 completionHandler:completionHandler];
}

+(id<KNVRequest>)destroyWithUserId:(NSString *)userId
                              hard:(BOOL)hard
                 completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [self destroyWithUserId:userId
                              hard:hard
                            client:[KNVClient sharedClient]
                 completionHandler:completionHandler];
}

+(id<KNVRequest>)destroyWithUserId:(NSString *)userId
                              hard:(BOOL)hard
                            client:(KNVClient *)client
                 completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [__KNVUser destroyWithUserId:userId
                                   hard:hard
                                 client:client.client
                      completionHandler:completionHandler];
}

-(id<KNVRequest>)destroy:(KNVUserVoidHandler)completionHandler
{
    return [self destroyWithHard:true
                          client:[KNVClient sharedClient]
               completionHandler:completionHandler];
}

-(id<KNVRequest>)destroyWithHard:(BOOL)hard
               completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [self destroyWithHard:hard
                          client:[KNVClient sharedClient]
               completionHandler:completionHandler];
}

-(id<KNVRequest>)destroyWithHard:(BOOL)hard
                          client:(KNVClient*)client
               completionHandler:(KNVUserVoidHandler)completionHandler
{
    return [self.user destroyWithHard:hard
                               client:client.client
                    completionHandler:completionHandler];
}

+(id<KNVRequest>)getWithUserId:(NSString *)userId
             completionHandler:(KNVUserUserHandler)completionHandler
{
    return [self getWithUserId:userId
                        client:[KNVClient sharedClient]
             completionHandler:completionHandler];
}

+(id<KNVRequest>)getWithUserId:(NSString*)userId
                        client:(KNVClient*)client
             completionHandler:(KNVUserUserHandler)completionHandler
{
    return [__KNVUser getWithUserId:userId
                             client:client.client
                  completionHandler:^(__KNVUser * _Nullable user, NSError * _Nullable error)
    {
        KNVUserDispatchCompletionHandler(completionHandler, user, error);
    }];
}

-(void)logout
{
    [self.user logout];
}

@end
