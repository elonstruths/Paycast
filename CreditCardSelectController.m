//
//  CreditCardSelectController.m
//  Paycast
//
//  Created by Elon Weintraub on 11/12/13.
//  Copyright (c) 2013 Elon Weintraub. All rights reserved.
//

#import "CreditCardSelectController.h"
#import "StorageBrain.h"
#import "EditCardViewController.h"
#import "EnterPasswordViewController.h"
@interface CreditCardSelectController () 
@property (nonatomic, strong) NSArray *CurrentCards;
@end

@implementation CreditCardSelectController

@synthesize CurrentCards = _CurrentCards;
@synthesize delegate;
-(NSArray *)CurrentCards{
    if (!_CurrentCards)
    {
        StorageBrain *StoredCards = [[StorageBrain alloc] init];
        [StoredCards retrieveFromStorage];
        _CurrentCards = [NSArray arrayWithArray:[StoredCards titleList]];
    }
    return _CurrentCards;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([self.delegate NumberofCardsChanged:self])
    {
        self.CurrentCards = nil;
        [self.tableView reloadData];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.CurrentCards.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CardName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.CurrentCards objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [StorageBrain removeCardWithTitle:[self.CurrentCards objectAtIndex:indexPath.row]];
        self.CurrentCards = nil; //Next time table is refreshed, refresh array of cell titles
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"CreateNewCard"]) //Go to Edit View. Pass nothing, but set delegate to tell us if new card was made.
    {
      
        self.delegate = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"Choose Card"]
             )
    {
        EnterPasswordViewController *Destination = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [Destination AttemptCard:[self.CurrentCards objectAtIndex:indexPath.row]];
        self.delegate = Destination;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
