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
#import "LYUNoGreenViewModel.h"
#import "LYUPixel.h"
#import "UIColor+Extension.h"
@import Masonry;
@import GoogleMobileAds;

static inline BOOL showAD(){
    //show AD
    BOOL showAD = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *showDate = [formatter dateFromString:@"2020-02-26 00:00:00"];
    NSTimeInterval showTime = [showDate timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    showAD = nowTime > showTime;
    return showAD;
}

@interface LYUNoGreenViewController ()<LYUPixelDelegate , GADRewardedAdDelegate ,GADBannerViewDelegate>

@property (nonatomic, strong) LYUNoGreenViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *theNewGameButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleBackgroundImageview;

@property (weak, nonatomic) IBOutlet UIView *gameView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomCons;
//AD
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADBannerView *bannerView;
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
    
    [RACObserve(self.viewModel, heightScore) subscribeNext:^(id x) {
        self.heightScoreLabel.text = [NSString stringWithFormat:@"历史最高:%zd",self.viewModel.heightScore];
    }];
    
    [RACObserve(self.viewModel, showLifeAd) subscribeNext:^(id x) {
        if (self.viewModel.showLifeAd) {
            [self _showADForLife];
        }
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
    self.topContainerView.layer.borderColor = [UIColor ARGB:0x637FF7].CGColor;
    self.topContainerView.layer.borderWidth = 1;
    
    self.bottomContainerView.layer.cornerRadius = 4;
    self.bottomContainerView.layer.masksToBounds = YES;
    self.bottomContainerView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bottomContainerView.layer.borderWidth = 1;
    
    self.theNewGameButton.layer.cornerRadius = 4.f;
    self.theNewGameButton.layer.masksToBounds = YES;
    self.restartButton.layer.cornerRadius = 4.f;
    self.restartButton.layer.masksToBounds = YES;
    
    self.titleBackgroundImageview.layer.cornerRadius = 4.f;
    self.titleBackgroundImageview.layer.masksToBounds = YES;
    
    if (showAD()) {
        //AD-banner
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.bannerView.adUnitID = @"ca-app-pub-4024299068057356/8034038272";
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
        [self.bannerView loadRequest:[GADRequest request]];
        [self.view addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomContainerView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width);
            make.height.mas_equalTo(kGADAdSizeBanner.size.height);
        }];
        
        //AD-full screen
        self.rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:@"ca-app-pub-4024299068057356/2346597322"];
        GADRequest *request = [GADRequest request];
        [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
            if (error) {
                // Handle ad failed to load case.
            } else {
                // Ad successfully loaded.
            }
        }];
        
        self.bottomViewBottomCons.constant = -(kGADAdSizeBanner.size.height + 5);
    }else{
        self.bottomViewBottomCons.constant = -5;
    }

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

- (void)_showADForLife{
    if (!self.rewardedAd || !showAD()) {
        [UIUtil showHint:@"三次重置机会已经用尽,重新开始游戏吧!"];
        return;
    }
    if (!self.rewardedAd.isReady) {//如果没准备好,直接失败
        [UIUtil showHint:@"三次重置机会已经用尽,重新开始游戏吧!"];
        return;
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"失败" message:[NSString stringWithFormat:@"观看精彩广告,可以获得一次重生的机会哦~"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"获得重生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.rewardedAd.isReady) {
            [self.rewardedAd presentFromRootViewController:self delegate:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - GADBannerViewDelegate;
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}
#pragma mark - GADRewardedAdDelegate
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    [self.viewModel.addLifeCommand execute:nil];
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidPresent:");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError");
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    self.rewardedAd = [self createAndLoadRewardedAd];
}

- (GADRewardedAd *)createAndLoadRewardedAd {
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc]
                                 initWithAdUnitID:@"ca-app-pub-4024299068057356/2346597322"];
    GADRequest *request = [GADRequest request];
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            // Handle ad failed to load case.
        } else {
            // Ad successfully loaded.
        }
    }];
    return rewardedAd;
}

#pragma mark - LYUPixelDelegate
- (void)pixelView:(LYUPixel *)pixelView didSelectPosition:(CGPoint)position{
    [self.viewModel.selectCommand execute:pixelView];
}

#pragma mark - preferredStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
