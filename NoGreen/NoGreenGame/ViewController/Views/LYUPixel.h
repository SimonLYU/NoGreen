//
//  LYUPixel.h
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYUPixel;

typedef NS_ENUM(NSUInteger, LYUPixelType) {
    kLYUPixelTypeNormal,    //normal color
    kLYUPixelTypeSelected,  //green
};

@protocol LYUPixelDelegate<NSObject>
/**
 * 选中了一个pixel
 */
- (void)pixelView:(LYUPixel *)pixelView didSelectPosition:(CGPoint)position;

@end

@interface LYUPixel : UIView

@property (nonatomic, weak) id<LYUPixelDelegate> delegate;
@property (nonatomic, assign) LYUPixelType type;
@property (nonatomic, assign) CGPoint position;

+ (LYUPixel *)pixelWithType:(LYUPixelType)type frame:(CGRect)frame position:(CGPoint)position;

@end
