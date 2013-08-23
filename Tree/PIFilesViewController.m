//
//  PIFilesViewController.m
//  Tree
//
//  Created by pavan on 8/22/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PIFilesViewController.h"
#import "PINodeHandler.h"

@interface PIFilesViewController ()
@property (nonatomic, strong) NSMutableArray *nodesArray;
@property (nonatomic, strong) PINode *parentNode;
@end

@implementation PIFilesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithParentNode:(PINode *)node
{
    self = [super init];
    {
        _parentNode = node;
        
        NSMutableArray *array = [NSMutableArray array];
        self.nodesArray = array;
        
        [self updateTitle];
        [self fetchTheChildrenNodes];
    }
    return self;
}

- (void)awakeFromNib
{
    NSMutableArray *array = [NSMutableArray array];
    self.nodesArray = array;
    
    PINode * rootNode = [[PINodeHandler sharedInstance] getTheRootNode];
    
    if (!rootNode) {
        [[PINodeHandler sharedInstance] createRootFolderWithName:@"root_node"];
        //[[PINodeHandler sharedInstance] createChilrenNodesWith:@[@{@"name": @"ch1", @"type": [NSNumber numberWithInteger:fileTypeImage], @"data" : @"data"}] forParentWithName:@"root_node"];
        
        PINode *rootNode = [[PINodeHandler sharedInstance] getTheRootNode];
        NSLog(@"Root node is %@", rootNode);
        
        [self.nodesArray addObject:rootNode];
        _parentNode = Nil;
    }
    
    
    [self updateTitle];
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

- (void)setParentNode:(PINode *)parentNode
{
    _parentNode = parentNode;
    
    NSMutableArray *array = [NSMutableArray array];
    self.nodesArray = array;
    
    [self updateTitle];
    [self fetchTheChildrenNodes];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addChildNode)]];
    
}

#pragma mark - Private methods
- (void)updateTitle
{
    self.title = self.parentNode == nil? @"Folder": self.parentNode.nodeName;
}

- (void)fetchTheChildrenNodes
{
    if (self.parentNode) {
        [[PINodeHandler sharedInstance] getTheNodeWithName:self.parentNode.nodeName withCallBack:^(BOOL success, id result) {
            if (success) {
                if (result) {
                    PINode *node = (PINode *) result;
                    [self.nodesArray removeAllObjects];
                    [self.nodesArray addObjectsFromArray:node.childrenNodes];
                    [self.tableView reloadData];
                }
            }
        }];
    }
}

#pragma mark - Action methods
- (void)addChildNode
{
    NSString *str = [NSString stringWithFormat:@"%@_ch%d", self.parentNode.nodeName, [self.nodesArray count]];
    
    [[PINodeHandler sharedInstance] createChilrenNodesWith:@[@{@"name": str, @"type": [NSNumber numberWithInteger:fileTypeFolder], @"data" : @"data"}] forParentWithName:self.parentNode.nodeName];
    
    [self fetchTheChildrenNodes];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PINode *node = self.nodesArray[indexPath.row];
    
    if (node.fileType == fileTypeFolder) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PIFilesViewController *file = [storyBoard instantiateViewControllerWithIdentifier:@"file"];
        [file setParentNode:node];
        [self.navigationController pushViewController:file animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nodesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PINode *node = self.nodesArray[indexPath.row];
    // Configure the cell...
    [cell.textLabel setText:node.nodeName];
    [cell.detailTextLabel setText:@""];
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
