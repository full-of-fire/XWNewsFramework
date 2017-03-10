//
//  ViewController.m
//  XWNewsSDKDemo
//
//  Created by yj on 16/11/28.
//  Copyright © 2016年 yj. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import <XWNewsFrameWork/XWNewsFrameWork.h>

@interface ViewController ()<XWNewsViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // 首页的情况
    XWNewsViewController *control = [[XWNewsViewController alloc] init];
    [self.view addSubview:control.view];
    control.view.frame = self.view.bounds;
    [self addChildViewController:control];
    control.delegate =self;

    
#warning 自选频道 例子
    NSString *nameStr = @"美食";
    UIButton *chooseChannel = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseChannel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height-100, 50, 50);
    chooseChannel.layer.cornerRadius = 25;
    [chooseChannel setTitle:nameStr forState:UIControlStateNormal];
    chooseChannel.backgroundColor = [UIColor greenColor];
    [chooseChannel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:chooseChannel];
    [chooseChannel addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   

}
/*
 
 自选单个频道sdk会根据传入的channelName来匹配频道匹配不到默认为推荐频道
 用户可自行选择频道（如： 娱乐，视频，国际 等等。。。）
 具体频道名参照http://www.myxianwen.com里的名字为准
 
 */
-(void)chooseButtonAction:(UIButton *)button{
    
    NSString *nameStr = button.titleLabel.text;
    
    XWOnlyNewsListViewController *newsList = [[XWOnlyNewsListViewController alloc] init];
    newsList.delegate = self;
    newsList.channelName = nameStr;
    [self presentViewController:newsList animated:YES completion:nil];
}
/**
 单频道列表的返回按钮点击
 
 @param onlyNewsListViewController 新闻列表控制器
 @param backItem              返回item
 */
- (void)onlyNewsListViewController:(UIViewController*)onlyNewsListViewController didSelecctedBackItem:(UIButton*)backItem{
    
    [onlyNewsListViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)secondAction {

    
    FirstViewController *firstVC = [FirstViewController new];
    
    [self presentViewController:firstVC animated:YES completion:nil];
}


- (void)newsViewController:(UIViewController *)controller didSeletedRowAtIndex:(NSIndexPath *)indexPath news:(XWNews *)news op_from:(NSString *)op_from {
    //news.skipType
    //     news.news_id = @"6661731";
    switch (news.skipType) {
        case XWNewsSkipTypeNone:
            // 不跳转
            break;
        case XWNewsSkipTypeNoraml:
            
            // 普通新闻
        {
            XWNewsDetailController *detail = [[XWNewsDetailController alloc] init];
            
            detail.news = news;
            detail.channel_id = op_from;
            detail.delegate = self;
            [controller presentViewController:detail animated:YES completion:nil];
        }
            
            break;
        case XWNewsSkipTypeImage:
            // 图片新闻
        {
            XWImageNewsController *imagesVC = [[XWImageNewsController alloc] init];
            imagesVC.channel_id = op_from;
            imagesVC.news = news;
            imagesVC.delegate = self;
            [controller presentViewController:imagesVC animated:YES completion:nil];
        }
            break;
        case XWNewsSkipTypeViedeo:
            // 视频
        {
            XWVideoDetailViewController *videoVC = [[XWVideoDetailViewController alloc] init];
            videoVC.channel_id = op_from;
            videoVC.news = news;
            videoVC.delegate = self;
            [controller presentViewController:videoVC animated:YES completion:nil];
        }
            break;
        case XWNewsSkipTypeProject:
            // 专题列表
            
        {
            
            XWSubjectListController *subject = [[XWSubjectListController alloc] init];
            
            subject.news = news;
            subject.channel_id = op_from;
            subject.delegate = self;
            
            [controller presentViewController:subject animated:YES completion:nil];
            
        }
            
            
            break;
        case XWNewsSkipTypeProjectDetail:
            // 专题详情
        {
            
            XWSubjectListController *subject = [[XWSubjectListController alloc] init];
            
            subject.news = news;
            subject.channel_id = op_from;
            subject.delegate = self;
            
            [controller presentViewController:subject animated:YES completion:nil];
            
            XWNewsDetailController *detail = [[XWNewsDetailController alloc] init];
            
            detail.news = news;
            detail.channel_id = op_from;
            detail.delegate = self;
            [subject presentViewController:detail animated:YES completion:nil];
            
        }
            break;
        case XWNewsSkipTypeActivity:
            // 活动
        {
            XWActivityViewController *activityVC = [[XWActivityViewController alloc] init];
            activityVC.news = news;
            activityVC.delegate = self;
            
            [controller presentViewController:activityVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}



/**
 专题列表点击事件
 
 @param backItem 返回按钮
 */
- (void)subjectListController:(UIViewController *)subjectListController didSelecctedBackItem:(UIButton *)backItem {
    
    
    [subjectListController dismissViewControllerAnimated:YES completion:nil];
}


// 新闻详情或者图片新闻底部状态的的点击事件
- (void)newsDetailController:(UIViewController *)newsDetailController didSelectTabBarItem:(UIButton *)item news:(XWNews *)news {
    
    switch (item.tag) {
        case XWBottomButtonTypeBack:
            
            //返回
            [newsDetailController dismissViewControllerAnimated:YES completion:nil];
            break;
            //评论
        case XWBottomButtonTypeComment:
            break;
        case XWBottomButtonTypeShare:
            
            // 分享
            
            break;
        default:
            break;
    }
}


// 活动页面的返回按钮点击事件
- (void)activityControllerDidSelectedBackItem:(UIViewController *)activityController {
    
    [activityController dismissViewControllerAnimated:YES completion:nil];
}
//  视频页面分享点击事件
-(void)videoDetailViewController:(UIViewController *)videoDetailController didSelectShareItem:(UIButton *)item news:(XWNews *)news{
    
    NSLog(@"videoshare ---3");
}
//视频页面返回按钮点击事件
-(void)videoDetailViewController:(UIViewController *)videoDetailViewController didSelectBackItem:(UIButton *)item news:(XWNews *)news{
    
    NSLog(@"videoback ---1");
    [videoDetailViewController dismissViewControllerAnimated:YES completion:nil];
}


// 新闻列表的回调状态
- (void)newsNetloadType:(XWNetLoadType)netLoadType resultCode:(int)resultCode dataCount:(NSUInteger)dataCount netError:(NSError *)error {
    
    
    if (netLoadType == XWNetLoadTypeNewsList) {
        
        if (error) {
            
            // 网络出错
            NSLog(@"neterror = %@",error);
        }
        else{
            
            if (resultCode == 0) {
                
                NSLog(@"请求成功 ---新闻条数 = %lu",(unsigned long)dataCount);
            }
            else {
                
                
                NSLog(@"参数错误");
            }
        }
    }
    
}


- (BOOL)prefersStatusBarHidden {

    return NO; // xit
}

@end
