//
//  BaseCell.h
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNCellObject.h"

@interface SNCell : UITableViewCell
@property (nonatomic, strong, readwrite) SNCellObject *cellObject;
@property (nonatomic) SeperatorPosition seperatorPosition;


/**
 init with cell subviews and make cell subviews layout
 */
- (void)cellWillRender;

/**
 confige cell subviews data with cellobject
 */
- (void)cellDidRender;


/**
 return cellheight
 
 */
- (CGFloat)cellHeight;


/**
 return use autolayout or not

 */
- (BOOL)isAutomaticDimension;



/**
 you can add cell with separtor with this method

 @param size separatorsize
 @param color color
 */
- (void)addSepartorWithSize:(CGSize)size color:(UIColor *)color;

@end
