//
//  LYUPixel.m
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "LYUPixel.h"
@import Masonry;
@interface LYUPixel ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

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
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setType:(LYUPixelType)type{
    _type = type;
    switch (type) {
        case kLYUPixelTypeSelected:
        {
//            self.backgroundColor = [UIColor greenColor];
            self.backgroundImageView.image = [UIImage imageNamed:@"草1"];
        }
            break;
        case kLYUPixelTypeNormal:
        default:
        {
//            self.backgroundColor = [UIColor clearColor];
            self.backgroundImageView.image = nil;
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
