//
//  SNFontConfiguration.h
//  NormalHeader
//
//  Created by 颜阿龙 on 2017/8/24.
//  Copyright © 2017年 Lylleny. All rights reserved.
//

#ifndef SNFontConfiguration_h
#define SNFontConfiguration_h

#define LYVersionAtLeast(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma fonts

#define FONT_LIGHT(fontsize) (LYVersionAtLeast(@"8.2")?([UIFont systemFontOfSize:fontsize weight:UIFontWeightLight]):([UIFont fontWithName:@"HelveticaNeue-Light" size:fontsize]))
#define FONT_REGULAR(fontsize) (LYVersionAtLeast(@"8.2")?([UIFont systemFontOfSize:fontsize weight:UIFontWeightRegular]):([UIFont fontWithName:@"HelveticaNeue" size:fontsize]))
#define FONT_BOLD(fontsize) (LYVersionAtLeast(@"8.2")?([UIFont systemFontOfSize:fontsize weight:UIFontWeightBold]):([UIFont boldSystemFontOfSize:fontsize]))


#endif /* SNFontConfiguration_h */
