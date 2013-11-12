//
//  StorageBrain.m
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import "StorageBrain.h"

@implementation StorageBrain
@synthesize CreditCards = _CreditCards;
-(NSMutableDictionary *)CreditCards;
{
    if (_CreditCards == nil) _CreditCards = [[NSMutableDictionary alloc] init];
    return _CreditCards;
}
-(void)retrieveFromStorage:(NSMutableDictionary *)CreditCards
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *getStore = [defaults dictionaryForKey:@"CreditList"];
    [CreditCards addEntriesFromDictionary:getStore];
}
-(void)storeCards:(NSDictionary *)CreditCards
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CreditCards forKey:@"CreditList"];
}
-(NSArray *)TitleList:(NSDictionary *)CreditCards
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [CreditCards objectEnumerator];
    id Value;
    while (Value == enumerator.nextObject)
    {
        [titles addObject:Value];
    }
    NSArray *titlesReturn = [NSArray arrayWithArray:titles];
    return titlesReturn;
}
-(void)NewCardFromUserData:(NSMutableDictionary *)CreditCards withTitle:(NSString *)Title withHolder:(NSString *)holderName withNumber:(int) Number withCVN:(int)CVN withExpiration:(NSString *) Expiration withPass:(NSString *) Password
    {
        if(Title &&holderName && Number && CVN && Expiration)
        {
            NSString *xmlData = [NSString stringWithFormat:@"<card>\n<name>%@</name>\n<holder>%@</holder>\n<number>%16.16d</number>\n<cvn>%3.3d</cvn>/n<expiration>%@</expiration>\n</card>",Title,holderName,Number,CVN,Expiration];
            
    }
@end
