//
//  ViewController.m
//  ARKit-Learn29
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

#define VIDEO_WIDHT 1600
#define VIDEO_HEIGHT 900
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *gestureView;
@property (assign, nonatomic)CGFloat lastPoint_x;
@property (assign, nonatomic)CGFloat lastPoint_y;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建游戏专用视图
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scnView];;
    
    
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
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
    
    //我们知道现在球体是有了,但是我们还需要一个眼睛去观察球体,在全景下,眼睛是根据重力感应,来调节观察的角度,所以我们下面创建一个眼睛节点,然后将其放入场景的中心点
//    SCNNode *eyeNode = [SCNNode node];
//    eyeNode = [SCNNode node];
//    eyeNode.camera = [SCNCamera camera]; // 创建照相机对象 就是眼睛
//    eyeNode.camera.automaticallyAdjustsZRange = true; // 自动添加可视距离
//        eyeNode.camera.xFov = 30;
//        eyeNode.camera.yFov = 30;
//        eyeNode.camera.focalBlurRadius = 0;
////    eyeNode.camera.focalLength = 30;
////    eyeNode.camera.focusDistance = 30;
////    eyeNode.camera.fStop = 0;
//    [scene.rootNode addChildNode:eyeNode];
    
    //创建一个2D游戏场景和一个播放视频的对象
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"WeChatSight1696" withExtension:@"mp4"];
    
    //创建一个AVPlayer 对象
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    
    SKVideoNode *videoNode = [SKVideoNode videoNodeWithURL:url];
    videoNode.size = CGSizeMake(1600, 900);
    videoNode.position = CGPointMake(videoNode.size.width/2, videoNode.size.height/2);
    videoNode.zRotation = M_PI;
    SKScene* skScene = [SKScene sceneWithSize:videoNode.size];
   

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

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinGesture:)];
    
    [self.gestureView addGestureRecognizer:pan];
}

- (void)playToEndTime:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
- (void)playFail:(NSNotification *)noti{
    NSLog(@"==:%@",noti);
}
- (void)panGesture:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan){
        CGPoint currentPoint = [panGesture locationInView:panGesture.view];
        self.lastPoint_x = currentPoint.x;
        self.lastPoint_y = currentPoint.y;
//        [self.delegate gestureManager:self panGesture:panGesture matrix4:SCNMatrix4Identity];
    }else{
        CGPoint currentPoint = [panGesture locationInView:panGesture.view];
        float distX = currentPoint.x - self.lastPoint_x;
        float distY = currentPoint.y - self.lastPoint_y;
        self.lastPoint_x = currentPoint.x;
        self.lastPoint_y = currentPoint.y;
        // 这里进行手势滑动视角的微调,根据需求设置
        distX *= -0.005;
        distY *= -0.005;
//        self.fingerRotationY += distX *  OSVIEW_CORNER / 100.0;
//        self.fingerRotationX += distY *  OSVIEW_CORNER / 100.0;
//        SCNMatrix4 modelMatrix = SCNMatrix4Identity;
//        modelMatrix = SCNMatrix4Rotate(modelMatrix, self.fingerRotationX,1, 0, 0);
//        modelMatrix = SCNMatrix4Rotate(modelMatrix, self.fingerRotationY, 0, 1, 0);
//
    }
}

/*
 
 33-手势移动来调节呈现出来的画面位置
 
 如何实现通过手势移动来调节呈现出来的画面位置
 
 实现步骤
 1.单独创建一个视图放在最外层,放手势对象
 
 [view addGestureRecognizer:self.panGesture];
 
 2.创建一个滑动手势
 
 self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self     action:@selector(pinchGesture:)];
 
 3.转换为旋转角度
 
 if (panGesture.state == UIGestureRecognizerStateBegan){
 CGPoint currentPoint = [panGesture locationInView:panGesture.view];
 self.lastPoint_x = currentPoint.x;
 self.lastPoint_y = currentPoint.y;
 [self.delegate gestureManager:self panGesture:panGesture matrix4:SCNMatrix4Identity];
 }else{
 CGPoint currentPoint = [panGesture locationInView:panGesture.view];
 float distX = currentPoint.x - self.lastPoint_x;
 float distY = currentPoint.y - self.lastPoint_y;
 self.lastPoint_x = currentPoint.x;
 self.lastPoint_y = currentPoint.y;
 // 这里进行手势滑动视角的微调,根据需求设置
 distX *= -0.005;
 distY *= -0.005;
 self.fingerRotationY += distX *  OSVIEW_CORNER / 100.0;
 self.fingerRotationX += distY *  OSVIEW_CORNER / 100.0;
 SCNMatrix4 modelMatrix = SCNMatrix4Identity;
 modelMatrix = SCNMatrix4Rotate(modelMatrix, self.fingerRotationX,1, 0, 0);
 modelMatrix = SCNMatrix4Rotate(modelMatrix, self.fingerRotationY, 0, 1, 0);
 
 4.改变照相机的旋转角度
 
 self.eyeNode.pivot = modelMatrix;

 */


@end
