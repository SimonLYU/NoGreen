//
//  LYUNoGreenViewController.m
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "LYUNoGreenHeader.h"
#import "BaseHeaders.h"
#import "LYUNoGreenViewController.h"
#import "LYUNoGreenViewController.h"
#import "LYUNoGreenViewModel.h"
#import "LYUPixel.h"

@interface LYUNoGreenViewController ()<LYUPixelDelegate>

@property (nonatomic, strong) LYUNoGreenViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *theNewGameButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *gameView;

@end

@implementation LYUNoGreenViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerRacsignal];
    [self setupUI];
    [self.viewModel randomMap];
}

- (void)registerRacsignal{
    [super registerRacsignal];
    
    [RACObserve(self.viewModel, stage) subscribeNext:^(id x) {
        self.scoreLabel.text = [NSString stringWithFormat:@"当前关卡 : %zd",[x integerValue]];
    }];
    
    [RACObserve(self.viewModel, step) subscribeNext:^(id x) {
        self.stepLabel.text = [NSString stringWithFormat:@"剩余步数 : %zd",[x integerValue]];
    }];
    
    [RACObserve(self.viewModel, gameMap) subscribeNext:^(id x) {
        [self resetGameView];
    }];

    
    [[self.theNewGameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.theNewGameCommand execute:nil];
    }];
    
    [[self.restartButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.restartCommand execute:nil];
    }];
}
- (void)setupUI{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupGameView];
    self.topContainerView.layer.cornerRadius = 4;
    self.topContainerView.layer.masksToBounds = YES;
    self.topContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.topContainerView.layer.borderWidth = 1;
    
    self.bottomContainerView.layer.cornerRadius = 4;
    self.bottomContainerView.layer.masksToBounds = YES;
    self.bottomContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bottomContainerView.layer.borderWidth = 1;
    
}

- (void)setupGameView{
    
    CGFloat pixelWH = [UIScreen mainScreen].bounds.size.width / kNoGreenLenght;
    NSMutableArray * pixels = [NSMutableArray array];
    for (int hang = 0; hang < kNoGreenHeight; ++hang) {
        NSMutableArray * hangPixels = [NSMutableArray array];//每一行的所有pixel
        for (int lie = 0; lie < kNoGreenLenght; ++lie) {
            LYUPixel * pixel = [LYUPixel pixelWithType:kLYUPixelTypeNormal frame:CGRectMake(lie * pixelWH, hang * pixelWH, pixelWH, pixelWH) position:CGPointMake(hang, lie)];
            pixel.delegate = self;
            [self.gameView addSubview:pixel];
            [hangPixels addObject:pixel];
        }
        [pixels addObject:hangPixels];
    }
    self.viewModel.pixels = pixels;
}

- (void)resetGameView{
    
    for (int hang = 0; hang < kNoGreenHeight; ++hang) {
        for (int lie = 0; lie < kNoGreenLenght; ++lie) {
            LYUPixel * pixel = self.viewModel.pixels[hang][lie];
            pixel.type = kLYUPixelTypeNormal;
        }
    }
    
    for (NSString * pointString in self.viewModel.gameMap) {
        CGPoint point = CGPointFromString(pointString);
        LYUPixel * pixel = self.viewModel.pixels[(NSInteger)point.x][(NSInteger)point.y];
        [self.viewModel selectPixelView:pixel];
    }
}

#pragma mark - LYUPixelDelegate
- (void)pixelView:(LYUPixel *)pixelView didSelectPosition:(CGPoint)position{
    [self.viewModel.selectCommand execute:pixelView];
}

#pragma mark - preferredStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
