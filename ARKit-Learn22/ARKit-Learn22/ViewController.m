//
//  ViewController.m
//  ARKit-Learn22
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
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scnView];
    
    //创建游戏场景
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
    //创建照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    //创建一个环境光
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    
    //创建一个文字节点
    SCNText *text = [SCNText textWithString:@"好好学习" extrusionDepth:1];
    text.font = [UIFont systemFontOfSize:1];
    SCNNode *textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-2, -0.5, -2);
    [scene.rootNode addChildNode:textNode];
    
    
    //创建三个事件
    // 开始事件
    SCNAnimationEvent *startEvt = [SCNAnimationEvent animationEventWithKeyTime:0 block:^(id<SCNAnimation>  _Nonnull animation, id  _Nonnull animatedObject, BOOL playingBackward) {
        SCNNode *node = [SCNNode node];
        node.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
    }];
    //中间事件
    SCNAnimationEvent *midEvt = [SCNAnimationEvent animationEventWithKeyTime:0.5 block:^(id<SCNAnimation>  _Nonnull animation, id  _Nonnull animatedObject, BOOL playingBackward) {
        SCNNode *node = [SCNNode node];
        node.geometry.firstMaterial.diffuse.contents = [UIColor purpleColor];
        NSLog(@"==:%d",playingBackward);
    }];
    //结束事件
    SCNAnimationEvent *endEvt = [SCNAnimationEvent animationEventWithKeyTime:1 block:^(id<SCNAnimation>  _Nonnull animation, id  _Nonnull animatedObject, BOOL playingBackward) {
        SCNNode *node = [SCNNode node];
        node.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.z"];
    animation.duration = 5;
    animation.fromValue = @20;
    animation.toValue = @-20;
    animation.additive = YES;
    animation.autoreverses = YES;
    animation.animationEvents = @[startEvt,midEvt,endEvt];
    animation.repeatCount = floorf(INT64_MAX);
    [textNode addAnimation:animation forKey:nil];
}
/*

 25-SCNAnimationEvent
 
 官方解释
 用于在动画播放过程中的特定时间执行的闭包的容器(关键字特定时间\闭包)
 
 用法案例
 
 1.移动或者移除节点时,播放声音
 2.播放动画时,让隐藏的几何模型显示出来
 
 可能还有很多的使用案例需要我们去不断发现,SceneKit 提供给我们的选择有很多种,实际开发中,根据需求的不同再去做抉择。
 
 下面就举个简单的案例讲解一下用法
 第一步 创建工程(略)
 第二步 导入框架SceneKit
 第三步 创建游戏专用视图
 let scnView = SCNView(frame: self.view.bounds, options: [SCNView.Option.preferredRenderingAPI.rawValue:true])
 scnView.backgroundColor = UIColor.black
 self.view.addSubview(scnView)
 
 第四步 创建游戏场景
 let scene = SCNScene()
 scnView.scene = scene
 
 第五步 创建照相机
 let cameraNode = SCNNode()
 cameraNode.camera = SCNCamera()
 scene.rootNode.addChildNode(cameraNode)
 
 第六步 创建一个环境光
 let ambientLightNode = SCNNode()
 ambientLightNode.light = SCNLight()
 ambientLightNode.light?.type = .ambient
 scene.rootNode.addChildNode(ambientLightNode)
 
 第七步 创建一个文字节点
 let text = SCNText(string: "酷走天涯", extrusionDepth: 1)
 text.font = UIFont.systemFont(ofSize: 1)
 let textNode = SCNNode(geometry: text)
 textNode.position = SCNVector3Make(-2, -0.5, -2)
 scene.rootNode.addChildNode(textNode)
 
 准备工作完成
 
 下面就是我们今天要将的内容了
 
 先来认识一下 我们今天最重要的一个初始化方法
 
 public convenience init(keyTime time: CGFloat, block eventBlock: SceneKit.SCNAnimationEventBlock)
 public typealias SCNAnimationEventBlock = (CAAnimation, Any, Bool)
 
 解释一下：
 
 1.time 这个参数你必须注意了,特别重要,它的取值范围[0-1] ,你可能要问为什么,这个时间参数是一个相对时间,不管你动画时间多长,这个动画时间需要传的参数,就只能是这个范围的值
 2.SCNAnimationEventBlock 回调事件的参数,你会发现没有说明,官方也没有具体给出说明,不过我们有调试工具,日志输出一下,就知道了,看文章的你幸运了我现在就告诉你参数是什么一下,第一个参数CAAnimation 类型,就是我们创建的动画,第二个参数any 当动画添加到节点上,那这个就是节点对象,第三个参数 动画是否回退执行
 
 重点内容来了,我们做一个颜色变化的事件,当动画开始执行是,我们的文字颜色为红色,动画指定一般颜色为紫色,动画执行完整时,颜色为绿色,我们重复这个行为
 
 创建三个事件
 // 开始事件
 let startEvt = SCNAnimationEvent(keyTime: 0) { (animation, animatedObject, playingBackward) in
 let node = animatedObject as? SCNNode
 node?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
 
 
 }
 // 中间事件
 let midEvt = SCNAnimationEvent(keyTime: 0.5) { (animation, animatedObject, playingBackward) in
 let node = animatedObject as? SCNNode
 node?.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
 print(playingBackward)
 
 }
 
 // 结束事件
 let endEvt = SCNAnimationEvent(keyTime: 1) { (animation, animatedObject, playingBackward) in
 let node = animatedObject as? SCNNode
 node?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
 }
 
 创建一个动画对象把三个事件添加进去
 let animation = CABasicAnimation(keyPath: "position.z")
 animation.duration = 5
 animation.fromValue = 0
 animation.toValue = -20
 animation.isAdditive = true
 animation.autoreverses = true
 animation.animationEvents = [startEvt,midEvt,endEvt]
 animation.repeatCount = Float(Int64.max)
 textNode.addAnimation(animation, forKey: nil)
 
 运行一下
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
