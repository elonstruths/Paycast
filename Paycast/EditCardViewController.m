//
//  EditCardViewController.m
//  Paycast
//
//  Created by Elon Weintraub on 11/27/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import "EditCardViewController.h"
#import "StorageBrain.h"

@interface EditCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *CardNumber;
@property (strong, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UITextField *HolderName;
@property (weak, nonatomic) IBOutlet UITextField *CVN;
@property (weak, nonatomic) IBOutlet UIDatePicker *ExpDate;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *RetypePass;
@property BOOL GoodTitle,GoodCardNumber, GoodHoldername, GoodCVN, GoodExpDate, GoodPassword, PasswordsMatch, AllGood, CreditCardAdded;
@property (strong, nonatomic) UIColor *GoodColor;
@property (strong, nonatomic) UIColor *BadColor;
@property (strong, nonatomic)NSString *dateString;
@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)moveUpFromUnderKeyboard:(UIView *)viewToMove;
-(void)moveBack:(UIView *)viewToMove;
@end

@implementation EditCardViewController
const int pullUp = -215;//Enough to get out from Keyboard. Note:Positive moves down?
const float pullUpTime = 0.3f;
@synthesize GoodTitle, GoodCardNumber, GoodCVN, GoodExpDate, GoodHoldername, GoodPassword, PasswordsMatch, CreditCardAdded;
@synthesize Title,HolderName, RetypePass, Password, CardNumber, ExpDate, CVN, dateString;
@synthesize GoodColor = _GoodColor;
@synthesize BadColor = _BadColor;
@synthesize dateFormat = _dateFormat;
@synthesize SaveButton,CancelButton;
-(UIColor *)GoodColor
{
    if (!_GoodColor) {
        _GoodColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.3];
    }
    return _GoodColor;
}
-(UIColor *)BadColor
{
    if (!_BadColor){
        _BadColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:0.3];
    }
    return _BadColor;
}
-(NSDateFormatter *)dateFormat
{
    if (_dateFormat == nil)
    {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"dd/MM/yyyy"];
    }
    return _dateFormat;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *Now  = [NSDate date];
    NSDate *tenYearsFromNow = [NSDate dateWithTimeIntervalSinceNow:315568800];
    self.ExpDate.minimumDate = Now;
    self.ExpDate.maximumDate = tenYearsFromNow;
    
    //Configure the Date Picker for convenience.
    //For existing cards with a date that has expired, we will take care of them when we come to it.
    self.SaveButton.layer.cornerRadius = 10.0;
    self.SaveButton.layer.borderWidth = 1.0;
    self.CancelButton.layer.cornerRadius = 10.0;
    self.CancelButton.layer.borderWidth = 1.0;
    //Hopefully make our buttons look a little nicer
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moveUpFromUnderKeyboard:(UIView *)viewToMove
{
    [UIView beginAnimations:@"UP" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:pullUpTime];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, pullUp);
    [UIView commitAnimations];
}
- (void)moveBack:(UIView *)viewToMove
{
    [UIView beginAnimations:@"UP" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:pullUpTime];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, 0 - pullUp);
    [UIView commitAnimations];
}

#pragma mark - Text field Action Responses

- (IBAction)TitleEntered:(id)sender {
    if ([self.Title.text isEqualToString:self.Title.placeholder])
    {
        self.GoodTitle = NO;
    }
    else
    {
        NSString *Regex = @"^\\w[\\w '\"]+$";
        NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        if ([Test evaluateWithObject:self.Title.text])
        {
            self.GoodTitle = YES;
            self.Title.backgroundColor = self.GoodColor;
        }
        else
        {
            self.GoodTitle = NO;
            self.Title.backgroundColor = self.BadColor;
        }
    }
    [sender resignFirstResponder];
}

