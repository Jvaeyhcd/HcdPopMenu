//
//  HcdPopMenuItem.h
//  HcdPopMenuDemo
//
//  Created by polesapp-hcd on 16/7/18.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kHcdPopMenuItemAttributeTitle;// NSString
extern NSString *const kHcdPopMenuItemAttributeIconImageName;// UIImage

@interface HcdPopMenuItem : UIButton

@property (nonatomic, copy) NSMutableDictionary *attrDic;

/**
 *  播放选择动画
 */
- (void)playSelectAnimation;

/**
 *  播放取消选择动画
 */
- (void)playCancelAnimation;

@end
