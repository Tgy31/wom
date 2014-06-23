//
//  WoMTotalManager.h
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <MapKit/MapKit.h>

@interface WoMTotalManager : AFHTTPSessionManager

+ (void)getShopsAroundLocation:(CLLocation *)location
                     withLimit:(NSInteger)limit
                     andRadius:(CGFloat)radius
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;;

@end