- (IBAction)HolderNameEntered:(id)sender {
    if ([self.HolderName.text isEqualToString:self.HolderName.placeholder])
    {
        self.GoodHoldername = NO;

    }
    else if (!self.HolderName.text)
    {
        self.GoodHoldername = NO;
        self.HolderName.backgroundColor = self.BadColor;
    }
    else {
        self.GoodHoldername = YES;
        self.HolderName.backgroundColor = self.GoodColor;
    }
    [self.HolderName setNeedsDisplay];
    [sender resignFirstResponder];
}
- (IBAction)CardNumberEntered:(id)sender {
    NSString *Regex = @"^\\d{16}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    if ([self.CardNumber.text isEqualToString:self.CardNumber.placeholder])
    {
        self.GoodCardNumber = NO;
        
    }
       else if ([Test evaluateWithObject:self.CardNumber.text])
    {
        self.GoodCardNumber = YES;
        self.CardNumber.backgroundColor = self.GoodColor;
    }
       else {
           self.CardNumber.backgroundColor = self.BadColor;
           self.GoodCardNumber = NO;
       }
    [self.CardNumber setNeedsDisplay];
    [sender resignFirstResponder];
}
- (IBAction)CVNEntered:(id)sender {
    NSString *Regex = @"^\\d{3}$"; 
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    if ([self.CVN.text isEqualToString:self.CVN.placeholder])
    {
        self.CVN = NO;
        
    }
    else if ([Test evaluateWithObject:self.CVN.text])
    {
        self.GoodCVN = YES;
        self.CVN.backgroundColor = self.GoodColor;
    }
    else {
        self.CVN.backgroundColor = self.BadColor;
        self.GoodCVN = NO;
    }
    [self.CVN setNeedsDisplay];
    [sender resignFirstResponder];
}
- (IBAction)DoPasswordsMatch:(id)sender {
    if ([self.RetypePass.text isEqualToString:self.RetypePass.placeholder]) {
        self.PasswordsMatch = NO; 
    }
    else if ([self.RetypePass.text isEqualToString:self.Password.text ])
    {
        self.PasswordsMatch = YES;
        self.Password.backgroundColor = self.GoodColor;
        self.RetypePass.backgroundColor = self.GoodColor;
    }
    else {
        self.Password.backgroundColor = self.BadColor;
        self.RetypePass.backgroundColor = self.BadColor;
    }
    [self.Password setNeedsDisplay];
    [self.RetypePass setNeedsDisplay];
    [sender resignFirstResponder];
}
#pragma mark - UITextfieldDelegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{ //This checks before the edit whether the maxlength is exceeded. If yes, prevent edit
        NSUInteger newLength = textField.text.length + string.length - range.length;
        NSUInteger maxLength;
    if ([textField isEqual:self.CVN])
    {
        maxLength = 3;
    }
    else if ([textField isEqual:self.CardNumber])
    {
        maxLength = 16;
    }
    else maxLength = 100; //How long should a name or password be?
    return (newLength > maxLength) ? NO:YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.Password] || [textField isEqual:self.RetypePass])
    {
        [self moveUpFromUnderKeyboard:self.MainView];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.Password] || [textField isEqual:self.RetypePass])
    {
        [self moveBack:self.MainView];
    }
}
- (IBAction)PasswordEntered:(id)sender {
    [sender resignFirstResponder];
}
#pragma  mark - Dismissals
- (IBAction)Save:(id)sender {
    self.dateString = [self.dateFormat stringFromDate:self.ExpDate.date];
    //Get Latest Date
    if (self.dateString)
    {
        self.GoodExpDate = YES;
        
    }
    if ((self.GoodTitle && self.GoodHoldername && self.GoodCardNumber && self.GoodCVN && self.GoodExpDate && self.PasswordsMatch) || 1)
    {
        //Validate Card - Not implemented
        StorageBrain *EnterCard =  [StorageBrain newCardFromUserDataWithTitle:self.Title.text withHolder:self.HolderName.text withNumber:self.CardNumber.text withCVN:self.CVN.text withExpiration:self.dateString withPass:self.Password.text];
        [EnterCard storeCards];
        NSDictionary *CardAndPass = [NSDictionary dictionaryWithObject:self.Title.text forKey:@"CurrentCard"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CurrentCard" object:self userInfo:CardAndPass];
        self.CreditCardAdded = YES;
        //Will send CardAndPass containing the one card and key. userInfo takes only dictionaries, so CardAndPass was contrained to be used in somewhat of a clunky manner.
        [self.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)Cancel:(id)sender {
    self.CreditCardAdded = NO;
    [self.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -CreditCardSelectControllerDelegate
-(BOOL)NumberofCardsChanged:(CreditCardSelectController *)sender
{
    if (self.CreditCardAdded)
    {
        return YES;
    }
    return NO;
}
@end