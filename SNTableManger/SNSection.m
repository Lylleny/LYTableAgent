//
//  SNSection.m
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import "SNSection.h"

@implementation SNSection {
    NSMutableArray *_mutableRows;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initialDefault];
    }
    
    return self;
}

- (NSArray *)rows {
    return [_mutableRows copy];
}

- (void)initialDefault {
    _mutableRows = [@[] mutableCopy];
}

+ (instancetype)section {
    return [[self alloc] init];
}

- (void)addCellObject:(SNCellObject *)cellObejct {
    [_mutableRows addObject:cellObejct];
}

- (void)addCellObjectsFromArray:(NSArray *)objects {
    [_mutableRows addObjectsFromArray:objects];
}

- (void)insertCellObject:(SNCellObject *)cellObject atIndex:(NSUInteger)index {
    [_mutableRows insertObject:cellObject atIndex:index];
}

- (void)insertCellObjects:(NSArray<SNCellObject *> *)cellObjects atIndex:(NSUInteger)index {
    [_mutableRows insertObjects:cellObjects atIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deleteCellObject:(SNCellObject *)cellObject {
    [_mutableRows removeObject:cellObject];
}

- (void)deleteCellObjects:(NSArray<SNCellObject *> *)cellObjects {
    [_mutableRows removeObjectsInArray:cellObjects];
}

- (void)deleteCellObjectsAtIndexes:(NSIndexSet *)indexes {
    [_mutableRows removeObjectsAtIndexes:indexes];
}

- (void)deleteCellObjectAtIndex:(NSInteger)index {
    NSAssert(index<_mutableRows.count, @"数组越界！");
    [_mutableRows removeObjectAtIndex:index];
}

- (NSInteger)indexOfCellObject:(SNCellObject *)cellObject {
    return [_mutableRows indexOfObject:cellObject];
}

- (SNCellObject *)cellObjectAtIndex:(NSInteger)index {
    return [_mutableRows objectAtIndex:index];
}

- (void)removeAllCells {
    [_mutableRows removeAllObjects];
}
@end
