//
//  SNIndexPathHeightCache.h
//  NormalHeader
//
//  Created by 颜阿龙 on 2017/8/24.
//  Copyright © 2017年 Lylleny. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface SNIndexPathHeightCache : NSObject
@property (nonatomic, strong) NSMutableArray *heightsBySection;

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths;
- (void)buildSectionsIfNeeded:(NSInteger)targetSection;
- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section;
- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllHeightCache;
@end
