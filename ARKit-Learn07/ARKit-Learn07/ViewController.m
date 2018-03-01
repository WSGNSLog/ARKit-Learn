//
//  ViewController.m
//  ARKit-Learn07
//
//  Created by shiguang on 2018/2/28.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


/*

 8-SCNAction
 
 ####学习目标 1.了解SceneKit游戏框架中包含的行为动画种类
 2.掌握常用的行为动画
 
 都有哪些动画行为
 1.移动
 
 a.移动相对于当前位置
 
 + (SCNAction *)moveByX:(CGFloat)deltaX y:(CGFloat)deltaY z:(CGFloat)deltaZ duration:(NSTimeInterval)duration;
 + (SCNAction *)moveBy:(SCNVector3)delta duration:(NSTimeInterval)duration;
 
 b.移动到指定的位置
 
 + (SCNAction *)moveTo:(SCNVector3)location duration:(NSTimeInterval)duration;
 
 2旋转
 
 a.相对于当前位置旋转
 
 + (SCNAction *)rotateByX:(CGFloat)xAngle y:(CGFloat)yAngle z:(CGFloat)zAngle duration:(NSTimeInterval)duration;
 + (SCNAction *)rotateByAngle:(CGFloat)angle aroundAxis:(SCNVector3)axis duration:(NSTimeInterval)duration;
 
 b. 旋转到指定的位置
 
 + (SCNAction *)rotateToX:(CGFloat)xAngle y:(CGFloat)yAngle z:(CGFloat)zAngle duration:(NSTimeInterval)duration;
 + (SCNAction *)rotateToX:(CGFloat)xAngle y:(CGFloat)yAngle z:(CGFloat)zAngle duration:(NSTimeInterval)duration shortestUnitArc:(BOOL)shortestUnitArc;
 + (SCNAction *)rotateToAxisAngle:(SCNVector4)axisAngle duration:(NSTimeInterval)duration;
 
 3.缩放
 
 a.相对于当前的尺寸缩放
 
 + (SCNAction *)scaleBy:(CGFloat)scale duration:(NSTimeInterval)sec;
 
 b.缩放到指定的比例
 
 + (SCNAction *)scaleTo:(CGFloat)scale duration:(NSTimeInterval)sec;
 
 4.透明度
 
 a.透明度增加到1
 
 + (SCNAction *)fadeInWithDuration:(NSTimeInterval)sec;
 
 b.透明减小到0
 
 + (SCNAction *)fadeOutWithDuration:(NSTimeInterval)sec;
 
 c.透明度逐渐递增
 
 + (SCNAction *)fadeOpacityBy:(CGFloat)factor duration:(NSTimeInterval)sec;
 
 d.透明度逐渐递减
 
 + (SCNAction *)fadeOpacityTo:(CGFloat)opacity duration:(NSTimeInterval)sec;
 
 5.隐藏或不隐藏(让节点隐藏或者不隐藏)
 
 + (SCNAction *)hide NS_AVAILABLE(10_11, 9_0);
 + (SCNAction *)unhide NS_AVAILABLE(10_11, 9_0);
 
 6.等待
 
 a.等待指定时间
 
 + (SCNAction *)waitForDuration:(NSTimeInterval)sec;
 
 b.等待随机时间
 
 + (SCNAction *)waitForDuration:(NSTimeInterval)sec withRange:(NSTimeInterval)durationRange;
 
 7.从父节点移除子节点
 
 + (SCNAction *)removeFromParentNode;
 
 特殊函数介绍
 a.让行为相反
 
 - (SCNAction *)reversedAction;
 
 b.让行为永久执行
 
 + (SCNAction *)repeatActionForever:(SCNAction *)action;
 
 c.让行为执行N次
 
 + (SCNAction *)repeatAction:(SCNAction *)action count:(NSUInteger)count;
 
 d.把多个行为放在数组中一个一个执行
 
 + (SCNAction *)sequence:(NSArray<SCNAction *> *)actions;
 
 e.把多个行为进行捆绑 一次执行
 
 + (SCNAction *)group:(NSArray<SCNAction *> *)actions;
 
 f.执行代码块
 
 + (SCNAction *)runBlock:(void (^)(SCNNode *node))block;
 + (SCNAction *)runBlock:(void (^)(SCNNode *node))block queue:(dispatch_queue_t)queue;
 
 自定义动画介绍
 + (SCNAction *)customActionWithDuration:(NSTimeInterval)seconds actionBlock:(void (^)(SCNNode *node, CGFloat elapsedTime))block;
 
 javaScript动画函数介绍
 a.创建一个行为执行一个javaScript程序
 
 + (SCNAction *)javaScriptActionWithScript:(NSString *)script duration:(NSTimeInterval)seconds;
 
 在节点位置播放声音
 + (SCNAction *)playAudioSource:(SCNAudioSource *)source waitForCompletion:(BOOL)wait NS_AVAILABLE(10_11, 9_0);
 
 上面我们的游戏中动画行为基本已经介绍完毕,都很简单!
 
 程序员的最爱
 练习
 
 1.创建一个正方体
 2.让其不断自转
 3.让其在y轴方向不断的移动
 
 动画分解图
 
 第一步.创建工程
 
 学习很好玩
 
 第二步.添加游戏框架
 
 兴趣很重要
 
 第三步.添加SceneKit 专用显示视图SCNView
 
 SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView .backgroundColor = [UIColor blackColor];
 [self.view addSubview:scnView ];
 scnView.scene = [SCNScene scene];
 
 第四步.设置游戏场景
 
 scnView.scene = [SCNScene scene];
 
 第五步.添加照相机
 
 SCNCamera *camera = [SCNCamera camera];
 SCNNode *cameraNode =[SCNNode node];
 cameraNode.camera = camera;
 cameraNode.position = SCNVector3Make(0, 0, 50);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 第六步.添加正方体
 
 SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
 box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *boxNode =[SCNNode node];
 boxNode.position = SCNVector3Make(0, 0, 0);
 boxNode.geometry = box;
 [scnView .scene.rootNode addChildNode:boxNode];
 
 第七步.添加动画行为
 
 // 创建动画行为
 SCNAction *rotation = [SCNAction rotateByAngle:10 aroundAxis:SCNVector3Make(0, 1, 0) duration:2];
 SCNAction *moveUp = [SCNAction moveTo:SCNVector3Make(0, 15, 0) duration:1];
 SCNAction *moveDown = [SCNAction moveTo:SCNVector3Make(0, -15, 0) duration:1];
 // 顺序执行的动画
 SCNAction *sequence = [SCNAction sequence:@[moveUp,moveDown]];
 // 组合动画的执行
 SCNAction *group = [SCNAction group:@[sequence ,rotation]];
 [boxNode runAction:[SCNAction repeatActionForever:group]];
 
 执行效果:

*/
/*

 9-SCNGeometry
 学习目标
 1.了解SceneKit 游戏框架中系统包含的几何对象.
 2.学习如何将几何形状物体绑定的节点上,显示到视图中.
 
 ####系统提供的几何形状讲解
 
 正方体
 
 学习技术很好玩
 
 代码如下:
 
 SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
 box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *boxNode = [SCNNode node];
 boxNode.position = SCNVector3Make(0, 0, 0);
 boxNode.geometry = box;
 [scnView.scene.rootNode addChildNode:boxNode];
 
 创建平面
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNPlane *plane =[SCNPlane planeWithWidth:2 height:2];
 plane.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.PNG"];
 SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
 planeNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:planeNode];
 
 金子塔
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNPyramid *pyramid = [SCNPyramid pyramidWithWidth:1 height:1 length:1];
 pyramid.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *pyramidNode = [SCNNode nodeWithGeometry:pyramid];
 pyramidNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:pyramidNode];
 
 球体
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNSphere *sphere = [SCNSphere sphereWithRadius:1];
 sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *sphereNode =[SCNNode nodeWithGeometry:sphere];
 sphereNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:sphereNode];
 
 圆柱体
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:1 height:2];
 cylinder.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *cylinderNode =[SCNNode nodeWithGeometry:cylinder];
 cylinderNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:cylinderNode];
 
 圆锥体
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNCone *cone = [SCNCone coneWithTopRadius:0 bottomRadius:1 height:1];
 cone.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *coneNode = [SCNNode nodeWithGeometry:cone];
 coneNode.position = SCNVector3Make(0,0, 0);
 [scnView.scene.rootNode addChildNode:coneNode];
 
 管道
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNTube *tube = [SCNTube tubeWithInnerRadius:1 outerRadius:1.2 height:2];
 tube.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *tubeNode =[SCNNode nodeWithGeometry:tube];
 tubeNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:tubeNode];
 
 环面
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNTorus *torus = [SCNTorus torusWithRingRadius:1 pipeRadius:0.5];
 torus.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *torusNode = [SCNNode nodeWithGeometry:torus];
 torusNode.position = SCNVector3Make(0, 0, 0);
 [scnView.scene.rootNode addChildNode:torusNode];
 
 地板
 
 让学习成为一种习惯
 
 代码如下:
 
 SCNFloor *floor = [SCNFloor floor];
 floor.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *floorNode = [SCNNode nodeWithGeometry:floor];
 floorNode.position = SCNVector3Make(0, -5, 0);
 [scnView.scene.rootNode addChildNode:floorNode];
 
 立体文字
 
 6CD7CE98-3CCE-41EA-A9AE-1C60F96EB2ED.png
 
 代码如下:
 
 SCNText *text = [SCNText textWithString:@"好好学习" extrusionDepth:0.5];
 text.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 text.font = [UIFont systemFontOfSize:1];
 SCNNode *textNode  =[SCNNode nodeWithGeometry:text];
 textNode.position = SCNVector3Make(-2, 0, 0);
 [scnView.scene.rootNode addChildNode:textNode];
 
 自定义形状
 
 让学习成为一种习惯
 
 代码如下:
 
 // 定义贝塞尔曲线
 SCNShape *shape = [SCNShape shapeWithPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 1, 1) cornerRadius:0.5] extrusionDepth:3];
 shape.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *shapdeNode =[SCNNode nodeWithGeometry:shape];
 [scnView.scene.rootNode addChildNode:shapdeNode];
 
 手把手教你写代码
 第一步.创建工程 44D42F5C-F2E7-42D6-9AB4-95CE6E828DC6.png
 
 第二步.添加游戏框架
 
 2BB5667B-BFDC-425A-B08D-11041BAAD552.png
 
 第三步.添加游戏专用视图SCNView
 
 SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView.backgroundColor = [UIColor blackColor];
 [self.view addSubview:scnView];
 scnView.allowsCameraControl = TRUE;
 
 第四步.创建游戏场景
 
 scnView.scene = [SCNScene scene];
 
 第五步.添加照相机
 
 SCNNode *cameraNode =[SCNNode node];
 cameraNode.camera = [SCNCamera camera];
 cameraNode.position = SCNVector3Make(0, 0, 5);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 第六步.添加节点并且绑定几何形状物体
 
 // 创建几何对象
 SCNTorus *torus = [SCNTorus torusWithRingRadius:1 pipeRadius:0.5];
 torus.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 // 绑定到节点上
 SCNNode *torusNode = [SCNNode nodeWithGeometry:torus];
 // 设置节点的位置
 torusNode.position = SCNVector3Make(0, 0, 0);
 // 添加到场景中去
 [scnView.scene.rootNode addChildNode:torusNode];
 
 运行结果:
 
 让学习成为一种习惯
 
 问题:有人问我SegmentCount属性到底干了什么事情?
 
 下面举个例子演示
 
 创建一个有切面的正方体
 
 let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.5)
 
 C292CF35-988D-408B-80C3-1A7744D1E09A.png
 
 设置一下下面属性
 
 box.chamferSegmentCount = 20
 
 2BFF5AB8-815C-48CD-885D-38F5BE0B96E5.png

 */

@end
