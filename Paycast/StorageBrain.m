//
//  StorageBrain.m
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import "StorageBrain.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4



@implementation StorageBrain : NSObject
@synthesize CreditCards = _CreditCards;
-(NSMutableDictionary *)CreditCards
{
    if (_CreditCards == nil)
    {
        _CreditCards = [[NSMutableDictionary alloc] init];
    }
    return _CreditCards; //Lazily instantiate our dictionary
}
-(void)retrieveFromStorage
{
    NSDictionary *getStore = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"CreditList"];
    [self.CreditCards addEntriesFromDictionary:getStore];
}
-(void)storeCards
{
    [[NSUserDefaults standardUserDefaults] setObject:self.CreditCards forKey:@"CreditList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)titleList //Create a list of all Keys and save in an array
{
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    NSEnumerator   *Count = [self.CreditCards keyEnumerator];
    id key;
    while (key = [Count nextObject]){
        [keyList addObject:key];
    }
    NSArray *returnValue = [NSArray arrayWithArray:keyList];
    return returnValue;
}
+(StorageBrain *)newCardFromUserDataWithTitle:(NSString *)Title withHolder:(NSString *)holderName withNumber:(NSString *) Number withCVN:(NSString*)CVN withExpiration:(NSString *) Expiration withPass:(NSString *) Password
    {
        if(Title && holderName && Number && CVN && Expiration)
        {
            NSError *parseError = nil;
            NSDictionary *jsonDictionary = @{@"Name": Title, @"Holder": holderName, @"Number": Number, @"CVN": CVN, @"Expiration": Expiration};
        //datafy xmlData and encrypt.
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&parseError];
            NSData *salt = [[self class] randomDataOfLength:kPBKDFSaltSize];
            NSData *iv = [[self class] randomDataOfLength:kAlgorithmIVSize];
            NSData *key = [[self class] AESKeyForPassword:Password salt:salt];
            size_t outSize;
            NSMutableData *encrypted = [NSMutableData dataWithLength:(jsonData.length + kAlgorithmBlockSize)];
            CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, key.length, iv.bytes, jsonData.bytes, jsonData.length, encrypted.mutableBytes, encrypted.length, &outSize);
            if (result == kCCSuccess) {
                encrypted.length = outSize;
                NSMutableData *valueToStore = [NSMutableData dataWithData:encrypted];
                [valueToStore appendBytes:iv.bytes length:iv.length];
                [valueToStore appendBytes:salt.bytes length:salt.length];
                //Storing encrypted string then Initialization Vector then Salt.
                StorageBrain *NewBrain = [[StorageBrain alloc] init];
                [NewBrain retrieveFromStorage];
                [NewBrain.CreditCards setObject:valueToStore forKey:Title];
                return NewBrain;
            }
            
        }
        return nil;
    }
+ (void)removeCardWithTitle:(NSString *)Key
{
    StorageBrain *Current = [[StorageBrain alloc] init];
    [Current retrieveFromStorage];
    if (![[Current.CreditCards valueForKey:Key] isEqualToData:nil])
    {
        [Current.CreditCards removeObjectForKey:Key];
        [Current storeCards];
        
    }
}
#pragma mark - Internal encryption functions
+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt //Key generation algorithm c/o Rob Napier
{
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  password.length,  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}
+ (NSData *)randomDataOfLength:(size_t)length //Use to create initialization vector and salt
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    return data;
}

@end
