//
//  HcdPopMenuView.m
//  HcdPopMenuDemo
//
//  Created by polesapp-hcd on 16/7/18.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdPopMenuView.h"
#import "HcdPopMenu.h"
#import "POP.h"

#define kDuration 0.2
#define kBottomViewTag 10
#define kBottomViewHeight 52
#define kCancleViewWidth 28
#define kMaxPopMenuItemColumn 3
#define kPopMenuItemWidth kHcdPopMenuScreenWidth/kMaxPopMenuItemColumn
#define kPopMenuItemHeight kPopMenuItemWidth
#define kBasePopMenuTag 200
#define kInterval (0.195 / _items.count)

@interface HcdPopMenuView()
{
    UIWindow *_window;
    UIImage *bulrImage;
}

@property (nonatomic, weak  ) UIView *blurView;
@property (nonatomic, copy  ) NSArray *items;
@property (nonatomic, weak  ) selectCompletionBlock block;
@property (nonatomic, strong) UIImageView *exitView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel     *tipsLbl;

@end

@implementation HcdPopMenuView

+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
                   topView:(UIView *)topView
           completionBlock:(selectCompletionBlock)block {
    HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:items];
    [menu setTopView:topView];
    [menu setSelectCompletionBlock:block];
    [menu setExitViewImage:closeImageName];
}

+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
           completionBlock:(selectCompletionBlock)block {
    HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:items];
    [menu setSelectCompletionBlock:block];
    [menu setExitViewImage:closeImageName];
}

+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
        backgroundImageUrl:(NSString *)urlStr
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block {
    
    HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:items];
    [menu setBgImageViewByUrlStr:urlStr];
    [menu setSelectCompletionBlock:block];
    [menu setTipsLblByTipsStr:tipStr];
    [menu setExitViewImage:closeImageName];
}

+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
       backgroundImageName:(NSString *)bgImageName
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block {
    HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:items];
    [menu setBgImageViewByImageName:bgImageName];
    [menu setSelectCompletionBlock:block];
    [menu setTipsLblByTipsStr:tipStr];
    [menu setExitViewImage:closeImageName];
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        typeof(self) weakSelf = self;
        _items = items;
        [self setFrame:CGRectMake(0, 0, kHcdPopMenuScreenWidth, kHcdPopMenuScreenHeight)];
        
        [self initUI];
        [self show];
        
        //初始化设置 退出小按钮
        _exitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height - kBottomViewHeight / 2);
        _exitView.center = center;
        _exitView.transform = CGAffineTransformMakeRotation(M_PI_2/2);
        [self addSubview:_exitView];
        
        //动画旋转
        [UIView animateWithDuration:kDuration animations:^{
            weakSelf.exitView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    return self;
}

#pragma mark - private

- (void)initUI {
    UIView *blurView;
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 8.0) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
        ((UIVisualEffectView *)blurView).frame = self.bounds;
    } else if (version >= 7.0) {
        blurView = [[UIToolbar alloc] initWithFrame:self.bounds];
        ((UIToolbar *)blurView).barStyle = UIBarStyleDefault;
    } else {
        blurView = [[UIView alloc] initWithFrame:self.bounds];
        [blurView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9f]];
    }
    
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    _blurView = blurView;
    
    [self addSubview:_blurView];
    self.alpha = 0.0;
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHcdPopMenuScreenWidth, kHcdPopMenuScreenHeight - kBottomViewHeight)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    _bgImageView = bgImageView;
    
    [_blurView addSubview:_bgImageView];
    
    //提示文字
    UILabel *tipsLbl = [[UILabel alloc]initWithFrame:CGRectMake(kHcdPopMenuScreenWidth / 9, kHcdPopMenuScreenHeight - kBottomViewHeight - kPopMenuItemHeight - 10, kHcdPopMenuScreenWidth * 7 / 9, kPopMenuItemHeight)];
    tipsLbl.numberOfLines = 0;
    tipsLbl.textColor = [UIColor grayColor];
    tipsLbl.font = [UIFont systemFontOfSize:10];
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    _tipsLbl = tipsLbl;
    [_blurView addSubview:_tipsLbl];
    
    UIView *bottomView = [[UIView alloc]init];
    CGFloat bottomY = kHcdPopMenuScreenHeight - kBottomViewHeight;
    [bottomView setTag:kBottomViewTag];
    [bottomView setFrame:CGRectMake(0, bottomY, kHcdPopMenuScreenWidth, kBottomViewHeight)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.90f]];
    
    [_blurView addSubview:bottomView];
    
    [self calculatingItems];
}

/**
 *  计算按钮的位置
 */
