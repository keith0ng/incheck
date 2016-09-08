//
//  ICUserModel.m
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import "ICUserModel.h"

@implementation ICUserModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init])
    {
        self.paymayaId = [dictionary objectForKey:@"id"];
        self.firstName = [dictionary objectForKey:@"firstName"];
        self.lastName = [dictionary objectForKey:@"lastName"];
        self.middleName = [dictionary objectForKey:@"middleName"];
        self.birthday = [dictionary objectForKey:@"birthday"];
        self.sex = [dictionary objectForKey:@"sex"];;
        self.phone = [[dictionary objectForKey:@"contact"] objectForKey:@"phone"];
        self.email = [[dictionary objectForKey:@"contact"] objectForKey:@"email"];
        self.address1 = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"line1"];
        self.address2 = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"line2"];
        self.city = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"city"];
        self.state = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"state"];
        self.zipcode = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"zipCode"];
        self.countryCode = [[dictionary objectForKey:@"billingAddress"] objectForKey:@"countryCode"];
    }
    return self;
}

@end
