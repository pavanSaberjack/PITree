//
//  PINode.m
//  Tree
//
//  Created by pavan on 8/20/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PINode.h"

@interface PINode()

@end

@implementation PINode


//- (NSString *)description
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"name"] = self.nodeName;
//    dict[@"type"] = [NSNumber numberWithInteger:self.fileType];
//    
//    if (self.parentNode) {
//        dict[@"parent_node"] = self.parentNode;
//    }
//    
//    if (self.childrenNodes) {
//        dict[@"children_nodes"] = self.childrenNodes;
//    }
//
//    if (self.dataOfNode) {
//        dict[@"data"] = self.dataOfNode;
//    }
//    
//    return [dict description];
//}

- (PINode *)getParentNode
{
    return self.parentNode;
}

- (NSArray *)getChildrenNodes
{
    return self.childrenNodes;
}

- (id)init
{
    self = [super init];
    if (self) {
        _nodeName = nil;
        _fileType = fileTypeUnknown;
        _parentNode = nil;
        _dataOfNode = nil;
        _childrenNodes = [NSMutableArray array];
        _isRootNode = NO;
    }
    
    return self;
}

#pragma mark - Setter methods
- (void)setParentNode:(PINode *)parentNode
{
    if (parentNode == nil) {
        if (_parentNode != nil) {
            
            BOOL isNodeExists = FALSE;
            // Remove the current object from parent nodes childrens array
            for (PINode *node in _parentNode.childrenNodes) {
                if ([node isEqual:self]) {
                    isNodeExists = YES;
                    break;
                }
            }
            
            if (isNodeExists) {
                [_parentNode.childrenNodes removeObject:self];
            }
        }
        _parentNode = nil;
    }
    else
    {
        _parentNode = parentNode;
        [_parentNode.childrenNodes addObject:self];
    }
}

- (void)setFileType:(FileType)fileType
{
    _fileType = fileType;
    
    if (fileType != fileTypeFolder) {
        self.childrenNodes = nil;
    }
}


@end
