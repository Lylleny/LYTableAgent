//
//  SNIndexPathHeightCache.m
//  NormalHeader
//
//  Created by 颜阿龙 on 2017/8/24.
//  Copyright © 2017年 Lylleny. All rights reserved.
//

#import "SNIndexPathHeightCache.h"

@implementation SNIndexPathHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightsBySection = [NSMutableArray array];
    }
    return self;
}

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySection[indexPath.section][indexPath.row];
    return ![number isEqualToNumber:@-1];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySection[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySection[indexPath.section][indexPath.row];
    return number.floatValue;
}

- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySection[indexPath.section][indexPath.row] = @-1;
}

- (void)invalidateAllHeightCache {
    [self.heightsBySection removeAllObjects];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    for (NSInteger section = 0; section <= targetSection; ++section) {
        if (section >= self.heightsBySection.count) {
            self.heightsBySection[section] = [NSMutableArray array];
        }
    }
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section {
    NSMutableArray *heightsByRow = self.heightsBySection[section];
    for (NSInteger row = 0; row <= targetRow; ++row) {
        if (row >= heightsByRow.count) {
            heightsByRow[row] = @-1;
        }
    }
}
@end


