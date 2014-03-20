//
//  CreditCardBrain.m
//  Paycast
//
//  Created by Elon Weintraub on 11/20/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import "CreditCardBrain.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "StorageBrain.h"

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;

@implementation CreditCardBrain
@synthesize Holder = _Holder;
@synthesize Number = _Number;
@synthesize Expiration = _Expiration;
@synthesize CVN = _CVN;
@synthesize Title = _Title;
-(NSString *)Holder
{
    if (_Holder == nil)
    {
        _Holder = [[NSString alloc] init];
    }
    return _Holder;
}
-(NSString *)Number
{
    if (_Number == nil)
    {
        _Number = [[NSString alloc] init];
    }
    return _Number;
}
-(NSString *)Expiration{
    if (_Expiration == nil)
    {
        _Expiration = [[NSString alloc] init];
    }
    return _Expiration;
}
-(NSString *)CVN
{
    if (_CVN == nil)
    {
        _CVN = [[NSString alloc] init];
    }
    return _CVN; //Lazily instantiate our dictionary
}
-(NSString *)Title
{
    if (_Title == nil)
    {
        _Title = [[NSString alloc] init];
    }
    return _Title; //Lazily instantiate our dictionary
}
+(CreditCardBrain *)createCardWithTitle:(NSString *)Title forPassword:(NSString *)Password
{
    CreditCardBrain *Card = [[CreditCardBrain alloc] init];
    Card.sucessfulRetrieval = FALSE;
    StorageBrain *FindCard = [[StorageBrain alloc] init];
    [FindCard retrieveFromStorage];
    Card.Title = Title;
    NSData *CardData = [NSData dataWithData:[FindCard.CreditCards valueForKey:Title]];
    int saltStartsAt = CardData.length - kPBKDFSaltSize;
    int ivStartsAt = CardData.length - kPBKDFSaltSize - kAlgorithmIVSize;
    int messageLength = CardData.length - kPBKDFSaltSize - kAlgorithmIVSize;
    NSData *Salt = [NSData dataWithBytesNoCopy:(char *)[[CardData subdataWithRange:NSMakeRange(saltStartsAt, kPBKDFSaltSize)] bytes] length:kPBKDFSaltSize];
    // Contruct a subdata of correct range, then get its bytes, use for dataWithBytesNoCopy and the length is the salt length. Recast type of data because of C++ annoyance dataWithBytesNoCopy expects the wrong type in the buffer. Final result is a pointer Salt pointing at a memory location in the original object.
    NSData *IV = [NSData dataWithBytesNoCopy:(char *)[[CardData subdataWithRange:NSMakeRange(ivStartsAt, kAlgorithmIVSize)] bytes] length:kAlgorithmIVSize];
    NSData *Message = [NSData dataWithBytesNoCopy:(char *)[[CardData subdataWithRange:NSMakeRange(0, messageLength)] bytes] length:messageLength];
    NSData *Key = [StorageBrain AESKeyForPassword:Password salt:Salt];
    size_t outLength;
    NSMutableData *cardJSONData = [NSMutableData dataWithLength:Message.length + kAlgorithmBlockSize];
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kAlgorithm, kCCOptionPKCS7Padding, Key.bytes, Key.length, IV.bytes, Message.bytes, Message.length, cardJSONData.mutableBytes, cardJSONData.length, &outLength);
    if (result == kCCSuccess) {
        cardJSONData.length = outLength;
    }
    else if (result == kCCDecodeError)
    {
        NSLog(@"Invalid Password");
        return Card;
    }
    else {
        NSLog(@"Other Error with decryption!");
        Card.decryptSuccessful = FALSE;
        return Card;
    }
    NSError *parseError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cardJSONData options:0 error:&parseError];
    if (parseError)
    {
        NSLog(@"Error parsing JSON");
        Card.decryptSuccessful = FALSE;
        return Card;
    }
    if (![Card.Title isEqualToString:[jsonDictionary valueForKey:@"Title"]])
    {
        NSLog(@"Title Mismatch");
        Card.Holder = [jsonDictionary valueForKey:@"Holder"];
        Card.Number = [jsonDictionary valueForKey:@"Number"];
        Card.Expiration = [jsonDictionary valueForKey:@"Expiration"];
        Card.CVN = [jsonDictionary valueForKey:@"CVN"];
        Card.sucessfulRetrieval = FALSE;
        return Card;
    }
    Card.Holder = [jsonDictionary valueForKey:@"Holder"];
    Card.Number = [jsonDictionary valueForKey:@"Number"];
    Card.Expiration = [jsonDictionary valueForKey:@"Expiration"];
    Card.CVN = [jsonDictionary valueForKey:@"CVN"];
    Card.sucessfulRetrieval = TRUE;
    return Card;
}
@end
