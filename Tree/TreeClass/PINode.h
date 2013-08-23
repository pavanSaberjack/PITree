//
//  PINode.h
//  Tree
//
//  Created by pavan on 8/20/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

typedef NS_ENUM(NSInteger, FileType)
{
    fileTypeUnknown,
    fileTypeFolder,
    fileTypePDF,
    fileTypeText,
    fileTypeImage
};


#import <Foundation/Foundation.h>

@interface PINode : NSObject
@property (nonatomic, strong) NSString *nodeName;
@property (nonatomic, strong) PINode *parentNode;
@property (nonatomic, strong) id dataOfNode;
@property (nonatomic, readwrite) FileType fileType;
@property (nonatomic, strong) NSMutableArray *childrenNodes;
@property (nonatomic, readwrite) BOOL isRootNode;
@end