//
//  MainViewController.m
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewModel.h"
#import "BaseHeaders.h"
#import "BaseTabBarController.h"
#import "LYUNoGreenViewModel.h"
#import "LYUNoGreenViewController.h"
#import "BaseNavigationController.h"

@interface MainViewController ()

@property (nonatomic, strong) MainViewModel *viewModel;
@property (nonatomic, strong) BaseTabBarController *tabBarController;

@property (nonatomic, strong) BaseNavigationController *noGreenNav;

@end

@implementation MainViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerRacsignal];
    [self setupUI];
}

- (void)registerRacsignal{
    [super registerRacsignal];
}

- (void)setupUI{
    //setup tabBarController
    BaseTabBarController * tabBarController = [[BaseTabBarController alloc] init];
    [self addChildViewController:tabBarController];
    [self.view addSubview:tabBarController.view];
    self.tabBarController = tabBarController;
    [self.tabBarController.tabBar setHidden:YES];
    
    //setup controllers
    LYUNoGreenViewModel * noGreenViewModel = [[LYUNoGreenViewModel alloc] initWithVCName:NSStringFromClass([LYUNoGreenViewController class]) withInitType:kLYUVCTypeXib];
    LYUNoGreenViewController * noGreenViewController = [noGreenViewModel loadedVC];
    BaseNavigationController * noGreenNav = [[BaseNavigationController alloc] initWithRootViewController:noGreenViewController];
    self.noGreenNav = noGreenNav;
    
    [self.tabBarController setViewControllers:@[noGreenNav]];
}

@end
