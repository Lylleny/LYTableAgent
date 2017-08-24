//
//  BaseCellObject.m
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import "SNCellObject.h"
#import "SNTableConfiguration.h"

@implementation SNCellObject
#pragma mark - getter & setter
-(BOOL)showSelection{
    return NO;
}
- (UIColor *)seperatorColor {
    if (!_seperatorColor) {
       // _seperatorColor = [SWColor tableViewCellSeperatorColor];
    }
    return _seperatorColor;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = FONT_LIGHT(14);
    }
    return _titleFont;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [SNColor color333333];
    }
    return _titleColor;
}

- (NSString *)CellIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (instancetype)cellObject {
    return [[self alloc] init];
}

+ (instancetype)cellObjectWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)init {
    self = [super init];
    if (self) {
        _showSelection = YES;       //  默认为可选中
       // _seperatorMarginLeft = 16;
        //_seperatorMarginRight = 16;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    
    if (self) {
        _title = title;
    }
    
    return self;
}

#pragma mark - public methods
- (void)updateTitle:(NSString *)title {
    if (!title || title.length==0) {
        return;
    }
    
    self.title = title;
    
    if ([self.cell respondsToSelector:@selector(updateTitle)]) {
        [self.cell performSelector:@selector(updateTitle)];
    }
}
@end
