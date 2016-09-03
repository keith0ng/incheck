//
//  RegisterViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "RegisterViewController.h"
#import "ICUserModel.h"
#import "ICPayMayaRequestManager.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@property (nonatomic, strong) ICUserModel *user;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = ((AppDelegate *)[UIApplication sharedApplication].delegate).user;
    
    if (self.user.paymayaId)
    {
        ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
        [manager getCustomerDetailsWithUser:self.user
                              finishedBlock:^(NSDictionary *returnParameters, NSError *error)
         {
             if (returnParameters)
             {
                 ICUserModel *user = [[ICUserModel alloc] initWithDictionary:returnParameters];
                 ((AppDelegate *)[UIApplication sharedApplication].delegate).user = user;
                 self.user = user;
                 [self setTextFieldValues];
                 [self.registerButton setTitle:@"Update" forState:UIControlStateNormal];
             }
             else
             {
                 NSLog(@"Error %@", error);
                 [self showAlertWithTitle:@"ERROR!" message:@"An error occured"];
             }
         }];
    }
}

- (void)getDataFromFields
{
    self.user.lastName = self.lastNameField.text;
    self.user.firstName = self.firstNameField.text;
    self.user.middleName = self.middleNameField.text;
    self.user.birthday = self.birthdateField.text;
    self.user.sex = self.sexField.text;
    self.user.phone = self.phoneField.text;
    self.user.email = self.emailField.text;
    self.user.address1 = self.address1Field.text;
    self.user.address2 = self.address2Field.text;
    self.user.city = self.cityField.text;
    self.user.state = self.provinceField.text;
    self.user.zipcode = self.zipCodeField.text;
    self.user.countryCode = self.countryField.text;
}

- (void)setTextFieldValues
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.lastNameField.text = self.user.lastName;
        self.firstNameField.text = self.user.firstName;
        self.middleNameField.text = self.user.middleName;
        self.birthdateField.text = self.user.birthday;
        self.sexField.text = self.user.sex;
        self.phoneField.text = self.user.phone;
        self.emailField.text = self.user.email;
        self.address1Field.text = self.user.address1;
        self.address2Field.text = self.user.address2;
        self.cityField.text = self.user.city;
        self.provinceField.text = self.user.state;
        self.zipCodeField.text = self.user.zipcode;
        self.countryField.text = self.user.countryCode;
    });
}

- (IBAction)registerUser:(id)sender
{
    ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
    [self getDataFromFields];
    [manager createPaymayaUserWithUserModel:self.user finishedBlock:^(NSDictionary *returnParameters, NSError *error)
    {
        if (returnParameters)
        {
            self.user.paymayaId = [returnParameters objectForKey:@"id"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if (defaults)
            {
                [defaults setObject:self.user.paymayaId forKey:@"paymayaId"];
                [defaults synchronize];
                NSLog(@"ID %@", [defaults objectForKey:@"paymayaId"]);
            }
        }
        else
        {
            NSLog(@"Error %@", error);
            [self showAlertWithTitle:@"ERROR!" message:@"An error occured"];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
