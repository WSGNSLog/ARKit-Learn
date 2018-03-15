//
//  ViewController.m
//  ARKit-Learn27
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SCNView *scnView;
@property (nonatomic,strong) SCNScene *scene;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scnView.backgroundColor = [UIColor lightGrayColor];
    
    // 创建一个3D场景
    self.scene = [SCNScene scene];
    self.scnView.scene = self.scene;
    //创建一个球体 然后将其添加到场景中去
    
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = [SCNSphere sphereWithRadius:10];
    sphereNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2);
    [self.scene.rootNode addChildNode:sphereNode];
    
    //我们知道现在球体是有了,但是我们还需要一个眼睛去观察球体,在全景下,眼睛是根据重力感应,来调节观察的角度,所以我们下面创建一个眼睛节点,然后将其放入场景的中心点
    SCNNode *eyeNode = [SCNNode node];
    eyeNode = [SCNNode node];
    eyeNode.camera = [SCNCamera camera]; // 创建照相机对象 就是眼睛
    eyeNode.camera.automaticallyAdjustsZRange = true; // 自动添加可视距离
//    eyeNode.camera.xFov = 30;
//    eyeNode.camera.yFov = 30;
//    eyeNode.camera.focalBlurRadius = 0;
    eyeNode.camera.focalLength = 30;
    eyeNode.camera.focusDistance = 30;
    eyeNode.camera.fStop = 0;
    [self.scene.rootNode addChildNode:eyeNode];
    
    sphereNode.geometry.firstMaterial.cullMode = SCNCullModeFront;// 设置剔除外表面
    sphereNode.geometry.firstMaterial.doubleSided = false; // 设置只渲染一个表面
}

/*
 30-写一个全景+VR的播放器
 功能
 一般vr+全景播放器有一下几个功能
 
 全景模式+VR 共有的功能
 1.手势滑动
 2.重力感应
 3.恢复视角
 4.播放/暂停
 5.上一曲
 6.下一曲
 7.手势滑动
 8.单击手势 隐藏功能菜单
 9.是否可以播放(不可播放出现小菊花)
 10.声音加/减功能
 11.捏合手势-缩放画面
 
 VR 模式 特有的头控功能
 1.显示/隐藏菜单功能
 2.播放/暂停功能
 3.上一曲功能
 4.下一曲功能
 5.声音加/减功能
 
 扩展功能
 1.视频滤镜
 
 ####实现方案选择
 
 近两年随着AR/VR逐渐火热,企业为了给自己的产品中加入新的元素,有可能会将3D元素添加到应用中去,对于IOS 工程师,你有三种选择 OpenGL ES / Metal/SceneKit ,按照性能排名 Metal 第一位,SceneKit性能相对来说没有前两者高,但是对于开发难度来说,SceneKit的难度最低,因为他是面向对象的,对于iOS 开发者,学习成本是最低的。
 
 需要的知识
 了解AVPlayer 对象的用法
 了解 CMMotionManager 对象的用法
 SCNNode 的用法 (SceneKit框架)
 SCNScene的用法(SceneKit框架)
 SCNGeometry的用法(SceneKit框架)
 SCNCamera的用法(SceneKit框架)
 UIGestureRecognizer
 CIFilter 处理视频滤镜(可选项)
 掌握以上知识点 轻松完成播放器的全部需求
 
 后面我会分为以下几个模块进行讲解
 
 a. 如何创建一个渲染全景视频的球体
 b. 如何创建将APlayer 加载的视频渲染到球体上
 c. 如何实现通过手势移动来调节呈现出来的画面位置
 d. 捏合手势如何缩放画面
 f. 头控部分布局
 g. 如何检测头控按钮被选中
 h. 如何实现悬停动画
 i. 如何实现分屏显示
 

 */
/*
 31-如何创建一个渲染全景视频的球体
 
 实现步骤:
 第一步 创建一个应用工程(略了)
 第二步 创建一个渲染视图 继承SCNView DFA47D5C-AE21-4A3A-8E53-858CBA60B647.png
 
 第三步 导入框架SceneKit
 
 #import<SceneKit/SceneKit.h>
 
 第四步 创建一个3D场景
 
 self.scene = [SCNScene scene];
 
 第五步 创建一个球体 然后将其添加到场景中去
 
 SCNNode *sphereNode = [SCNNode node];
 sphereNode.geometry = [SCNSphere sphereWithRadius:SHPERE_RADIUS];
 sphereNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2);
 [self.scene.rootNode addChildNode:sphereNode];
 
 第六步 我们知道现在球体是有了,但是我们还需要一个眼睛去观察球体,在全景下,眼睛是根据重力感应,来调节观察的角度,所以我们下面创建一个眼睛节点,然后将其放入场景的中心点
 
 SCNNode *eyeNode = [SCNNode node];
 eyeNode = [SCNNode node];
 eyeNode.camera = [SCNCamera camera]; // 创建照相机对象 就是眼睛
 eyeNode.camera.automaticallyAdjustsZRange = true; // 自动添加可视距离
 eyeNode.camera.xFov = CAMERA_FOX;
 eyeNode.camera.yFov =CAMERA_HEIGHT;
 eyeNode.camera.focalBlurRadius = 0;
 
 
 思考问题1:
 
 球体有两个表面 一个外表面一个内表面,在vr 模式下,我们的眼睛是在球体中间的,如何让球体只渲染内表面?
 
 sphereNode.geometry.firstMaterial.cullMode = SCNCullModeFront;// 设置剔除外表面
 sphereNode.geometry.firstMaterial.doubleSided = false; // 设置只渲染一个表面
 
 思考问题2:
 
 球体的半径设置多大?
 
 不要设置太小即可,我设置的是10 注意这里没有单位,根据屏幕的宽度和高度进行相对运算,屏幕上边为1 下边为-1 左边为 -1 右边为 1 根据照相机的视角就可以计算出几何模型在视图中的呈现的画面大小了
 
 */

@end
