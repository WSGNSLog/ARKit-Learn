//
//  ViewController.m
//  ARKit-Learn24
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏专用视图
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds options:nil];
    scnView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:scnView];
    scnView.allowsCameraControl = true;
    
    //创建游戏场景
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
    //创建天空盒子
    scene.background.contents = @"skybox01_cube.png";
    
    //添加照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    
    [scnView.scene.rootNode addChildNode:cameraNode];
}


/*

 27-天空盒子
 
 代码实现过程
 第一步 找素材
 
 第二步 创建工程(略)
 第三步 导入框架SceneKit
 第四步 创建游戏专用视图
 let scnView = SCNView(frame: self.view.bounds, options: [SCNView.Option.preferredRenderingAPI.rawValue:true])
 scnView.backgroundColor = UIColor.black
 self.view.addSubview(scnView)
 scnView.allowsCameraControl = true
 
 第五步 创建游戏场景
 let scene = SCNScene()
 scnView.scene = scene
 
 第六步 创建天空盒子
 scene.background.contents = "skybox01_cube.png"
 
 第七步 添加照相机(必须要的)
 let cameraNode = SCNNode()
 cameraNode.camera = SCNCamera()
 scene.rootNode.addChildNode(cameraNode)
 
 运行效果:
 
 */

@end
