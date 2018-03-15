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
    
    //创建一个摄像机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;// 自动调节可视范围
    cameraNode.position = SCNVector3Make(0, 0, 10);
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //创建一个节点并绑定一个平面几何对象
    SCNNode *boxNode = [SCNNode node];
    SCNPlane *plane = [SCNPlane planeWithWidth:16 height:9];
    boxNode.geometry = plane;
    boxNode.geometry.firstMaterial.doubleSided = true;
    boxNode.position = SCNVector3Make(0, 0, -30);
    [scnView.scene.rootNode addChildNode:boxNode];
    
    //创建一个2D游戏场景和一个播放视频的对象
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"WeChatSight1696" withExtension:@"mp4"];
    SKVideoNode *videoNode = [SKVideoNode videoNodeWithURL:url];
    videoNode.size = CGSizeMake(1600, 900);
    videoNode.position = CGPointMake(videoNode.size.width/2, videoNode.size.height/2);
    videoNode.zRotation = M_PI;
    SKScene* skScene = [SKScene sceneWithSize:videoNode.size];
    [skScene addChild:videoNode];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinGesture:)];
    
    [self.gestureView addGestureRecognizer:pan];
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
