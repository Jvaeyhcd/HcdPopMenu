//
//  ViewController.m
//  HcdPopMenuDemo
//
//  Created by polesapp-hcd on 16/7/18.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "ViewController.h"
#import "HcdPopMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 200, 30);
    [button setTitle:@"Open" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(openMeu) forControlEvents:UIControlEventTouchUpInside];
}

//打开菜单
- (void)openMeu {
    
    NSArray *array = @[@{kHcdPopMenuItemAttributeTitle : @"海量投单", kHcdPopMenuItemAttributeIconImageName : @"toudan_icon_hailiangtoudan"},
                              @{kHcdPopMenuItemAttributeTitle : @"定向投单", kHcdPopMenuItemAttributeIconImageName : @"toudan_icon_dingxiangtoudan"}];
    
    CGFloat x,y,w,h;
    x = CGRectGetWidth(self.view.bounds)/2 - 213/2;
    y = CGRectGetHeight([UIScreen mainScreen].bounds)/2 * 0.3f;
    w = 213;
    h = 57;
    
    //自定义的头部视图
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    topView.image = [UIImage imageNamed:@"center_photo"];
    topView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:array];
    [menu setBgImageViewByUrlStr:@"http://img3.duitang.com/uploads/item/201411/17/20141117102333_rwHMH.thumb.700_0.jpeg"];
    [menu setSelectCompletionBlock:^(NSInteger index) {
        
    }];
    [menu setTipsLblByTipsStr:@"海量投单是所有人都可以看到的投单，定向投单则是针对有目的性的投单（如企业投单）"];
    [menu setExitViewImage:@"center_exit"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
