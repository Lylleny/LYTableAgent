//
//  SNSizeConfiguration.h
//  NormalHeader
//
//  Created by 颜阿龙 on 2017/8/24.
//  Copyright © 2017年 Lylleny. All rights reserved.
//

#ifndef SNSizeConfiguration_h
#define SNSizeConfiguration_h

#pragma size

#define SCREENRECT [UIScreen mainScreen].bounds
#define DEFAULT_WIDTH SCREENRECT.size.width
#define DEFAULT_HEIGHT SCREENRECT.size.height-64

#define kSNBaseWidth 320.f
#define kSNBaseHeight 568.f

#define KSN4SScreenHeight 480.f

#define kSNScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSNScreenHeight ([UIScreen mainScreen].bounds.size.height==KSN4SScreenHeight?kSNBaseHeight:[UIScreen mainScreen].bounds.size.height)

#define kSNScreenWidthRatio  (kSNScreenWidth / kSNBaseWidth)
#define kSNScreenHeightRatio (kSNScreenHeight / kSNBaseHeight)

#define SNAdaptedWidthValue(x)  (ceilf((x) * kSNScreenWidthRatio))
#define SNAdaptedHeightValue(x) (ceilf((x) * kSNScreenHeightRatio))

#define SNAdaptedWidth720Value(x) SNAdaptedWidthValue(kSNBaseWidth*(x)/720)

#define kSNFontSizeAdper(R) SNAdaptedWidthValue(R)
#define kSNFontSize720Adper(R) SNAdaptedWidth720Value(R)


#define NatureLength(len) ((len) * kSNScreenWidth / 720)



#endif /* SNSizeConfiguration_h */
