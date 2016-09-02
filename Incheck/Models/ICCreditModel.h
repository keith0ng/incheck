//
//  ICCreditModel.h
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCreditModel : NSObject

@property (nonatomic, strong) NSString *cardTokenId;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expiryMonth;
@property (nonatomic, strong) NSString *expiryYear;
@property (nonatomic, strong) NSString *cvc;

@end
