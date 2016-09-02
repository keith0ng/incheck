//
//  ICPayMayaRequestManager.m
//  Incheck
//
//  Created by Russel Usi on 9/2/16.
//  Copyright © 2016 Russel Usi. All rights reserved.
//

#import "ICPayMayaRequestManager.h"
#import "ICUserModel.h"
#import "ICCreditModel.h"
#import "AFNetworking.h"

@interface ICPayMayaRequestManager()

@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *paymentToken;

@end

@implementation ICPayMayaRequestManager

static NSString *publicAPIKey = @"pk-N6TvoB4GP2kIgNz4OCchCTKYvY5kPQd2HDRSg8rPeQG:";
static NSString *secretAPIKey = @"sk-9lRmFTV8BIdxoXWm5liDAlKF0yL4gZzwmDQAmnvxWOF:";

// Customer API
static NSString *createCustomerURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers";
static NSString *getCustomerURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/";
static NSString *updateCUstomerURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/";

// Card API
static NSString *createPaymentTokenURL = @"https://pg-sandbox.paymaya.com/payments/v1/payment-tokens";
static NSString *vaultCardURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/%@/cards";
static NSString *getCardDetailsURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/%@/cards/%@";
static NSString *updateCardDetailsURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/%@/cards/%@";

// Payment API
static NSString *createPaymentURL = @"https://pg-sandbox.paymaya.com/payments/v1/customers/%@/cards/%@/payments";

static ICPayMayaRequestManager* sharedManager = nil;

+ (ICPayMayaRequestManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ICPayMayaRequestManager alloc] init];
        [sharedManager convertAPIKeysToBase64EncodedString];
    });
    
    return sharedManager;
}

- (void)convertAPIKeysToBase64EncodedString
{
    NSData *publicAPIData = [publicAPIKey dataUsingEncoding:NSUTF8StringEncoding];
    self.publicKey = [NSString stringWithFormat:@"Basic %@", [publicAPIData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
    NSData *secretAPIData = [secretAPIKey dataUsingEncoding:NSUTF8StringEncoding];
    self.secretKey = [NSString stringWithFormat:@"Basic %@", [secretAPIData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
}

- (void)createPaymayaUserWithUserModel:(ICUserModel *)user
{
    NSDictionary *userDictionary = @{@"firstName"   :   user.firstName,
                                     @"lastName"    :   user.lastName,
                                     @"middleName"  :   user.middleName,
                                     @"birthday"    :   user.birthday,
                                     @"sex"         :   user.sex,
                                     @"contact"     :   @{
                                                            @"phone"    :   user.phone,
                                                            @"email"    :   user.email
                                                        },
                                     @"billingAddress": @{
                                                            @"line1"    :   user.address1,
                                                            @"line2"    :   user.address2,
                                                            @"city"        :   user.city,
                                                            @"state"       :   user.state,
                                                            @"zipCode"     :   user.zipcode,
                                                            @"countryCode" :   user.countryCode
                                                        },
                                     @"metadata"    : @{}
                                     };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Authorization"];
    
    [manager POST:createCustomerURL parameters:userDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"%@", error);
    }];
}

-(void)getCustomerDetailsWithUser:(ICUserModel *)user
{
    NSString *url = [NSString stringWithFormat:@"%@%@", getCustomerURL, user.paymayaId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"Response %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"Error %@", error);
    }];
}

- (void)updateCustomerDetailsWithUser:(ICUserModel *)user
{
    NSString *url = [NSString stringWithFormat:@"%@%@", updateCUstomerURL, user.paymayaId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *userDictionary = @{@"firstName"   :   user.firstName,
                                     @"lastName"    :   user.lastName,
                                     @"middleName"  :   user.middleName,
                                     @"birthday"    :   user.birthday,
                                     @"sex"         :   user.sex,
                                     @"contact"     :   @{
                                             @"phone"    :   user.phone,
                                             @"email"    :   user.email
                                             },
                                     @"billingAddress": @{
                                             @"line1"    :   user.address1,
                                             @"line2"    :   user.address2,
                                             @"city"        :   user.city,
                                             @"state"       :   user.state,
                                             @"zipCode"     :   user.zipcode,
                                             @"countryCode" :   user.countryCode
                                             },
                                     @"metadata"    : @{}
                                     };
    
    [manager PUT:url parameters:userDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"%@", error);
    }];
}

- (void)createPaymentTokenWithCard:(ICCreditModel *)card
{
    NSDictionary *cardDictionary = @{@"card" : @{
                                             @"number"   :  card.cardNumber,
                                             @"expMonth" :  card.expiryMonth,
                                             @"expYear"  :  card.expiryYear,
                                             @"cvc"      :  card.cvc
                                                }
                                     };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.publicKey forHTTPHeaderField:@"Authorization"];
    
    [manager POST:createPaymentTokenURL parameters:cardDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"Response %@", responseObject);
        self.paymentToken = [responseObject objectForKey:@"paymentTokenId"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"Error %@", error);
    }];
}

- (void)vaultCardDetailsWithCard:(ICCreditModel *)card forUser:(ICUserModel *)user
{
    [self createPaymentTokenWithCard:card];
    
    NSString *urlPath = [NSString stringWithFormat:vaultCardURL, user.paymayaId];
    
    NSDictionary *requestParameters = @{@"paymentTokenId"   :   self.paymentToken,
                                        @"isDefault"        :   @YES};
    
    NSLog(@"%@", requestParameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Authorization"];
    
    [manager POST:urlPath parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"Response %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"Error %@", error);
    }];
}

- (void)createPaymentWithCard:(ICCreditModel *)card forUser:(ICUserModel *)user withTotalAmount:(CGFloat)total
{
    NSString *url = [NSString stringWithFormat:createPaymentURL, user.paymayaId, card.cardTokenId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:self.secretKey forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *paymentDictionary = @{@"totalAmount"  :   @{
                                                @"amount"   : [NSString stringWithFormat:@"%.02f", total],
                                                @"currency" : @"PHP"
                                                            }};
    
    [manager POST:url parameters:paymentDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"Response %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"Error %@", error);
    }];
}

@end
