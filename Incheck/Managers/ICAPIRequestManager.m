//
//  ICAPIRequestManager.m
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ICAPIRequestManager.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation ICAPIRequestManager

static NSString *rootURL = @"http://10.3.20.50:5000";
static NSString *productListURL = @"/product/list";
static ICAPIRequestManager* sharedManager = nil;

+ (ICAPIRequestManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ICAPIRequestManager alloc] init];
    });
    
    return sharedManager;
}

- (void)apiGETProductListRequestWithFinishedBlock:(RequestFinishedBlock)finishedBlock
{
    [SVProgressHUD show];
    NSString *urlPath = [NSString stringWithFormat:@"%@%@", rootURL, productListURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [SVProgressHUD dismiss];
         finishedBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [SVProgressHUD dismiss];
        finishedBlock(nil, error);
    }];
}

@end
