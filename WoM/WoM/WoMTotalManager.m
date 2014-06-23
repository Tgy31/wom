//
//  WoMTotalManager.m
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import "WoMTotalManager.h"

#define BASE_URL @"http://store.total.com/"
#define EMAIL @"dev@hack4france.fr"
#define PASSWORD @"372"

static WoMTotalManager *sharedManager;

@implementation WoMTotalManager

+ (instancetype)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[WoMTotalManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

+ (void)getShopsAroundLocation:(CLLocation *)location
                     withLimit:(NSInteger)limit
                     andRadius:(CGFloat)radius
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    [[WoMTotalManager sharedManager] getShopsAroundLocation:location
                                                  withLimit:limit
                                                  andRadius:radius
                                                    success:success
                                                    failure:failure];
}

- (void)getShopsAroundLocation:(CLLocation *)location
                     withLimit:(NSInteger)limit
                     andRadius:(CGFloat)radius
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"email"] = EMAIL;
    parameters[@"password"] = PASSWORD;
    parameters[@"limit"] = @(limit);
    parameters[@"offset"] = @(0);
    parameters[@"lat"] = @(location.coordinate.latitude);
    parameters[@"lng"] = @(location.coordinate.longitude);
    parameters[@"search_radius"] = @(radius);
    
    [self GET:@"api/rest/maps/79/stores" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
