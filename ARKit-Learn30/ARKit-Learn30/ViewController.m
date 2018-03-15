//
//  ViewController.m
//  ARKit-Learn30
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>

#define VIDEO_WIDHT 1600
#define VIDEO_HEIGHT 900
@interface ViewController ()
@property(nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;
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
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    [scnView addGestureRecognizer:self.pinchGesture];
}
- (void)playToEndTime:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
- (void)playFail:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
//-(void)pinchGesture:(UIPinchGestureRecognizer*)pinchGesture{
//    if (pinchGesture.state != UIGestureRecognizerStateEnded &&   pinchGesture.state != UIGestureRecognizerStateFailed) {
//        if (pinchGesture.scale != NAN && pinchGesture.scale != 0.0) {
//            float scale = pinchGesture.scale - 1;
//            if (scale < 0) scale *= (sScaleMax - sScaleMin);
//            _currentScale = scale + _prevScale;
//            _currentScale = [self validateScale:_currentScale];
//            CGFloat valScale = [self validateScale:_currentScale];
//            double xFov = CAMERA_FOX * (1-(valScale-1)*0.15);
//            double yFov = CAMERA_HEIGHT * (1-(valScale-1)*0.15);
//        }
//    } else if(pinchGesture.state == UIGestureRecognizerStateEnded){
//        _prevScale = _currentScale;
//    }
//}
//-(float)validateScale:(float)scale{
//    if (scale < sScaleMin)
//        scale = sScaleMin;
//    else if (scale > sScaleMax) scale = sScaleMax;
//    return scale;
//}
/*
 
 本节学习目标 捏合手势如何缩放画面
 
 实现步骤
 1.创建捏合手势添加到视图中去,这个视图也是最外层的视图
 
 self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
 [view addGestureRecognizer:self.pinchGesture];
 
 2.算法处理,改变Camera属性的xFov ,yFov
 
 -(void)pinchGesture:(UIPinchGestureRecognizer*)pinchGesture{
 if (pinchGesture.state != UIGestureRecognizerStateEnded &&   pinchGesture.state != UIGestureRecognizerStateFailed) {
 if (pinchGesture.scale != NAN && pinchGesture.scale != 0.0) {
 float scale = pinchGesture.scale - 1;
 if (scale < 0) scale *= (sScaleMax - sScaleMin);
 _currentScale = scale + _prevScale;
 _currentScale = [self validateScale:_currentScale];
 CGFloat valScale = [self validateScale:_currentScale];
 double xFov = CAMERA_FOX * (1-(valScale-1)*0.15);
 double yFov = CAMERA_HEIGHT * (1-(valScale-1)*0.15);
 }
 } else if(pinchGesture.state == UIGestureRecognizerStateEnded){
 _prevScale = _currentScale;
 }
 }
 -(float)validateScale:(float)scale{
 if (scale < sScaleMin)
 scale = sScaleMin;
 else if (scale > sScaleMax) scale = sScaleMax;
 return scale;
 }
 
 prevScale上一次比例
 
 3.改变照相机节点的属性xFov,yFov
 
 self.eyeNode.camera.xFov = xFov;
 self.eyeNode.camera.yFov = yFor;
 
 问题:
 
 为什么缩放不是改变球体的半径呢？ 答:因为照相机的视野范围不改变,无论球体半径多大,呈现出来的部分都不会改变,如下
 */
@end
