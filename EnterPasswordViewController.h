//
//  EnterPasswordViewController.h
//  Paycast
//
//  Created by Elon Weintraub on 2/6/14.
//  Copyright (c) 2014 Elon Weintraub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardSelectController.h"
@interface EnterPasswordViewController : UIViewController <CreditCardSelectControllerDelegate>
-(void)AttemptCard:(NSString *) title;
@end
