//
//  StorageBrain.h
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageBrain : NSObject
@property (nonatomic,strong) NSMutableDictionary *CreditCards;
-(NSMutableDictionary *)retrieveFromStorage;
@end
