//
//  EnterPasswordViewController.m
//  Paycast
//
//  Created by Elon Weintraub on 2/6/14.
//  Copyright (c) 2014 Elon Weintraub. All rights reserved.
//

#import "EnterPasswordViewController.h"
#import "CreditCardBrain.h"
#import "StorageBrain.h"

@interface EnterPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UILabel *RespondToUser;
@property (weak, nonatomic) IBOutlet UILabel *ShowTitle;
@property (weak, nonatomic) IBOutlet UIButton *Choose;
@property (weak, nonatomic) IBOutlet UIButton *Edit;
@property (weak, nonatomic) IBOutlet UIButton *Delete;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) UIColor *BadColor;
@property (strong, nonatomic) NSString *CardTitle;
@property BOOL CreditCardDeleted;
@end

@implementation EnterPasswordViewController
@synthesize BadColor = _BadColor;
@synthesize CardTitle = _CardTitle;
-(NSString *)CardTitle {
    if (_CardTitle == nil) {
        _CardTitle = [[NSString alloc] init];
    }
    return _CardTitle;
}
-(void)AttemptCard:(NSString *)title //Call this from previous screen
{
    self.CardTitle = title;
}
-(UIColor *)BadColor
{
    if (!_BadColor){
        _BadColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:0.3];
    }
    return _BadColor;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)CancelPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)DeletePushed:(id)sender {
    self.CreditCardDeleted = YES;
    [StorageBrain removeCardWithTitle:self.CardTitle];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ShowTitle.text = self.CardTitle;
    self.Choose.layer.cornerRadius = 10.0;
    self.Choose.layer.borderWidth = 1.0;
    self.Delete.layer.cornerRadius = 10.0;
    self.Delete.layer.borderWidth = 1.0;
    self.Edit.layer.cornerRadius = 10.0;
    self.Edit.layer.borderWidth = 1.0;
    self.CancelButton.layer.cornerRadius = 10.0;
    self.CancelButton.layer.borderWidth = 1.0;


}
- (IBAction)EditPushed:(id)sender {
    CreditCardBrain *cardToEdit = [CreditCardBrain createCardWithTitle:self.title forPassword:self.Password.text];
    if (cardToEdit.sucessfulRetrieval)
    {
        [self performSegueWithIdentifier:@"Unlock Edit" sender:sender];
    }
    else if ([self.Password.text isEqualToString:nil])
    {
        self.Password.backgroundColor = self.BadColor;
        self.RespondToUser.text = @"Enter Password";
    }
    else
    {
        self.Password.backgroundColor = self.BadColor;
        self.RespondToUser.text = @"Invalid Password";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Responses and connections
-(BOOL)NumberofCardsChanged:(CreditCardSelectController *)sender
{
    if (self.CreditCardDeleted)
    {
        return YES;
    }
    return NO;
}

@end
