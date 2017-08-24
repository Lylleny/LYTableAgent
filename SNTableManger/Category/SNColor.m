//
//  SNColor.m
//  NormalHeader
//
//  Created by 颜阿龙 on 2017/8/24.
//  Copyright © 2017年 Lylleny. All rights reserved.
//

#import "SNColor.h"

@implementation SNColor
+ (UIColor *)getColor:(NSString *)hex{
    unsigned red,green,blue;
    NSRange range;
    range.length =2;
    
    range.location=0;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&red];
    
    range.location=2;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&green];
    
    range.location=4;
    [[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:1];
}

+ (UIColor *)redColor{
    return [UIColor redColor];
}


+ (UIColor *)greenColor{
    return [UIColor greenColor];
}

+ (UIColor *)blackColor{
    return [UIColor blackColor];
}

+ (UIColor *)yellowColor{
    return [UIColor yellowColor];
}

+ (UIColor *)whiteColor{
    return [UIColor whiteColor];
}

+ (UIColor *)grayColor{
    return [UIColor grayColor];
}

+ (UIColor *)tableViewCellSeperatorColor{
    return [SNColor getColor:@"cccccc"];
}

+ (UIColor *)coloreb6877{
    return [SNColor getColor:@"eb6877"];
}

+ (UIColor *)colorf39700{
    return [SNColor getColor:@"f39700"];
}


+ (UIColor *)color209346{
    return [SNColor getColor:@"62cac7"];
}

+ (UIColor *)color333333{
    return [SNColor getColor:@"333333"];
}

+ (UIColor *)color666666{
    return [SNColor getColor:@"666666"];
}


+ (UIColor *)colorff6900{
    return [SNColor getColor:@"ff6900"];
}


+ (UIColor *)color00a0e9{
    return [SNColor getColor:@"00a0e9"];
}

+ (UIColor *)color999999{
    return [SNColor getColor:@"999999"];
}

+ (UIColor *)colore62080{
    return [SNColor getColor:@"e62080"];
};

+ (UIColor *)color45c4eb{
    return [SNColor getColor:@"45c4eb"];
}


+ (UIColor *)colorffdcdc{
    return [SNColor getColor:@"ffdcdc"];
}

+ (UIColor *)colorec6066{
    return [SNColor getColor:@"ec6066"];
}

+ (UIColor *)color1ea838{
    return [SNColor getColor:@"1ea838"];
}

+ (UIColor *)colore5004f{
    return [SNColor getColor:@"e5004f"];
}

+ (UIColor *)colorf5f5f5{
    return [SNColor getColor:@"f5f5f5"];
};
+ (UIColor *)colord1d1d1{
    return [SNColor getColor:@"d1d1d1"];
};
+ (UIColor *)colorf3f3f3{
    return [SNColor getColor:@"f3f3f3"];
};
+ (UIColor *)colorcccccc{
    return [SNColor getColor:@"cccccc"];
};
+ (UIColor *)colord175c2{
    return [SNColor getColor:@"d175c2"];
};
+ (UIColor *)color62cac7{
    return [SNColor getColor:@"62cac7"];
};
+ (UIColor *)colored7e30{
    return [SNColor getColor:@"ed7e30"];
};
+ (UIColor *)color74328b{
    return [SNColor getColor:@"74328b"];
};
+ (UIColor *)colore7ce5a{
    return [SNColor getColor:@"e7ce5a"];
};
+ (UIColor *)colore5d3b2{
    return [SNColor getColor:@"e5d3b2"];
};
+ (UIColor *)color6aac68{
    return [SNColor getColor:@"6aac68"];
};

@end
