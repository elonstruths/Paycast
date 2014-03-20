//
//  CreditCardBrain.h
//  Paycast
//
//  Created by Elon Weintraub on 11/20/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardBrain : NSObject
@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *Holder;
@property (nonatomic,strong) NSString *Number;
@property (nonatomic,strong) NSString *Expiration;
@property (nonatomic, strong) NSString *CVN;
@property BOOL sucessfulRetrieval;
@property BOOL decryptSuccessful;
+(CreditCardBrain *) createCardWithTitle:(NSString *)Title forPassword:(NSString *)Password;
@end
