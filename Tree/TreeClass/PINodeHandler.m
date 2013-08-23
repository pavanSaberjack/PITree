//
//  PINodeHandler.m
//  Tree
//
//  Created by pavan on 8/20/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PINodeHandler.h"

typedef NS_ENUM(NSInteger, CrawlType)
{
    CrawlTypeDFS,
    CrawlTypeBFS
};



@interface PINodeHandler()
@property (nonatomic, strong) PINode *rootNode;

@end

@implementation PINodeHandler


- (id)init
{
    self = [super init];
    
    if (self) {
        //
    }
    
    return self;
}

+ (PINodeHandler *)sharedInstance
{
    static id _handler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _handler = [PINodeHandler new];
    });
    
    return _handler;
}

- (PINode *)getTheRootNode
{
    return self.rootNode;
}

- (void)getTheNodeWithName:(NSString *)nodeName withCallBack:(CrawlBlock)callBack
{
    // Crawl through the tree and get the node and send it
    [self crawlWithOption:CrawlTypeDFS withName:nodeName andCallBack:^(BOOL success, id result) {
        
        callBack(success, result);
        
        if (success) {
            // Node Found
        }
        else
        {
            // Node Not Found
        }
        
    }];
}

- (void)createNodeWithName:(NSString *)name ofType:(FileType)fileType forParentFolder:(NSString *)parentNodeName withData:(id)data withCallBack:(CreateBlock)callBack
{
    // If there is no root node then we cannot create a child node for any parent node
    if (!self.rootNode) {
        callBack(FALSE, nil);
    }
    
    // Get the node with given parent node
    [self crawlWithOption:CrawlTypeDFS withName:parentNodeName andCallBack:^(BOOL success, id result) {
        if (success) {
            if (result) {
                PINode *parentNode = (PINode *)result;
                
                // If file type is not a folder we cannot create a child node for that
                if (parentNode.fileType != fileTypeFolder) {
                    callBack(FALSE, nil);
                    return;
                }
                
                // Create the node and add it to parent nodes children nodes
                [self getNodeWithName:name ofType:fileType forParentFolder:parentNode withData:data];
            }
        }
    }];
}

- (void)createRootFolderWithName:(NSString *)name
{
    PINode *node = [self getNodeWithName:name ofType:fileTypeFolder forParentFolder:nil withData:nil];
    node.isRootNode = YES;
    self.rootNode = node;
    
}

- (void)createChilrenNodesWith:(NSArray *)array forParentWithName:(NSString *)parentName
{
    if (parentName == nil) {
        return;
    }
    
    // Get the parent node fromt the structure
    [self crawlWithOption:CrawlTypeDFS withName:parentName andCallBack:^(BOOL success, id result) {
        
        if (success) {
            if (result) {
                PINode *parentNode = (PINode *)result;
                
                for (NSDictionary *nodeDictionary in array) {
                    [self getNodeWithName:nodeDictionary[@"name"]
                                   ofType:[nodeDictionary[@"type"] integerValue]
                          forParentFolder:parentNode
                                 withData:nodeDictionary[@"data"]];
                    
                }
            }
        }
        
        
    }];
    
}

#pragma mark - Private methods
- (PINode *)getNodeWithName:(NSString *)name ofType:(FileType)fileType forParentFolder:(PINode *)parentNode withData:(id)data
{
    PINode * node = [[PINode alloc] init];
    node.nodeName = name;
    node.fileType = fileType;
    node.parentNode = parentNode;
    node.dataOfNode = data;
    
    return node;
}

// Implement different search algorithms
- (void)crawlWithOption:(CrawlType)type withName:(NSString *)name andCallBack:(CrawlBlock)callBack
{
    switch (type) {
        case CrawlTypeDFS:
        {
            [self getNodeUsingDFSWithName:name andCallBack:^(BOOL success, id result) {
                callBack(success, result);
            }];
            break;
        }
            
        case CrawlTypeBFS:
        {
            [self getNodeUsingBFSWithName:name andCallBack:^(BOOL success, id result) {
                callBack(success, result);
            }];
            break;
        }
    }
}

- (void)searchNodesWithNameHavingString:(NSString *)searchText withCallBack:(SearchBlock)callBack
{
    
}

#pragma mark - Depth First Search ALgo methods
// DFS algorithm for searching node in a tree structure
- (void)getNodeUsingDFSWithName:(NSString *)name andCallBack:(CrawlBlock)callBack
{
    // Algo
    /*
     1. If root node is nil return failure
     2. If root node is the one with the given name then return the node
     3. Go to first node and check else go to left node of child
     4. If the node dont have any child and this node is not the one we searching for then make it as marked
     5. Go to parent node and then go to second node
     
     */
    
    if (self.rootNode == nil) {
        callBack(NO, nil);
        return;
    }
    
    if ([self.rootNode.nodeName isEqualToString:name]) {
        callBack(YES, self.rootNode);
        return;
    }
    
    if ([self.rootNode.childrenNodes count] == 0) {
        callBack(NO, nil);
        return;
    }
    
    for (int i = 0; i < [self.rootNode.childrenNodes count]; i++) {
        PINode *childNode = self.rootNode.childrenNodes[i];
        
        PINode *result = [self crawlDFSForNode:childNode withNasme:name];
        if (result) {
            callBack(YES, result);
            return;
        }
    }
    
    callBack(NO, nil);
}

- (PINode *)crawlDFSForNode:(PINode *)node withNasme:(NSString *)name
{
    if ([node.nodeName isEqualToString:name]) {
        return node;
    }
    
    if ([node.childrenNodes count] == 0) {
        return nil;
    }
    
    for (int i = 0; i < [node.childrenNodes count]; i++) {
        PINode *childNode = node.childrenNodes[i];
        
        PINode *result = [self crawlDFSForNode:childNode withNasme:name];
        if (result) {
            return result;
        }
    }
    
    return nil;
}

#pragma mark - Breadth First Search ALgo methods
// BFS algorithm for searching node in a tree structure
- (void)getNodeUsingBFSWithName:(NSString *)name andCallBack:(CrawlBlock)callBack
{
    // Algo
    /*
     1. If root node is nil return failure
     2. If root node is the one with the given name then return the node
     3. Go to first node and check else go to second node of parent
     4. If all the child node of parent doesnt match then go to child node of childrens one by one
     */
    
    if (self.rootNode == nil) {
        callBack(NO, nil);
        return;
    }
    
    if ([self.rootNode.nodeName isEqualToString:name]) {
        callBack(YES, self.rootNode);
        return;
    }
    
    if ([self.rootNode.childrenNodes count] == 0) {
        callBack(NO, nil);
        return;
    }
    
    PINode *result = [self crawlBFSForNode:self.rootNode withNasme:name];
    if (result) {
        callBack(YES, result);
    }
    
    callBack(NO, nil);
}

- (PINode *)crawlBFSForNode:(PINode *)node withNasme:(NSString *)name
{
    if ([node.nodeName isEqualToString:name]) {
        return node;
    }
    
    if ([node.childrenNodes count] == 0) {
        return nil;
    }
    
    for (int i = 0; i < [node.childrenNodes count]; i++) {
        PINode *childNode = node.childrenNodes[i];
        if ([childNode.nodeName isEqualToString:name]) {
            return childNode;
        }
    }
    
    for (PINode *childNode in node.childrenNodes) {
        PINode *result = [self crawlBFSForNode:childNode withNasme:name];
        if (result) {
            return result;
        }
    }
    
    return nil;
}
@end
