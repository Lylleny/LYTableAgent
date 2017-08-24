//
//  SNSection.h
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNCellObject.h"

@interface SNSection : NSObject
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) UIView *sectionHeaderView;

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIView *footView;

+ (instancetype)section;
- (void)addCellObject:(SNCellObject *)cellObejct;
- (void)addCellObjectsFromArray:(NSArray *)objects;

- (void)insertCellObject:(SNCellObject *)cellObject atIndex:(NSUInteger)index;
- (void)insertCellObjects:(NSArray<SNCellObject *> *)cellObjects atIndex:(NSUInteger)index;

- (void)deleteCellObject:(SNCellObject *)cellObject;
- (void)deleteCellObjects:(NSArray<SNCellObject *> *)cellObjects;
- (void)deleteCellObjectsAtIndexes:(NSIndexSet *)indexes;

- (void)deleteCellObjectAtIndex:(NSInteger)index;

- (NSInteger)indexOfCellObject:(SNCellObject *)cellObject;
- (SNCellObject *)cellObjectAtIndex:(NSInteger)index;

- (void)removeAllCells;
@end