- (void)calculatingItems {
    
    UIView *bottomView = (UIView *)[self viewWithTag:kBottomViewTag];
    
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDuration animations:^{
        [weakSelf setAlpha:1];
    }];
    
    NSInteger index = 0;
    NSInteger count = _items.count;
    
    for (NSMutableDictionary *dict in _items) {
        CGFloat buttonX,buttonY;
        
        buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth;
        buttonY = ((index / kMaxPopMenuItemColumn) * (kPopMenuItemHeight + 10)) + (kHcdPopMenuScreenHeight/2.85);
        
        if (count == 2) {
            buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth + (kPopMenuItemWidth / 3) * (index + 1);
            buttonY = CGRectGetMinY(bottomView.frame) - (kPopMenuItemHeight + 10) * 2;
        }
        
        CGRect fromValue = CGRectMake(buttonX, CGRectGetMinY(bottomView.frame), kPopMenuItemWidth, kPopMenuItemHeight);
        CGRect toValue = CGRectMake(buttonX, buttonY, kPopMenuItemWidth, kPopMenuItemHeight);
        
        if (index == 0) {
            _maxTopViewY = CGRectGetMinY(toValue);
        }
        HcdPopMenuItem *button = [self allocButtonIndex:index];
        button.attrDic = dict;
        [button setFrame:fromValue];
        double delayInSeconds = index * kInterval;
        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
        
        [self startTheAnimationFromValue:fromValue toValue:toValue delay:delay object:button completionBlock:^(BOOL complete) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(dismiss)];
            [_blurView addGestureRecognizer:tap];
        } hideDisplay:false];
        
        index ++;
    }
}

/**
 *  隐藏方法
 */
-(void)dismiss{
    
    UIView *bottomView = [self viewWithTag:kBottomViewTag];
    [bottomView setUserInteractionEnabled:false];
    [self setUserInteractionEnabled:false];
    typeof(self) weakSelf = self;
    [self dismissCompletionBlock:^(BOOL complete) {
        [weakSelf removeFromSuperview];
    }];
}

/**
 *  隐藏动画
 *
 *  @param completionBlock 完成回调
 */
-(void)dismissCompletionBlock:(void(^) (BOOL complete)) completionBlock{
    
    //动画旋转
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.38 animations:^{
        weakSelf.exitView.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    }];
    
    NSInteger index = 0;
    UIView *bottomView = (UIView *)[self viewWithTag:kBottomViewTag];
    
    NSInteger count = _items.count;
    
    for (NSMutableDictionary *dic in _items) {
        HcdPopMenuItem *button = (HcdPopMenuItem *)[self viewWithTag:(index + 1) + kBasePopMenuTag];
        button.attrDic = dic;
        
        CGFloat buttonX,buttonY;
        buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth;
        buttonY = ((index / kMaxPopMenuItemColumn) * (kPopMenuItemHeight +10)) + (kHcdPopMenuScreenHeight/2.9);
        
        if (count == 2) {
            buttonX = (index % kMaxPopMenuItemColumn) * kPopMenuItemWidth + (kPopMenuItemWidth / 3) * (index + 1);
            buttonY = CGRectGetMinY(bottomView.frame) - (kPopMenuItemHeight + 10) * 2;
        }
        
        CGRect toValue = CGRectMake(buttonX, kHcdPopMenuScreenHeight, kPopMenuItemWidth, kPopMenuItemHeight);
        CGRect fromValue = CGRectMake(buttonX, buttonY, kPopMenuItemWidth, kPopMenuItemHeight);
        double delayInSeconds = (_items.count - index) * kInterval;
        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
        
        [UIView animateWithDuration:0.2 animations:^{
            [bottomView setBackgroundColor:[UIColor clearColor]];
        }];
        
        [self startTheAnimationFromValue:fromValue toValue:toValue delay:delay object:button completionBlock:^(BOOL complete) {
            
        } hideDisplay:true];
        index ++;
    }
    [self hideDelay:0.38f completionBlock:^(BOOL completion) {
        
    }];
}


/**
 *  开始弹出动画
 *
 *  @param fromValue       起始位置
 *  @param toValue         结束位置
 *  @param delay           延迟
 *  @param obj             执行动画对象
 *  @param completionBlock 完成回调
 *  @param hideDisplay     hideDisplay YES or NO
 */
