//
//  BaseCellObject.h
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SeperatorPosition) {
    SeperatorPositionTop,
    SeperatorPositionBottom,
    SeperatorPositionTopBottom
};

typedef NS_ENUM(NSInteger, SeperatorStyle) {
    SeperatorStyleSingle,
    SeperatorStyleDash
};

@class SNCell;
@import UIKit;

@interface SNCellObject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imageUnicode;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic) id ext;

@property (nonatomic, copy) void (^selectionHandler)(id object);

@property (nonatomic, weak) SNCell *cell;

@property (nonatomic, assign) CGFloat seperatorMarginLeft;
@property (nonatomic, assign) CGFloat seperatorMarginRight;

@property (nonatomic, assign) SeperatorStyle seperatorStyle;
@property (nonatomic) BOOL showSeperator;
@property (nonatomic) SeperatorPosition seperatorPosition;
@property (nonatomic, strong) UIColor *seperatorColor;
@property (nonatomic) CGSize seperatorSize;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic) BOOL showSelection;
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

- (NSString *)CellIdentifier;

+ (instancetype)cellObject;
+ (instancetype)cellObjectWithTitle:(NSString *)title;
@end
