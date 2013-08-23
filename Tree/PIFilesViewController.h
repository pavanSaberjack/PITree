//
//  PIFilesViewController.h
//  Tree
//
//  Created by pavan on 8/22/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINode;
@interface PIFilesViewController : UITableViewController

- (id)initWithParentNode:(PINode *)node;

@end
