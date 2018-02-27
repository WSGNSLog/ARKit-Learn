//
//  ViewController.m
//  ARKit-Learn02
//
//  Created by shiguang on 2018/2/27.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScnView];
}
- (void)setupScnView{
    
    //创建游戏视图
    SCNView *scnview = [[SCNView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scnview];
    scnview.backgroundColor = [UIColor lightGrayColor];
    //创建场景
    SCNScene *scene = [[SCNScene alloc]init];
    scnview.scene = scene;
    //创建一个正方体的几何模型
    SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
    
    //创建一个节点，将几何模型绑定到这个节点上去
    SCNNode *node = [[SCNNode alloc]init];
    node.geometry = box;
    
    //将添加了几何模型的节点绑定到场景的跟节点上去
    [scnview.scene.rootNode addChildNode:node];
    //允许操作摄像机
    scnview.allowsCameraControl = true;
    //开启抗锯齿  如果模型出现有锯齿状的现象 你就可以使用这个属性让锯齿减弱,提过渲染性能,但是这个可能会消耗更多的手机资源,使用时还是谨慎为好。
    scnview.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    
    
//    //如何给游戏截屏?
//    UIImage *image =  [scnview snapshot];
//    //如何设置游戏的帧率?
//    scnview.preferredFramesPerSecond = 30
//    //如何打开统计菜单? 打开这个功能就能查看游戏场景的元素数量等信息
//    scnview.showsStatistics = true;
    
}
/*

 3-SCNView
 
 本节的主要内容
 
 SCNView 是什么?
 主要有哪些功能?
 怎么使用SCNView?
 介绍
 
 SCNView 主要负责显示3D 模型对象的视图,继承自UIView,能够直接添加到UIView类型的视图上,很简单就一句话！我们就围绕这句话开始展开,渲染过程中我们可能遇到哪些问题呢？锯齿,这个是最常见的,游戏中的模型是由多边形组成的,当然显卡运算频率很高，显存足够大的情况，可以生成的“多边形”就很多，这样锯齿就会少,当画面增大,解析度增高后,多边形就会变少,锯齿就会明显。那么这个时候,我们可以通过设置抗锯齿属性进行适当的调节,不过锯齿越少,游戏性能越差,因为它需要进行大量的运算,所以大家在使用的时候需要特别注意。
 
 功能
 
 设置游戏运行时的帧率
 截屏
 开始和暂停游戏
 抗锯齿
 控制摄像机
 显示统计菜单
 执行渲染方式(OpenGL /Metal)
 代码详解
 
 Step 1
 
 导入框架 import SceneKit
 
 Step 2
 
 func setup(){
 ///  第一步 创建游戏视图
 let scnview = SCNView(frame: self.view.bounds)
 self.view.addSubview(scnview)
 scnview.backgroundColor = UIColor.black
 ///  第二步 创建场景 ,注意scnview 默认是没有scene 所以我们必须给我们的游戏视图设置一个场景
 
 let scene = SCNScene()
 scnview.scene = scene;
 
 /// 第三步 创建一个正方体的几何模型
 
 let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
 box.firstMaterial?.diffuse.contents = “1.png”
 
 /// 第四步 创建一个节点,将几何模型绑定到这个节点上去
 
 let boxNode = SCNNode()
 boxNode.geometry = box
 
 /// 第五步 将绑定了几何模型的节点添加到场景的跟节点上去
 
 scene.rootNode.addChildNode(boxNode)
 
 /// 第六步 运行操作摄像机,开启了这个功能,你就可以使用手势改变场景中摄像机的位置和方向了
 
 scnview.allowsCameraControl = true;
 
 /// 第七步 开启抗锯齿  如果模型出现有锯齿状的现象 你就可以使用这个属性让锯齿减弱,提过渲染性能,但是这个可能会消耗更多的手机资源,使用时还是谨慎为好。
 
 scnview.antialiasingMode = .multisampling4X
 
 }
 
 下面介绍一下几个功能的使用
 
 如何给游戏截屏?
 
 let image =  scnview.snapshot()
 
 如何设置游戏的帧率?
 
 scnview.preferredFramesPerSecond = 30
 
 如何打开统计菜单? 打开这个功能就能查看游戏场景的元素数量等信息
 
 scnView.showsStatistics = true;
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
