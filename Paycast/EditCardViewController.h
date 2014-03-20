//
//  EditCardViewController.h
//  Paycast
//
//  Created by Elon Weintraub on 11/27/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardSelectController.h"

@interface EditCardViewController : UIViewController <UITextFieldDelegate, CreditCardSelectControllerDelegate>
-(void)EditCardWithTitle:(NSString *)cardTitle withHolder:(NSString *)cardHolderName withNumber:(NSString *) cardNumber withCVN:(NSString *)cardCVN withExpiration:(NSString *) cardExpiration;
@end
