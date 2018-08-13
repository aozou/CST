//
//  WYNewMainHeaderView.m
//  productModel
//
//  Created by  jiangminjie on 2018/6/27.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "WYNewMainHeaderView.h"

@interface WYNewMainHeaderView()<UIScrollViewDelegate> {
    UILabel                 *_orderNotyLabel;        //消息数
    UILabel                 *_orderAllCountLabel;    //总工单数
    UILabel                 *_orderAllTypeLabel;     //总工单类型
    UILabel                 *_orderTimeLabel;        //日期
    
    NSArray                 *_dataArray;            //二维数组
    
    UIScrollView            *_contentScrollView;
    UIPageControl           *_pageContrl;
    NSTimer                 *_timer;
    NSInteger               _timeScrollIndex;
}
@end
@implementation WYNewMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _dataArray = [[NSArray alloc]init];
        
        [self onCreatUI];
    }
    return self;
}

#pragma mark - UI
- (void)onCreatUI
{
    //底图
    UIImageView *bgImgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, KScaleHeight(160))];
    bgImgaeView.backgroundColor = UIColorFromRGB(0x4474eb);
    [self addSubview:bgImgaeView];
    
    UIImageView *bgImgaeView2 = [[UIImageView alloc]initWithFrame:bgImgaeView.bounds];
    bgImgaeView2.image = [UIImage imageNamed:@"newhome-icon-nav-bj"];
    [bgImgaeView addSubview:bgImgaeView2];
    
    //******************************************
    //消息
    UIImage *notyImg = [UIImage imageNamed:@"home-icon-nav-new"];
    UIImageView *notymgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(bgImgaeView.frame)-KScaleWidth(22)-KScaleWidth(20), KScaleHeight(35), KScaleWidth(22), KScaleWidth(22))];
    notymgaeView.image = notyImg;
    [self addSubview:notymgaeView];
    
    if (!_orderNotyLabel) {
        _orderNotyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(notymgaeView.frame), CGRectGetMinY(notymgaeView.frame)-KScaleHeight(7), KScaleWidth(16), KScaleHeight(16))];
        _orderNotyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:9];
        _orderNotyLabel.textColor = RGB(255, 255, 255);
        _orderNotyLabel.text = @"0";
        _orderNotyLabel.textAlignment = NSTextAlignmentCenter;
        _orderNotyLabel.backgroundColor = [UIColor redColor];
        _orderNotyLabel.layer.cornerRadius = CGRectGetWidth(_orderNotyLabel.frame)/2.;
        _orderNotyLabel.layer.masksToBounds = YES;
        _orderNotyLabel.hidden = YES;
    }
    [self addSubview:_orderNotyLabel];
    
    UIButton *notyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    notyBt.frame = CGRectMake(CGRectGetMinX(notymgaeView.frame)-CGRectGetWidth(_orderNotyLabel.frame)/2., CGRectGetMinY(notymgaeView.frame)-CGRectGetHeight(_orderNotyLabel.frame)/2., CGRectGetMaxX(notymgaeView.frame)+CGRectGetWidth(_orderNotyLabel.frame)/2., CGRectGetMaxY(notymgaeView.frame)+CGRectGetHeight(_orderNotyLabel.frame)/2.);
    notyBt.backgroundColor = [UIColor clearColor];
    [notyBt addTarget:self action:@selector(onClickBtForNoty) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:notyBt];
    
    //******************************************
    //总工单数
    if (!_orderAllCountLabel) {
        _orderAllCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScaleWidth(43), KScaleHeight(80), KScaleWidth(52), KScaleHeight(37))];
        if ([UIScreen mainScreen].bounds.size.width <= 320) {
            _orderAllCountLabel.frame = CGRectMake(KScaleWidth(43), KScaleHeight(75), KScaleWidth(58), KScaleHeight(48));
        }
        _orderAllCountLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:50];
        _orderAllCountLabel.textColor = RGB(255, 255, 255);
        _orderAllCountLabel.text = @"0";
        _orderAllCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_orderAllCountLabel];
    
    //总工单类型
    if (!_orderAllTypeLabel) {
        _orderAllTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_orderAllCountLabel.frame)+KScaleWidth(10), CGRectGetMinY(_orderAllCountLabel.frame), KScaleWidth(100), KScaleHeight(20))];
        _orderAllTypeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _orderAllTypeLabel.textColor = RGB(255, 255, 255);
        _orderAllTypeLabel.text = @"当前任务";
        _orderAllTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    [self addSubview:_orderAllTypeLabel];
    
    //日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_orderAllTypeLabel.frame), CGRectGetMaxY(_orderAllCountLabel.frame)-KScaleHeight(20), CGRectGetWidth(_orderAllTypeLabel.frame), KScaleHeight(20))];
        _orderTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _orderTimeLabel.textColor = RGB(255, 255, 255);
        _orderTimeLabel.text = timeStr;
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    [self addSubview:_orderTimeLabel];
    
    //内容
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KScaleHeight(130), KScreenWidth, KScaleHeight(70)+KScaleHeight(20))];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
    }
    _contentScrollView.contentSize = CGSizeMake(KScreenWidth*_dataArray.count, CGRectGetHeight(_contentScrollView.frame));
    [self addSubview:_contentScrollView];
    
    if (!_pageContrl) {
        _pageContrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentScrollView.frame)-KScaleHeight(10), KScreenWidth, KScaleHeight(10))];
        _pageContrl.currentPage = 0;
        _pageContrl.backgroundColor = [UIColor clearColor];
        _pageContrl.pageIndicatorTintColor = [RGB(105, 105, 105)colorWithAlphaComponent:0.75];
        _pageContrl.currentPageIndicatorTintColor = UIColorFromRGB(0x4475EB);
    }
    _pageContrl.numberOfPages = _dataArray.count;
    [self addSubview:_pageContrl];
    
    NSArray *localArray = @[@{@"currentTask":@"0",@"workedTask":@"0",@"overTime":@"0",@"workedPercen":@"0"}];
    if (_dataArray.count == 0) {
        //初始化需要
        
    } else {
        localArray = _dataArray;
    }
    
    
    for (int i=0; i<localArray.count; i++) {
        NSDictionary *dic = [localArray objectAtIndex:i];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(KScaleWidth(15)+CGRectGetWidth(_contentScrollView.frame)*i, 0, CGRectGetWidth(_contentScrollView.frame)-KScaleWidth(15)*2, CGRectGetHeight(_contentScrollView.frame)-KScaleHeight(20))];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.;