-(void)startTheAnimationFromValue:(CGRect)fromValue
                          toValue:(CGRect)toValue
                            delay:(CFTimeInterval)delay
                           object:(id)obj
                  completionBlock:(void(^) (BOOL complete))completionBlock
                      hideDisplay:(BOOL)hideDisplay{
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = delay;
    CGFloat springBounciness = 10.f;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    CGFloat springSpeed = 20.f;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toValue];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromValue];
    
    POPSpringAnimation *springAnimationAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    springAnimationAlpha.removedOnCompletion = YES;
    springAnimationAlpha.beginTime = delay;
    springAnimationAlpha.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat toV,fromV;
    if (hideDisplay) {
        fromV = 1.0f;
        toV = 0.0f;
    }else{
        fromV = 0.0f;
        toV = 1.0f;
    }
    
    springAnimationAlpha.springSpeed = springSpeed;     // value between 0-20
    springAnimationAlpha.toValue = @(toV);
    springAnimationAlpha.fromValue = @(fromV);
    
    [obj pop_addAnimation:springAnimationAlpha forKey:springAnimationAlpha.name];
    [obj pop_addAnimation:springAnimation forKey:springAnimation.name];
    [springAnimation setCompletionBlock:^(POPAnimation *spring, BOOL completion) {
        if (!completionBlock) {
            return ;
        }
        completionBlock(completion);
    }];
    
}

/**
 *  生成MenuItem
 *
 *  @param index 下标
 *
 *  @return PopMenuItem
 */
-(HcdPopMenuItem *)allocButtonIndex:(NSInteger)index
{
    HcdPopMenuItem *button = [[HcdPopMenuItem alloc] init];
    [button setTag:(index + 1) + kBasePopMenuTag];
    [button setAlpha:0.0f];
    [button setTitleColor:[UIColor colorWithWhite:0.38 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:button];
    
    return button;
}

/**
 *  选中了MenuItem后的响应事件
 *
 *  @param menuItem menuItem对象
 */
-(void)menuItemSelected:(HcdPopMenuItem *)menuItem
{
    NSInteger tag = menuItem.tag - (kBasePopMenuTag + 1);
    typeof(self) weak = self;
    for (NSMutableDictionary *dict in _items) {
        NSInteger index = [_items indexOfObject:dict];
        HcdPopMenuItem *buttons = (HcdPopMenuItem *)[self viewWithTag:(index + 1) + kBasePopMenuTag];
        if (index == tag) {
            [menuItem playSelectAnimation];
        }else{
            [buttons playCancelAnimation];
        }
    }
    [self hideDelay:0.3f completionBlock:^(BOOL completion) {
        if (!weak.block) {
            return ;
        }
        weak.block(tag);
    }];
}

/**
 *  隐藏
 *
 *  @param delay 延时时间
 *  @param blcok 完成后回调block
 */
-(void)hideDelay:(NSTimeInterval)delay completionBlock:(void(^)(BOOL completion))blcok {
    
    UIView *bottomView = (UIView *)[self viewWithTag:kBottomViewTag];
    [self setUserInteractionEnabled:false];
    typeof(self) weakSelf = self;
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [bottomView setBackgroundColor:[UIColor clearColor]];
        _bgImageView.hidden = YES;
        _tipsLbl.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateKeyframesWithDuration:kDuration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [weakSelf setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (!blcok) {
            return ;
        }
        blcok(finished);
    }];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
}


-(void)dealloc
{
    NSArray *subViews = [_window subviews];
    for (id obj in subViews) {
        [obj removeFromSuperview];
    }
    [_window resignKeyWindow];
    [_window removeFromSuperview];
    _window = nil;
}

-(void)show{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = UIWindowLevelNormal;
    _window.backgroundColor = [UIColor clearColor];
    _window.alpha = 1;
    _window.hidden = false;
    [_window addSubview:self];
}

#pragma mark - Setter

-(void)setTopView:(UIView *)topView {
    
    if (![topView isKindOfClass:[NSNull class]] &&
        [topView isKindOfClass:[UIView class]]) {
        _topView = topView;
        [_blurView addSubview:topView];
    }
}

/**
 *  通过url地址设置背景图片
 *
 *  @param urlStr 图片地址
 */
- (void)setBgImageViewByUrlStr:(NSString *)urlStr {
    if (_bgImageView) {
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    }
}

- (void)setBgImageViewByImageName: (NSString *)imageName {
    if (_bgImageView) {
        _bgImageView.image = [UIImage imageNamed:imageName];
    }
}

/**
 *  通过资源文件中的图片设置背景图片
 *
 *  @param bgImage 资源文件中的图片
 */
- (void)setBgImageViewByImage:(UIImage *)bgImage {
    if (_bgImageView) {
        _bgImageView.image = bgImage;
    }
}

- (void)setTipsLblByTipsStr:(NSString *)tipsStr {
    if (_tipsLbl) {
        _tipsLbl.text = tipsStr;
    }
}

- (void)setExitViewImage:(NSString *)imageName {
    if (_exitView) {
        _exitView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setSelectCompletionBlock:(selectCompletionBlock)block {
    _block = block;
}

@end
