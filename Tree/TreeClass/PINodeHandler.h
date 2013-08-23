//
//  PINodeHandler.h
//  Tree
//
//  Created by pavan on 8/20/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINode.h"

typedef void(^CrawlBlock)(BOOL success, id result);
typedef void(^SearchBlock)(BOOL success, id result);
typedef void(^CreateBlock)(BOOL success, id result);
@interface PINodeHandler : NSObject

+ (PINodeHandler *)sharedInstance;

// Returns the root node object, returns nil if no file/folder is there
- (PINode *)getTheRootNode;

// Get the node with a given name
- (void)getTheNodeWithName:(NSString *)nodeName withCallBack:(CrawlBlock)callBack;

// Creates node with the name and type and data
- (void)createNodeWithName:(NSString *)name ofType:(FileType)fileType forParentFolder:(NSString *)parentNodeName withData:(id)data withCallBack:(CreateBlock)callBack;

// Method just to create a dummy folder for root
- (void)createRootFolderWithName:(NSString *)name;

// Creating child nodes for parent with name 
- (void)createChilrenNodesWith:(NSArray *)array forParentWithName:(NSString *)parentName;

// Search the files with names
- (void)searchNodesWithNameHavingString:(NSString *)searchText withCallBack:(SearchBlock)callBack;
@end