//        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.15].CGColor;
        bgView.layer.borderWidth = 1.;
        bgView.layer.shadowColor = [RGB(127, 127, 127) colorWithAlphaComponent:1.15].CGColor;
        bgView.layer.shadowOffset = CGSizeMake(3, 3);
        bgView.layer.shadowRadius = 4;
        bgView.layer.shadowOpacity = 0.3;
        [_contentScrollView addSubview:bgView];
        
        NSInteger count = 3;
        if ([dic.allKeys containsObject:@"workedTask"] && [dic.allKeys containsObject:@"overTime"]) {
            //@{@"currentTask":@"0",@"workedTask":@"0",@"overTime":@"0",@"workedPercen":@"0"}
            //派巡
            count = 3;
            //总工单以及frame自适应
            _orderAllCountLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"currentTask"]];
            
            CGFloat itemWidth = [_orderAllCountLabel.text boundingRectWithSize:CGSizeMake(1000, CGRectGetHeight(_orderAllCountLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:50]} context:nil].size.width+KScaleWidth(10);
            _orderAllCountLabel.frame = CGRectMake(_orderAllCountLabel.frame.origin.x, _orderAllCountLabel.frame.origin.y, itemWidth, _orderAllCountLabel.frame.size.height);
            _orderAllTypeLabel.frame = CGRectMake(CGRectGetMaxX(_orderAllCountLabel.frame), _orderAllTypeLabel.frame.origin.y, _orderAllTypeLabel.frame.size.width, _orderAllTypeLabel.frame.size.height);
            _orderTimeLabel.frame = CGRectMake(CGRectGetMinX(_orderAllTypeLabel.frame), _orderTimeLabel.frame.origin.y, _orderTimeLabel.frame.size.width, _orderTimeLabel.frame.size.height);
        }
        else if ([dic.allKeys containsObject:@"oTReceiptSum"] && [dic.allKeys containsObject:@"appointmentSum"]) {
            //@"waitSum":@"0",@"oTReceiptSum":@"0",@"appointmentSum":@"0",@"badSum":@"0",@"hangupSum":@"0"
            //派修
            count = 4;
        }
        
        CGFloat itemWidth = 1. * CGRectGetWidth(bgView.frame) / count;
        for (int j=0; j<count; j++) {
            UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(itemWidth*j, KScaleHeight(10), itemWidth, KScaleHeight(22))];
            contentLb.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:18];
            contentLb.textColor = RGB(51, 51, 51);
            contentLb.text = @"0";
            contentLb.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:contentLb];
            
            UILabel *contentDetailLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(contentLb.frame), CGRectGetMaxY(contentLb.frame), itemWidth, KScaleHeight(20))];
            contentDetailLb.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
            contentDetailLb.textColor = RGB(153, 153, 153);
            contentDetailLb.text = @"";
            contentDetailLb.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:contentDetailLb];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(itemWidth*j, KScaleHeight(16), 1, KScaleHeight(38))];
            lineView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.35];
            lineView.hidden = NO;
            [bgView addSubview:lineView];
            
            UIButton *itemBt = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBt.frame = CGRectMake(itemWidth*j, 0, itemWidth, CGRectGetHeight(bgView.frame));
            itemBt.backgroundColor = [UIColor clearColor];
            [itemBt addTarget:self action:@selector(onClickBtForContent:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:itemBt];
            
            if (count == 4) {
                contentLb.tag = 40 + j;
                itemBt.tag = 400 + j;
                if (j == 0) {
                    contentDetailLb.text = @"超时接单";
                    lineView.hidden = YES;
                }
                else if (j == 1) {
                    contentDetailLb.text = @"预约单";
                }
                else if (j == 2) {
                    contentDetailLb.text = @"差评单";
                }
                else if (j == 3) {
                    contentDetailLb.text = @"已挂起";
                }
            }
            else if (count == 3) {
                contentLb.tag = 30 + j;
                itemBt.tag = 300 + j;
                if (j == 0) {
                    contentDetailLb.text = @"已完成";
                    contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"workedTask"]];
                    lineView.hidden = YES;
                }
                else if (j == 1) {
                    contentDetailLb.text = @"超时";
                    contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"overTime"]];
                    
                }
                else if (j == 2) {
                    contentDetailLb.text = @"完成率";
                    contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"workedPercen"]];
                }
            }
        }
    }
}

