//
//  HcdPopMenuView.h
//  HcdPopMenuDemo
//
//  Created by polesapp-hcd on 16/7/18.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCompletionBlock)(NSInteger index);

@interface HcdPopMenuView : UIView

@property (nonatomic, assign, readonly) CGFloat maxTopViewY;
@property (nonatomic, weak            ) UIView  *topView;

/**
 *  创建PopMenu
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param topView        顶部View
 *  @param block          完成回调
 */
+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
                   topView:(UIView *)topView
           completionBlock:(selectCompletionBlock)block;

/**
 *  创建PopMenu
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param block          完成回调
 */
+ (void)createPopMenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
           completionBlock:(selectCompletionBlock)block;

/**
 *  创建PopMenu，特殊的PopMenu,只传入两个items参数
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param urlStr         背景图片的Url
 *  @param tipStr         提示文字
 *  @param block          完成后的回调
 */
+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
        backgroundImageUrl:(NSString *)urlStr
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block;

/**
 *  创建PopMenu，特殊的PopMenu,只传入两个items参数
 *
 *  @param items          items参数
 *  @param closeImageName 关闭按钮图片名称
 *  @param bgImageName    背景图片名称
 *  @param tipStr         提示文字
 *  @param block          完成后的回调
 */
+ (void)createPopmenuItems:(NSArray *)items
            closeImageName:(NSString *)closeImageName
       backgroundImageName:(NSString *)bgImageName
                    tipStr:(NSString *)tipStr
           completionBlock:(selectCompletionBlock)block;

@end
