//
//  SNTableManager.m
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import "SNTableManager.h"
#import "SNCell.h"
#import "SNCellObject.h"
#import "SNTableConfiguration.h"

@interface SNTableManager ()
@property (nonatomic, strong) SNIndexPathHeightCache *heightCache;
@end

@implementation SNTableManager {
    NSMutableArray *_mutableSections;
}

#pragma mark - getter & setter
- (SNIndexPathHeightCache *)heightCache {
    if (!_heightCache) {
        _heightCache = [[SNIndexPathHeightCache alloc] init];
    }
    return _heightCache;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    _tableView = tableView;
    
    _mutableSections = [@[] mutableCopy];
    
    return self;
}

- (NSArray *)sections {
    return _mutableSections;
}

- (void)addSection:(SNSection *)section {
    [_mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)objects {
    [_mutableSections addObjectsFromArray:objects];
}

- (void)removeAllSections {
    [_mutableSections removeAllObjects];
}

- (void)insertCellObjects:(NSArray<SNCellObject *> *)cellObjects
             atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
         withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSAssert(cellObjects.count==indexPaths.count, @"cellObjects数量与indexPaths数量不一致！");
    
    if (!cellObjects || !indexPaths || cellObjects.count==0 || indexPaths.count==0) {
        return;
    }
    
    [self.heightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *rows = self.heightCache.heightsBySection[indexPath.section];
        [rows insertObject:@-1 atIndex:indexPath.row];
    }];
    
    for (int i=0; i<indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        SNSection *section = _mutableSections[indexPath.section];
        [section insertCellObject:cellObjects[i] atIndex:indexPath.row];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
}