#pragma mark - Private Actions
- (void)onClickBtForNoty {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtByNotification:withNotificationCount:)]) {
        [_delegate onClickBtByNotification:self withNotificationCount:[_orderNotyLabel.text integerValue]];
    }
}

- (void)onClickBtForContent:(UIButton *)bt {
    
    NSInteger type = 10000;
    NSInteger count = 0;
    BOOL isOK = NO;
    switch (bt.tag) {
        case 400:
        {
            //超时接单 10000
            type = 10000;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 400) + 40)];
            count = [lb.text integerValue];
        }
            break;
        case 401:
        {
            //预约单 10001
            type = 10001;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 400) + 40)];
            count = [lb.text integerValue];
        }
            break;
        case 402:
        {
            //差评单 10002
            type = 10002;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 400) + 40)];
            count = [lb.text integerValue];
        }
            break;
        case 403:
        {
            //已挂起 10003
            type = 10003;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 400) + 40)];
            count = [lb.text integerValue];
        }
            break;
        case 300:
        {
            //已完成 10004
            type = 10004;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 300) + 30)];
            count = [lb.text integerValue];
        }
            break;
        case 301:
        {
            //超时 10005
            type = 10005;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 300) + 30)];
            count = [lb.text integerValue];
        }
            break;
        case 302:
        {
            //完成率 10006
            type = 10006;
            isOK = YES;
            UILabel *lb = (UILabel *)[self viewWithTag:((bt.tag - 300) + 30)];
            count = [lb.text integerValue];
        }
            break;
        default:
            break;
    }
    
    if (isOK == YES && _delegate && [_delegate respondsToSelector:@selector(onClickBtByHeaderView:withClickType:withHeaderCount:)]) {
        [_delegate onClickBtByHeaderView:self withClickType:type withHeaderCount:count];
    }
}

- (void)onScrollToView {
    ++_timeScrollIndex;
    if (_timeScrollIndex >= 5) {
        _timeScrollIndex = 0;
        if (_dataArray.count <= 1) {
            
        } else {
            if (_dataArray.count-1 > _pageContrl.currentPage) {
                [_contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(_contentScrollView.frame)*(_pageContrl.currentPage+1), 0) animated:YES];
            } else {
                [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
    }
}

#pragma mark - Publick Actions
- (void)onUpdateData:(NSArray *)data
{
    if (data.count == 0) {//初始化
        return;
    }
    
    //第一个派修(权限控制),第二个派巡(固定)
    _dataArray = data;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            for (UIView *view in obj.subviews) {
                if ([view isKindOfClass:[UIView class]]) {
                    [view.layer removeFromSuperlayer];
                }
            }
        }
        [obj removeFromSuperview];
    }];
    [self onCreatUI];
    [self onCreateTime];
    
    [self setNeedsLayout];
}

