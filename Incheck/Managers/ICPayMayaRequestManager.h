//
//  ICPayMayaRequestManager.h
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ICUserModel.h"
#import "ICCreditModel.h"

typedef void (^RequestFinishedBlock)(NSDictionary *returnParameters, NSError *error);

@interface ICPayMayaRequestManager : NSObject

+ (ICPayMayaRequestManager *)sharedManager;

// Customer Methods
- (void)createPaymayaUserWithUserModel:(ICUserModel *)user
                         finishedBlock:(RequestFinishedBlock)finishedBlock;
- (void)getCustomerDetailsWithUser:(ICUserModel *)user;
- (void)updateCustomerDetailsWithUser:(ICUserModel *)user;

// Card Methods
- (void)vaultCardDetailsWithCard:(ICCreditModel *)card forUser:(ICUserModel *)user;

- (void)checkoutWithItems:(NSArray *)items
                  forUser:(ICUserModel *)user
          withTotalAmount:(CGFloat)totalAmount
            finishedBlock:(RequestFinishedBlock)finishedBlock;

@end
