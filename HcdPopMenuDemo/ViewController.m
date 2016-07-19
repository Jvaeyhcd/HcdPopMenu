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
    self.view.backgroundColor = [UIColor colorWithRed:0.282 green:0.651 blue:0.475 alpha:1.00];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 200, 30);
    [button setTitle:@"点击弹出框" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(openMeu) forControlEvents:UIControlEventTouchUpInside];
}

//打开菜单
- (void)openMeu {
    
    NSArray *array = @[@{kHcdPopMenuItemAttributeTitle : @"首页", kHcdPopMenuItemAttributeIconImageName : [UIImage imageNamed:@"center_photo"]},
                              @{kHcdPopMenuItemAttributeTitle : @"首页", kHcdPopMenuItemAttributeIconImageName : [UIImage imageNamed:@"center_album"]}/*,
                              @{kHcdPopMenuItemAttributeTitle : @"首页", kHcdPopMenuItemAttributeIconImageName : [UIImage imageNamed:@"center_vedio"]}*/];
    
    CGFloat x,y,w,h;
    x = CGRectGetWidth(self.view.bounds)/2 - 213/2;
    y = CGRectGetHeight([UIScreen mainScreen].bounds)/2 * 0.3f;
    w = 213;
    h = 57;
    
    //自定义的头部视图
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    topView.image = [UIImage imageNamed:@"center_photo"];
    topView.contentMode = UIViewContentModeScaleAspectFit;
    
    
//    [HcdPopMenuView createPopMenuItems:array topView:topView completionBlock:^(NSInteger index) {
//        
//    }];
    [HcdPopMenuView createPopmenuItems:array backgroundImageUrl:@"http://www.wmpic.me/wp-content/uploads/2013/10/20131029231125754.jpg" tipStr:@"海量投单是所有人都可以看到的投单，定向投单则是针对有目的性的投单（如企业投单）" completionBlock:^(NSInteger index) {
        
    }];
//    [HcdPopMenu CreatingPopMenuObjectItmes:Objs TopView:topView SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
//        NSLog(@"Index-%ld",(long)index);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