- (void)deleteAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
          withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (!indexPaths || indexPaths.count==0) {
        return;
    }
    
    [self.heightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
    NSMutableDictionary *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
        if (!mutableIndexSet) {
            mutableIndexSet = [NSMutableIndexSet indexSet];
            mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
        }
        [mutableIndexSet addIndex:indexPath.row];
    }];
    [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
        NSMutableArray *rows = self.heightCache.heightsBySection[key.integerValue];
        [rows removeObjectsAtIndexes:indexSet];
    }];
    
    NSMutableDictionary *willDeletedCellObjectsDictionary = @{}.mutableCopy;
    for (int i=0; i<indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        NSMutableIndexSet *indexSet = willDeletedCellObjectsDictionary[@(indexPath.section)];
        if (!indexSet) {
            indexSet = [NSMutableIndexSet indexSet];
            willDeletedCellObjectsDictionary[@(indexPath.section)] = indexSet;
        }
        [indexSet addIndex:indexPath.row];
    }
    for (int i=0; i<willDeletedCellObjectsDictionary.allKeys.count; i++) {
        NSInteger sectionIndex = [willDeletedCellObjectsDictionary.allKeys[i] integerValue];
        SNSection *section = [self sectionAtIndex:sectionIndex];
        [section deleteCellObjectsAtIndexes:willDeletedCellObjectsDictionary[@(sectionIndex)]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
}

- (void)reload {
    // remove all caches
    [self.heightCache.heightsBySection removeAllObjects];
    [_tableView reloadData];
}

- (void)reloadSection:(SNSection *)section {
    NSInteger sectionIndex = [self indexOfSection:section];
    [self.heightCache buildSectionsIfNeeded:sectionIndex];
    [self.heightCache.heightsBySection[sectionIndex] removeAllObjects];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)reloadCellObject:(SNCellObject *)cellObject {
    SNCell *cell = cellObject.cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.heightCache buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSMutableArray *rows = self.heightCache.heightsBySection[indexPath.section];
    rows[indexPath.row] = @-1;
    
    if (indexPath) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (SNSection *)sectionAtIndex:(NSInteger)index {
    if (index>=_mutableSections.count) {
        return nil;
    }
    
    return _mutableSections[index];
}

- (NSUInteger)indexOfSection:(SNSection *)section {
    return [_mutableSections indexOfObject:section];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mutableSections.count>0?_mutableSections.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mutableSections.count == 0) {
        return 0;
    }
    return [[_mutableSections[section] rows] count];
}

- (SNCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNCellObject *cellObject = [_mutableSections[indexPath.section] rows][indexPath.row];
    SNCell *cell = [tableView dequeueReusableCellWithIdentifier:cellObject.CellIdentifier];
    if (!cell) {
        cell = [[SNCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:cellObject.CellIdentifier];
    }
    
    [cell setCellObject:cellObject];
    cellObject.cell = cell;
    
    if (!LYVersionAtLeast(@"9.0")) {
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return 0;
    }
    
    if ([self.heightCache existsHeightAtIndexPath:indexPath]) {
#if DEBUG
        NSLog(@"hit height cache by index path[%@:%@] - %@",
              @(indexPath.section),
              @(indexPath.row),
              @([self.heightCache heightForIndexPath:indexPath]));
#endif
        return [self.heightCache heightForIndexPath:indexPath];
    }
    
    SNCellObject *cellObject = [_mutableSections[indexPath.section] rows][indexPath.row];
    SNCell *cell = [tableView dequeueReusableCellWithIdentifier:cellObject.CellIdentifier];
   
 if (LYVersionAtLeast(@"8.0")) {
        if (cell.isAutomaticDimension) {
            cell.cellObject = cellObject;
        }
    } else {
        cell.cellObject = cellObject;
    }

    
    CGFloat height = [cell cellHeight];
    [self.heightCache cacheHeight:height byIndexPath:indexPath];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.deselectCellWithAnimating) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    SNSection *section = _mutableSections[indexPath.section];
    id object = section.rows[indexPath.row];
    if ([object respondsToSelector:@selector(setSelectionHandler:)]) {
        SNCellObject *cellObject = (SNCellObject *)object;
        if (cellObject.selectionHandler) {
            cellObject.selectionHandler(cellObject);
        }
    }
    
    if (self.didSelectRow) {
        self.didSelectRow(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SNCell *sncell = (SNCell *)cell;
    if ([self.delegate respondsToSelector:@selector(tableManager:willDisplayCellObject:forRowAtIndexPath:)]) {
        [self.delegate tableManager:self willDisplayCellObject:sncell.cellObject forRowAtIndexPath:indexPath];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.beginDragging) {
        self.beginDragging(scrollView);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScroll) {
        self.didScroll(scrollView);
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.beginDecelerating) {
        self.beginDecelerating(scrollView);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.didEndDecelerating) {
        self.didEndDecelerating(scrollView);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.didEndDragging) {
        self.didEndDragging(scrollView,decelerate);
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SNSection *section_ = [self sectionAtIndex:section];
    if (section_.sectionView) {
        return CGRectGetHeight(section_.sectionView.frame);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SNSection *section_ = [self sectionAtIndex:section];
    if (section_.footView) {
        return CGRectGetHeight(section_.footView.frame);
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SNSection *section_ = [self sectionAtIndex:section];
    if (section_.sectionView) {
        return section_.sectionView;
    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SNSection *section_ = [self sectionAtIndex:section];
    if (section_.footView) {
        return section_.footView;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SNSection *section = _mutableSections[indexPath.section];
    id object = section.rows[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tableManager:commitEditStyle:WithCellObject:ForRowAtIndexPath:)]) {
        SNCellObject *cellObject = (SNCellObject *)object;
        [self.delegate tableManager:self commitEditStyle:editingStyle WithCellObject:cellObject ForRowAtIndexPath:indexPath];
    }

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    SNSection *section = _mutableSections[indexPath.section];
    id object = section.rows[indexPath.row];
    SNCellObject *cellObject = (SNCellObject *)object;
    return cellObject.editingStyle;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
return @"删除";
}
@end
