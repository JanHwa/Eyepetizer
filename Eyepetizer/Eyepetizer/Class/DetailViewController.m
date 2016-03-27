//
//  DetailViewController.m
//  Eyepetizer
//
//  Created by qianfeng on 16/3/18.
//  Copyright © 2016年 CheeHwa. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "KRVideoPlayerController.h"
#import "CollectModel.h"

@interface DetailViewController ()
{
    UIImageView *_bgImage;
    UIImageView *_frontImage;
    UIButton *_playButton;
    UILabel *_titleLabel;
    UIView *_lineView;
    UILabel *_cTlabel;
    UILabel *_contentLabel;
    UIView *_bgView;
    
    // 收藏按钮
    UIButton *_collectBtn;
    // 收藏提示
    UILabel *_messageLabel;
}

@property(nonatomic, strong)KRVideoPlayerController *videoController;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self customButton:@"back" withLocation:YES];
}

- (void)loadData
{
    
}
- (void)configUI
{
    KWS(ws);
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top).offset(0);
        make.left.equalTo(ws.view.mas_left).offset(0);
        make.bottom.equalTo(ws.view.mas_bottom).offset(0);
        make.right.equalTo(ws.view.mas_right).offset(0);
    }];
    // 创建背景视图
    _bgImage             = [[UIImageView alloc] init];
    [_bgImage sd_setImageWithURL:[NSURL URLWithString:_detailCoverBlurred]];
    [_bgView addSubview:_bgImage];
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top).offset(64);
        make.left.equalTo(ws.view.mas_left).offset(0);
        make.bottom.equalTo(ws.view.mas_bottom).offset(0);
        make.right.equalTo(ws.view.mas_right).offset(0);
    }];
    // 创建前面的视图
    _frontImage             = [[UIImageView alloc] init];
    [_frontImage sd_setImageWithURL:[NSURL URLWithString:_detailCoverForFeed]];
    [_bgView addSubview:_frontImage];
    [_frontImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImage.mas_top).offset(0);
        make.left.equalTo(ws.view.mas_left).offset(0);
        make.height.mas_equalTo(kScreenWidth *(9.0/16.0));
        make.right.equalTo(ws.view.mas_right).offset(0);
    }];
    // 创建player按钮
    _playButton = [[UIButton alloc] init];
    [_bgView addSubview:_playButton];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_frontImage.mas_centerX);
        make.centerY.equalTo(_frontImage.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.equalTo(_playButton.mas_width);
        
    }];
    
    // 标题
    _titleLabel           = [[UILabel alloc] init];
    _titleLabel.text      = _detailTitle;
    _titleLabel.font      = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor colorWithRed:0.909 green:0.912 blue:0.921 alpha:1.000];
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frontImage.mas_bottom).offset(35);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(ws.view.mas_right).offset(0);
    }];
    // 下划线
    _lineView                 = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:0.703 green:0.693 blue:0.713 alpha:1.000];
    [_bgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(2);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(kScreenWidth*0.5);
    }];
    // 分类和时间
    _cTlabel           = [[UILabel alloc] init];
    _cTlabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.82 alpha:1];
    _cTlabel.text      = [NSString stringWithFormat:@"#%@ / %@\"",_detailCategory,_detailDuration];
    [_bgView addSubview:_cTlabel];
    [_cTlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(8);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.height.mas_equalTo(30);
        make.right.equalTo(ws.view.mas_right).offset(0);
    }];
    // 内容简介
    _contentLabel               = [[UILabel alloc] init];
    _contentLabel.text          = _detailDescription;
    if (kScreenWidth == 320 && kScreenHeight == 480) {
        _contentLabel.font          = [UIFont systemFontOfSize:15];
    }else if (kScreenWidth == 320 && kScreenHeight == 568){
        _contentLabel.font          = [UIFont systemFontOfSize:17];
    }else if (kScreenWidth == 375 && kScreenHeight == 667){
        _contentLabel.font          = [UIFont systemFontOfSize:20];
    }else{
        _contentLabel.font          = [UIFont systemFontOfSize:21];
    }
    _contentLabel.textColor     = [UIColor colorWithRed:0.798 green:0.797 blue:0.815 alpha:1.000];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_bgView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cTlabel.mas_bottom).offset(5);
        make.left.equalTo(ws.view.mas_left).offset(10);
        make.bottom.equalTo(ws.view.mas_bottom).offset(-20);
        make.right.equalTo(ws.view.mas_right).offset(-10);
    }];
    
    // 收藏按钮
    _collectBtn = [[UIButton alloc] init];
    _collectBtn.layer.cornerRadius = 5;
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"bulletscreen_icon_like"] forState:UIControlStateNormal];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"bulletscreen_icon_like_"] forState:UIControlStateSelected];
    [_bgView addSubview:_collectBtn];
    
     if ([CollectModel MR_findByAttribute:@"title" withValue:_detailTitle].count > 0) {
           _collectBtn.selected = YES;
      }
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_frontImage.mas_bottom).offset(8);
        make.right.equalTo(ws.view.mas_right).offset(-15);
        make.width.height.mas_equalTo(30);
    }];
    
    // 提示Label
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.backgroundColor = [UIColor grayColor];
    _messageLabel.alpha = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.mas_centerX);
        make.bottom.equalTo(_bgView.mas_bottom).offset(-100);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    // 添加手势操作
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc ]initWithTarget:self action:@selector(swipeClick:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.numberOfTouchesRequired = 2;
    [_bgView addGestureRecognizer:swipe];
}

/**
 *    收藏按钮的方法
 */

- (void)collectBtnClick:(UIButton *)sender
{
    if (sender.selected) {
        // 当前状态是收藏,现在执行取消操作
        CollectModel  *model = [[CollectModel MR_findByAttribute:@"title" withValue:_detailTitle ] firstObject];
        [model MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [UIView animateWithDuration:1.5 animations:^{
            _messageLabel.text = @"取消收藏";
            _messageLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.5 animations:^{
                _messageLabel.alpha = 0;
            }];
        }];
        
    }else{
        // 当前状态没有收藏,现在执行收藏操作
        CollectModel *model = [CollectModel MR_createEntity];
        model.title = _detailTitle;
        model.category = _detailCategory;
        model.duration = [NSString stringWithFormat:@"%@",_detailDuration];
        model.playUrl = _detailPlayUrl;
        model.coverForFeed = _detailCoverForFeed;
        model.my_description = _detailDescription;
        model.coverBlurred = _detailCoverBlurred;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [UIView animateWithDuration:1.5 animations:^{
            _messageLabel.text = @"收藏成功";
            _messageLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.5 animations:^{
                _messageLabel.alpha = 0;
            }];;
        }];
    }
    sender.selected = !sender.selected;
}

/*
 分享按钮按钮
 */
- (void)shareBtnClick:(UIButton *)sender
{
}

- (void)swipeClick:(UISwipeGestureRecognizer *)sendr
{
    [_videoController dismiss];
}

// 返回按钮并结束播放
- (void)backBtnClick
{
    [_videoController dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击播放按钮
- (void)playBtnClick
{
    
    NSURL *url = [NSURL URLWithString:_detailPlayUrl];
    [self playerUrl:url];
}


- (void)playerUrl:(NSURL *)url
{
    if (!self.videoController) {
        _videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth *(9.0/16.0))];
        [_videoController setShouldAutoplay:YES];
        [_videoController setFullscreen:YES animated:YES];
        __weak typeof(self) ws = self;
        [_videoController setDimissCompleteBlock:^{
            ws.videoController = nil;
        }];
        [_videoController showInWindow];
    }
    _videoController.contentURL = url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
