//
//  ViewController.m
//  ARKit-Learn25
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏专用视图
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.scene = [SCNScene scene];
    [self.view addSubview:scnView];
    
    //创建一个摄像机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    //自动调节可视范围
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, 0, 10);
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //创建一个节点并绑定一个平面几何对象
    SCNNode *boxNode = [SCNNode node];
    SCNPlane *plane = [SCNPlane planeWithWidth:16 height:9];
    boxNode.geometry = plane;
    boxNode.geometry.firstMaterial.doubleSided = YES;
    boxNode.position = SCNVector3Make(0, 0, -30);
    [scnView.scene.rootNode addChildNode:boxNode];
    
    
    
    //创建一个2D游戏场景和一个播放视频的对象
    //视频添加到项目中的时候,使用右击->add File to 的方式添加文件!!!
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"WeChatSight1696" withExtension:@"mp4"];
    SKVideoNode *videoNode = [SKVideoNode videoNodeWithURL:url];
    videoNode.size = CGSizeMake(1600, 900);
    videoNode.position = CGPointMake(videoNode.size.width/2, videoNode.size.height/2);
    videoNode.zRotation = M_PI;
    SKScene *skScene = [SKScene sceneWithSize:videoNode.size];
    [skScene addChild:videoNode];
    
    
    
    //给平面体设置渲染内容
    plane.firstMaterial.diffuse.contents = skScene;
    
    // 播放视频
    [videoNode play];
    
    //打开摄像头控制查看效果
    
    scnView.allowsCameraControl = true;
}


/*

 28-渲染普通视频

 本节学习目标
 使用SceneKit如何播放视频
 scenekit 播放视频的方式有很多种,今天我就给大家介绍一种最简单的播放视频的方式
 
 使用的技术
 要用到SpriteKit框架中的一个类SKVideoNode,这个类主要用来在2D游戏中渲染视频的,今天我们就借助这个类,实现在3D场景中播放视频
 
 效果如下 Scenekit_11.gif
 --
 
 ####实现步骤
 
 1.第一步 创建工程(略)
 
 2.第二步 导入两个游戏框架
 
 import SceneKit
 import SpriteKit
 
 3.第三步 创建游戏专用视图
 
 let scnView = SCNView(frame: self.view.bounds);
 scnView.scene = SCNScene()
 self.view.addSubview(scnView);
 
 4.第四步 创建一个摄像机
 
 let cameraNode = SCNNode()
 cameraNode.camera = SCNCamera()
 cameraNode.camera?.automaticallyAdjustsZRange = true;// 自动调节可视范围
 cameraNode.position = SCNVector3Make(0, 0, 10);
 scnView.scene?.rootNode.addChildNode(cameraNode);
 
 5.第五步 创建一个节点并绑定一个平面几何对象
 
 let boxNode = SCNNode()
 let plane = SCNPlane(width: 16, height: 9)
 boxNode.geometry = plane;
 boxNode.geometry?.firstMaterial?.isDoubleSided = true
 boxNode.position = SCNVector3Make(0, 0, -30);
 scnView.scene?.rootNode.addChildNode(boxNode);
 
 6.第六步 创建一个2D游戏场景和一个播放视频的对象
 
 let url = Bundle.main.url(forResource: "123-pad", withExtension: "mp4")
 let videoNode = SKVideoNode(url: url!)
 videoNode.size = CGSize(width: 1600, height: 900)
 videoNode.position = CGPoint(x: videoNode.size.width/2, y: videoNode.size.height/2)
 videoNode.zRotation = CGFloat(M_PI)
 let skScene = SKScene()
 skScene.addChild(videoNode)
 skScene.size = videoNode.size
 
 经验：
 
 1.视频添加到项目中的时候,使用右击->add File to 的方式添加文件
 2.指定视频节点的大小 videoNode.size
 3.指定2d场景的大小,这个一般和视频节点大小保持一致,如果你有特殊要求,可以根据要求设置
 4.videoNode.zRotation = CGFloat(M_PI)注意,这点非常重要,一定要将视频节点旋转180度,否则渲染出来的画面会颠倒。
 
 7.第七步 给平面体设置渲染内容
 
 plane.firstMaterial?.diffuse.contents = skScene
 
 8.第八步 播放视频
 
 videoNode.play()
 
 9.第十步 打开摄像头控制查看效果
 
 scnView.allowsCameraControl = true;
 

 */


@end
