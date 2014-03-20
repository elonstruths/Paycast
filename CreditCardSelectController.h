//
//  CreditCardSelectController.h
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditCardSelectController;
@protocol CreditCardSelectControllerDelegate <NSObject>
@required
-(BOOL)NumberofCardsChanged:(CreditCardSelectController *)sender;
@end

@interface CreditCardSelectController : UITableViewController
@property (nonatomic, weak) id <CreditCardSelectControllerDelegate> delegate;
@end
