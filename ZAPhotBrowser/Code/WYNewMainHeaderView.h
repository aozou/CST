//
//  WYNewMainHeaderView.h
//  productModel
//
//  Created by  jiangminjie on 2018/6/27.
//  Copyright © 2018年 yxy. All rights reserved.
//  派修整合到派巡的新首页 --> 头部视图

#import <UIKit/UIKit.h>

@class WYNewMainHeaderView;
@protocol WYNewMainHeaderViewDelegate<NSObject>

@optional
/*
 消息
 */
- (void)onClickBtByNotification:(WYNewMainHeaderView *)view withNotificationCount:(NSInteger)count;
/*
 超时接单 10000/预约单 10001/差评单 10002/已挂起 10003/已完成 10004/超时 10005/完成率 10006
 */
- (void)onClickBtByHeaderView:(WYNewMainHeaderView *)view withClickType:(NSInteger)type withHeaderCount:(NSInteger)count;

@end
@interface WYNewMainHeaderView : UIView

@property (nonatomic,weak)id<WYNewMainHeaderViewDelegate> delegate;

//更新数据
- (void)onUpdateData:(id)data;
//更新未读消息
- (void)onUpdateMessageNumber:(NSString *)msgNumber;

@end