- (void)onUpdateMessageNumber:(NSString *)msgNumber
{
    if (msgNumber.length == 0) {
        _orderNotyLabel.hidden = YES;
    } else {
        if ([msgNumber integerValue] <= 0) {
            _orderNotyLabel.hidden = YES;
        }
        else if ([msgNumber integerValue] <= 99) {
            _orderNotyLabel.text = [NSString stringWithFormat:@"%@",msgNumber];
            _orderNotyLabel.hidden = NO;
        }
        else {
            _orderNotyLabel.text = [NSString stringWithFormat:@"%@",@"99+"];
            _orderNotyLabel.hidden = NO;
        }
    }
}

- (void)onCreateTime
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    //刷新
    _pageContrl.currentPage = 0;
    _timeScrollIndex = 0;
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onScrollToView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    _pageContrl.currentPage = index;
    
    if (_dataArray.count > index) {
        NSDictionary *dictionary = [_dataArray objectAtIndex:index];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSString *timeStr = [formatter stringFromDate:date];
        
        if ([dictionary.allKeys containsObject:@"oTReceiptSum"] && [dictionary.allKeys containsObject:@"appointmentSum"]) {
            //派巡
            //@"waitSum":@"0",@"oTReceiptSum":@"0",@"appointmentSum":@"0",@"badSum":@"0",@"hangupSum":@"0"
            _orderAllCountLabel.text = [dictionary objectForKey:@"waitSum"];
            _orderAllTypeLabel.text = @"待派遣工单";
            _orderTimeLabel.text = timeStr;
        }
        else if ([dictionary.allKeys containsObject:@"workedTask"] && [dictionary.allKeys containsObject:@"overTime"]) {
            //派修
            //@{@"currentTask":@"0",@"workedTask":@"0",@"overTime":@"0",@"workedPercen":@"0"}
            _orderAllCountLabel.text = [dictionary objectForKey:@"currentTask"];
            _orderAllTypeLabel.text = @"当前任务";
            _orderTimeLabel.text = timeStr;
        }
        
        //总数量以及工单类型,时间自适应
        CGFloat itemWidth = [_orderAllCountLabel.text boundingRectWithSize:CGSizeMake(1000, CGRectGetHeight(_orderAllCountLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:50]} context:nil].size.width+KScaleWidth(10);
        _orderAllCountLabel.frame = CGRectMake(_orderAllCountLabel.frame.origin.x, _orderAllCountLabel.frame.origin.y, itemWidth, _orderAllCountLabel.frame.size.height);
        _orderAllTypeLabel.frame = CGRectMake(CGRectGetMaxX(_orderAllCountLabel.frame), _orderAllTypeLabel.frame.origin.y, _orderAllTypeLabel.frame.size.width, _orderAllTypeLabel.frame.size.height);
        _orderTimeLabel.frame = CGRectMake(CGRectGetMinX(_orderAllTypeLabel.frame), _orderTimeLabel.frame.origin.y, _orderTimeLabel.frame.size.width, _orderTimeLabel.frame.size.height);
        
        [self setNeedsLayout];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer) {
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
//        [_timer invalidate];
//        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_timer) {
        //开启计时器
        _timeScrollIndex = 0;
        [_timer setFireDate:[NSDate distantPast]];
//        [self onCreateTime];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
     *根据data.count区分
     *1.只有一个的时候,只显示派巡数据
     *2.有2个的时候,显示派巡和派修数据
     *3.拓展,显示派巡和派修,其他数据
     */
    if (_dataArray.count > 0) {
        
        for (int i=0; i<_dataArray.count; i++) {
            NSDictionary *dic = [_dataArray objectAtIndex:i];
            if ([dic.allKeys containsObject:@"oTReceiptSum"] && [dic.allKeys containsObject:@"appointmentSum"]) {
                //派修
                
                //@"waitSum":@"0",@"oTReceiptSum":@"0",@"appointmentSum":@"0",@"badSum":@"0",@"hangupSum":@"0"
                for (int i=0; i<4; i++) {
                    UILabel *contentLb = (UILabel *)[self viewWithTag:(40+i)];
                    if (i==0) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"oTReceiptSum"]];
                    }
                    else if (i==1) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appointmentSum"]];
                    }
                    else if (i==2) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"badSum"]];
                    }
                    else if (i==2) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hangupSum"]];
                    }
                }
            }
            else if ([dic.allKeys containsObject:@"workedTask"] && [dic.allKeys containsObject:@"overTime"]) {
                //派巡
                
                //@{@"currentTask":@"0",@"workedTask":@"0",@"overTime":@"0",@"workedPercen":@"0"}
                for (int i=0; i<3; i++) {
                    UILabel *contentLb = (UILabel *)[self viewWithTag:(30+i)];
                    if (i==0) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"workedTask"]];
                    }
                    else if (i==1) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"overTime"]];
                    }
                    else if (i==2) {
                        contentLb.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"workedPercen"]];
                    }
                }
            }
        }
    }
}

@end
