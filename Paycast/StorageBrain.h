//
//  StorageBrain.h
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageBrain : NSObject
+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt;
- (void)storeCards;
+ (NSData *)randomDataOfLength:(size_t)length;
-(void)retrieveFromStorage;
+(StorageBrain *)newCardFromUserDataWithTitle:(NSString *)Title withHolder:(NSString *)holderName withNumber:(NSString *) Number withCVN:(NSString *)CVN withExpiration:(NSString *) Expiration withPass:(NSString *) Password;
-(NSArray *)titleList;
+(void)removeCardWithTitle:(NSString *)Key;
@property (nonatomic,strong) NSMutableDictionary *CreditCards;
@end
