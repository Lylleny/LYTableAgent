//
//  BaseCell.m
//  SNTableManager
//
//  Created by Lylleny on 15/8/9.
//  Copyright (c) 2015年 Snake_Jay. All rights reserved.
//

#import "SNCell.h"
#import "SNTableConfiguration.h"

@implementation SNCell {
    UIView *_separator;
    UIView *_bottomSeperator;
    CAShapeLayer *separatorLayer;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_separator removeFromSuperview];
    [_bottomSeperator removeFromSuperview];
    separatorLayer = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.textLabel.attributedText = nil;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cellWillRender];
    }
    return self;
}

- (void)cellWillRender{

}

- (void)cellDidRender{

}

- (CGFloat)cellHeight {
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (BOOL)isAutomaticDimension {
    return NO;
}

- (void)configWithCellObject:(SNCellObject *)cellObject {
    
}

- (void)setCellObject:(SNCellObject *)cellObject {
    if (cellObject.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
//        UILabel *accessoryTypeLabel = [[UILabel alloc] init];
//        accessoryTypeLabel.font = [UIFont fontWithName:@"iconfont" size:9.f];
//        accessoryTypeLabel.textColor = [SNColor getColor:@"#e7e7e7"];
//        accessoryTypeLabel.text = @"\U0000e6b2";
//        [accessoryTypeLabel sizeToFit];
//        self.accessoryView = accessoryTypeLabel;
    } else {
        self.accessoryType = cellObject.accessoryType;
    }
    
    if (cellObject.titleFont) {
        self.textLabel.font = self.cellObject.titleFont;
    }
    
    if (cellObject.titleColor) {
        self.textLabel.textColor = cellObject.titleColor;
    }
    
    if (cellObject.attributedTitle) {
        self.textLabel.attributedText = cellObject.attributedTitle;
    }
    
    if (cellObject.showSelection == NO) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    

    
    _cellObject = cellObject;
    
    if (cellObject.showSeperator) {
        self.seperatorPosition = cellObject.seperatorPosition;
        
        CGSize seperatorSize = cellObject.seperatorSize;
        if (CGSizeEqualToSize(CGSizeZero, seperatorSize)) {
            seperatorSize = CGSizeMake(DEFAULT_WIDTH - (cellObject.seperatorMarginLeft+cellObject.seperatorMarginRight), .5f);
        }
        
        UIColor *seperatorColor = cellObject.seperatorColor;
        if (!seperatorColor) {
            seperatorColor = [SNColor tableViewCellSeperatorColor];
        }
        [self addSepartorWithSize:seperatorSize
         
                            color:seperatorColor];
    }
    
    [self cellDidRender];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_separator) {
        if (self.seperatorPosition == SeperatorPositionBottom) {
            _separator.bottom = self.height-.5;
        } else if (self.seperatorPosition == SeperatorPositionTop ||
                   self.seperatorPosition == SeperatorPositionTopBottom) {
            _separator.top = 0;
        }
        _separator.left = self.cellObject.seperatorMarginLeft;
        _separator.right = DEFAULT_WIDTH - self.cellObject.seperatorMarginRight;
    }
    
    if (_bottomSeperator) {
        _bottomSeperator.bottom = self.height-.5;
        _bottomSeperator.left = self.cellObject.seperatorMarginLeft;
        _bottomSeperator.right = DEFAULT_WIDTH - self.cellObject.seperatorMarginRight;
    }
}

- (void)addSepartorWithSize:(CGSize)size color:(UIColor *)color {
    _separator = [[UIView alloc] init];
    _separator.size = size;
    _separator.backgroundColor = color;
    [self addSubview:_separator];
    
    if (self.seperatorPosition == SeperatorPositionTopBottom) {
        _bottomSeperator = [[UIView alloc] init];
        _bottomSeperator.size = size;
        _bottomSeperator.backgroundColor = color;
        [self addSubview:_bottomSeperator];
    }
    
    if (self.cellObject.seperatorStyle == SeperatorStyleDash) {
        separatorLayer = [CAShapeLayer layer];
        separatorLayer.strokeColor = [SNColor getColor:@"#cccccc"].CGColor;
        separatorLayer.fillColor = [UIColor clearColor].CGColor;
        separatorLayer.lineWidth = 1.f;
        separatorLayer.lineJoin = kCALineJoinRound;
        separatorLayer.lineDashPattern = @[@1, @1];
        separatorLayer.path = [UIBezierPath bezierPathWithRect:_separator.bounds].CGPath;
        separatorLayer.frame = CGRectMake(0, 0, _separator.bounds.size.width, 1);
    
        [_separator.layer addSublayer:separatorLayer];
        [_bottomSeperator.layer addSublayer:separatorLayer];
        _separator.backgroundColor = [UIColor clearColor];
        _bottomSeperator.backgroundColor = [UIColor clearColor];
        _separator.layer.masksToBounds = YES;
        _bottomSeperator.layer.masksToBounds = YES;
    }
}

@end
