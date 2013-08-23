//
//  PIViewController.m
//  Tree
//
//  Created by pavan on 8/20/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PIViewController.h"
#import "PINodeHandler.h"

@interface PIViewController ()
@property (nonatomic, weak) IBOutlet UIButton *viewButton;
@end

@implementation PIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    [self.viewButton addTarget:self action:@selector(viewFilesController) forControlEvents:UIControlEventTouchUpInside];
    
    [[PINodeHandler sharedInstance] createRootFolderWithName:@"root_node"];
    NSLog(@"Root node is %@", [[PINodeHandler sharedInstance] getTheRootNode]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewFilesController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main.storyboard" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = [storyBoard instantiateViewControllerWithIdentifier:@"navController"];
    [self presentViewController:navController animated:YES completion:^{
        //
    }];
}


@end
