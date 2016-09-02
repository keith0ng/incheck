//
//  ICPayMayaRequestManager.h
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICUserModel.h"
#import "ICCreditModel.h"

@interface ICPayMayaRequestManager : NSObject

+ (ICPayMayaRequestManager *)sharedManager;

// Customer Methods
- (void)createPaymayaUserWithUserModel:(ICUserModel *)user;
- (void)getCustomerDetailsWithUser:(ICUserModel *)user;
- (void)updateCustomerDetailsWithUser:(ICUserModel *)user;

// Card Methods
- (void)vaultCardDetailsWithCard:(ICCreditModel *)card forUser:(ICUserModel *)user;

@end
