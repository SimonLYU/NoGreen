//
//  LYUPixel.m
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "LYUPixel.h"

@implementation LYUPixel

+ (LYUPixel *)pixelWithType:(LYUPixelType)type frame:(CGRect)frame position:(CGPoint)position{
    LYUPixel * pixel = [[LYUPixel alloc] init];
    pixel.frame = frame;
    pixel.type = type;
    pixel.position = position;
    return pixel;
}

- (instancetype)init{
    if (self = [super init]) {
        UITapGestureRecognizer * tapSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelfTapped:)];
        [self addGestureRecognizer:tapSelf];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)setType:(LYUPixelType)type{
    _type = type;
    switch (type) {
        case kLYUPixelTypeSelected:
        {
            self.backgroundColor = [UIColor greenColor];
        }
            break;
        case kLYUPixelTypeNormal:
        default:
        {
            self.backgroundColor = [UIColor clearColor];
        }
            break;
    }
}

#pragma mark - UITapGestureRecognizer
- (void)onSelfTapped:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(pixelView:didSelectPosition:)]) {
        [self.delegate pixelView:self didSelectPosition:self.position];
    }
}

@end
