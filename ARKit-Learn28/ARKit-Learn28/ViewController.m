//
//  ViewController.m
//  ARKit-Learn28
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>

#define VIDEO_WIDHT 1280
#define VIDEO_HEIGHT 640

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏专用视图
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scnView];;
    
    scnView.scene = [SCNScene scene];
    
    //创建一个摄像机
//    SCNNode *cameraNode = [SCNNode node];
//    cameraNode.camera = [SCNCamera camera];
//    cameraNode.camera.automaticallyAdjustsZRange = true;// 自动调节可视范围
//    cameraNode.position = SCNVector3Make(0, 0, 10);
//    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //创建一个节点并绑定一个球体对象
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = [SCNSphere sphereWithRadius:10];
    sphereNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2);
    [scnView.scene.rootNode addChildNode:sphereNode];
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"WeChatSight1696" withExtension:@"mp4"];
//    SKVideoNode *videoNode = [SKVideoNode videoNodeWithURL:url];
    
    
    //创建一个AVPlayer 对象
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    
    //创建一个SCNVedioNode 对象
    SKVideoNode *videoNode = [[SKVideoNode alloc]initWithAVPlayer:player];
    videoNode.size = CGSizeMake(1600, 900);
    videoNode.position = CGPointMake(videoNode.size.width/2, videoNode.size.height/2);
    videoNode.zRotation = M_PI;
    
    //创建一个SKScene对象
    SKScene *skScene = [SKScene sceneWithSize:videoNode.size];
    skScene.scaleMode = SKSceneScaleModeAspectFit;
    
    //让球体去渲染这个SKScene对象
    [skScene addChild:videoNode];
    videoNode.position = CGPointMake(VIDEO_WIDHT/2, VIDEO_HEIGHT/2);
    
    //将skScene对象设置为球体渲染的内容
    sphereNode.geometry.firstMaterial.diffuse.contents  = skScene;
    
    //监听播放器的当前时间,缓冲时间,视频总时长
    id observerPlayerTime = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 处理逻辑代码
        CMTimeShow(time);
    }];
    NSLog(@"==:%@",observerPlayerTime);
    //视频可播放状态检测
    [player reasonForWaitingToPlay];
    
    //播放/暂停功能
    
    [player play];
//    [player pause];
    
    //播放完成/失败检测
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFail:) name:AVPlayerItemNewErrorLogEntryNotification object:nil];
}
- (void)playToEndTime:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
- (void)playFail:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
/*
 32-如何创建将APlayer 加载的视频渲染到球体上

 实现步骤
 第一步 创建一个AVPlayer 对象
 
 _player = [[AVPlayer alloc]init];
 
 第二步 创建一个SCNVedioNode 对象
 
 self.vedioNode = [[SKVideoNode alloc]initWithAVPlayer:_player];
 self.vedioNode.size = CGSizeMake(VEDIO_WIDHT, VEDIO_HEIGHT);
 
 第三步 创建一个SKScene 对象
 
 _skScene = [SKScene sceneWithSize:self.vedioNode.size];
 self.skScene.scaleMode = SKSceneScaleModeAspectFit;
 
 第四步 让球体去渲染这个SKScene 对象
 
 [self.skScene addChild:self.vedioNode];
 self.vedioNode.position = CGPointMake(VEDIO_WIDHT/2, VEDIO_HEIGHT/2);
 // 将skscene对象设置为球体渲染的内容
 self.renderNode.geometry.firstMaterial.diffuse.contents=self.skScene;
 
 其他功能实现
 下面这部分都比较简单
 
 1.监听播放器的当前时间,缓冲时间,视频总时长
 
 self.observerPlayerTime = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
 // 处理逻辑代码
 }];
 
 2.视频可播放状态检测
 
 [self.player reasonForWaitingToPlay]
 
 3.播放/暂停功能
 
 [self.player play];
 [slef.player pause];
 
 4.播放完成/失败检测
 
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFail:) name:AVPlayerItemNewErrorLogEntryNotification object:nil];
 
 5.计算视频缓冲的时间
 
 NSArray *loadedTimeRanges = [[self.player currentItem]   loadedTimeRanges];
 CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
 float startSeconds = CMTimeGetSeconds(timeRange.start);
 float durationSeconds = CMTimeGetSeconds(timeRange.duration);
 NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
 
 */

@end
