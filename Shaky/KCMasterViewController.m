//
//  KCMasterViewController.m
//  Shaky
//
//  Created by Kevin Chavez on 5/2/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCMasterViewController.h"

#import "KCDetailViewController.h"

@interface KCMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_selected;
}
@end

@implementation KCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
        
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

/* Shaker */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
    
    if (!_selected) {
        _selected = [[NSMutableArray alloc] init];
    }
    
    if ([_selected containsObject:indexPath]) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [_selected removeObject:indexPath];
    } else {
        [_selected addObject:indexPath];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", _selected);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([event type] == UIEventSubtypeMotionShake) {

        // Create map array and fill it with 0s. They are all dead.
        NSMutableArray *alllist = [NSMutableArray arrayWithCapacity:[_objects count]];
        for (int i = 0; i < [_objects count]; i++) {
            [alllist addObject:[NSNumber numberWithBool:NO]];
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
        }

        // Let some of them live!
        for (NSIndexPath *ip in _selected) {
            [alllist setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:[ip row]];
            //[saved addObject:[_objects objectAtIndex:[ip row]]];
        }
        
                
        
        NSMutableArray *hitlist = [NSMutableArray array];
        NSMutableIndexSet *killset = [NSMutableIndexSet indexSet];
        int index = 0;
        for (NSNumber *lives in alllist) {
            if (![lives boolValue]) {
                [killset addIndex:index];
                [hitlist addObject:[NSIndexPath indexPathForItem:index inSection:0]];
            }
            index++;
        }
        [_objects removeObjectsAtIndexes:killset];
        
        [self.tableView deleteRowsAtIndexPaths:hitlist withRowAnimation:UITableViewRowAnimationLeft];
        _selected = nil;
    }
}


@end
