//
//  INUserModel.h
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUserModel : NSObject

@property (nonatomic, strong) NSString *paymayaId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *countryCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
