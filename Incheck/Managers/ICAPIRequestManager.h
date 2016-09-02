//
//  ICAPIRequestManager.h
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^RequestFinishedBlock)(NSDictionary *returnParameters, NSError *error);

@interface ICAPIRequestManager : NSObject

+ (ICAPIRequestManager *)sharedManager;
- (void)apiGETProductListRequestWithFinishedBlock:(RequestFinishedBlock)finishedBlock;
- (void)apiPOSTTransactionRequestWithPaymentId:(NSString *)paymentId
                                         items:(NSArray *)items
                                   totalAmount:(CGFloat)totalAmount
                                 finsihedBlock:(RequestFinishedBlock)finishedBlock;

@end
