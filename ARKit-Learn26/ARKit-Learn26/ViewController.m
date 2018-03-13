//
//  ViewController.m
//  ARKit-Learn26
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
    scnView.backgroundColor = [UIColor lightGrayColor];
    
    scnView.scene = [SCNScene scene];
    [self.view addSubview:scnView];
    
    
    
    //创建一个摄像机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = YES;// 自动调节可视范围
    cameraNode.position = SCNVector3Make(0, 0, 0);// 把摄像机放在中间
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //创建一个节点并绑定一个球体几何对象
    SCNNode *panoramaNode = [SCNNode node];
//    SCNSphere *sphere = [SCNSphere sphereWithRadius:100];
    SCNPlane *plane = [SCNPlane planeWithWidth:16 height:9];
    panoramaNode.geometry = plane;
    // 关闭双面渲染,提高性能
    panoramaNode.geometry.firstMaterial.doubleSided = NO;
    //全景一般照相机应该放在球体中间,我们要渲染内表面,但是默认渲染的是外表面,所以我们设置一
    panoramaNode.geometry.firstMaterial.cullMode = SCNCullModeBack;
    panoramaNode.position = SCNVector3Make(0, 0, 0);
    [scnView.scene.rootNode addChildNode:panoramaNode];
    
    //创建一个2D游戏场景和一个播放视频的对象
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"WeChatSight1696" withExtension:@"mp4"];
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
    scnView.allowsCameraControl = YES;
    
    
}


/*
 
 29-渲染全景视频
 
 上一节我们讲解了如何播放普通视频,本节我们讲解如何播放全景视频,其实两者的差异不是很大, 只是使用的渲染几何体有所不同，普通视频使用的是平面几何体,我们全景就使用球体。
 
 
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
 cameraNode.position = SCNVector3Make(0, 0, 0);// 把摄像机放在中间
 scnView.scene?.rootNode.addChildNode(cameraNode);
 
 5.第五步 创建一个节点并绑定一个球体几何对象
 
 let panoramaNode = SCNNode()
 panoramaNode.geometry = SCNSphere(radius: 100);
 panoramaNode.geometry?.firstMaterial?.isDoubleSided = false// 关闭双面渲染,提高性能
 panoramaNode.geometry?.firstMaterial?.cullMode = .back
 panoramaNode.position = SCNVector3Make(0, 0, 0);
 scnView.scene?.rootNode.addChildNode(panoramaNode);
 
 经验:
 
 1.全景一般照相机应该放在球体中间,我们要渲染内表面,但是默认渲染的是外表面,所以我们设置一下noramaNode.geometry?.firstMaterial?.cullMode = .back
 
 2.如果你想两个面都进行渲染请使用panoramaNode.geometry?.firstMaterial?.isDoubleSided = true
 3.panoramaNode.geometry = SCNSphere(radius: 100) 半径不要设置太小
 
 6.第六步 创建一个2D游戏场景和一个播放视频的对象
 
 let url = Bundle.main.url(forResource: "fly", withExtension: "mp4")
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
