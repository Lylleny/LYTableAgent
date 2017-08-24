//
//  SNTableManager.h
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSection.h"
@import UIKit;

/**
 Change the UIScrolldelegate to block ,you can use all the block to call the uiscrollviewdelegate method
 
 */
typedef void(^didScroll)(UIScrollView *scroll);
typedef void(^beginDecelerating)(UIScrollView *scroll);
typedef void(^didEndDecelerating)(UIScrollView *scroll);
typedef void(^beginDragging)(UIScrollView *scroll);
typedef void(^didEndDragging)(UIScrollView *scroll,BOOL decelerate);

/**
 Change the tableview didSelectedRow method to block

 */
typedef void(^didSelectRow)(NSIndexPath *indexPath);



/**
 SNTableMangerdelegate 
 Just add two method from TableviewDelegate and you can add more delegate method at here
 */
@class SNTableManager;

@protocol SNTableManagerDelegate <NSObject>

- (void)tableManager:(SNTableManager *)tableManager willDisplayCellObject:(SNCellObject *)cellObject forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableManager:(SNTableManager *)tableManager commitEditStyle:(UITableViewCellEditingStyle)editingStyle  WithCellObject:(SNCellObject *)cellObject ForRowAtIndexPath:(NSIndexPath *)indexPath;
@end


/**
 SNTableManger makes it easy to manger the tableview, and your controller with tableview will become very easy.
 */
@interface SNTableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) didSelectRow didSelectRow;
@property (nonatomic, copy) didScroll didScroll;
@property (nonatomic, copy) beginDragging beginDragging;
@property (nonatomic, copy) beginDecelerating beginDecelerating;
@property (nonatomic, copy) didEndDecelerating didEndDecelerating;
@property (nonatomic, copy) didEndDragging didEndDragging;

@property (nonatomic) BOOL deselectCellWithAnimating;

@property (nonatomic, weak) id<SNTableManagerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;


/**
 Handle sections method

 */
- (void)addSection:(SNSection *)section;
- (void)addSectionsFromArray:(NSArray *)section;
- (void)removeAllSections;


/**
 Insert and delete cell from tablview

 @param cellObjects cellobjects
 @param indexPaths indexPaths
 @param rowAnimation rowAnimation
 */
- (void)insertCellObjects:(NSArray<SNCellObject *> *)cellObjects
             atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
         withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)deleteAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
         withRowAnimation:(UITableViewRowAnimation)rowAnimation;


/**
 
 tableview reloadData
 **/

- (void)reload;
- (void)reloadSection:(SNSection *)section;
- (void)reloadCellObject:(SNCellObject *)cellObject;



/**
 Method with sections

 @param index index
 @return section
 */
- (SNSection *)sectionAtIndex:(NSInteger)index;
- (NSUInteger)indexOfSection:(SNSection *)section;
@end
