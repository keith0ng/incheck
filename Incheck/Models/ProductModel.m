//
//  ProductModel.m
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.productName = [dictionary objectForKey:@"name"];
        self.productCode = [dictionary objectForKey:@"barcode"];
        self.totalPrice = [[dictionary objectForKey:@"price"] floatValue];
        self.productPerPiece = [[dictionary objectForKey:@"price"] floatValue];
        self.productQuantity = 1;
        self.productCategory = [dictionary objectForKey:@"category"];
    }
    return self;
}

@end
