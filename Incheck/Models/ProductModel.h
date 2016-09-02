//
//  ProductModel.h
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *productCategory;
@property (nonatomic, strong) NSString *productQuantity;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
