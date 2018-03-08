//
//  ViewController.m
//  ARKit-Learn21
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
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds options:@{SCNViewOptionPreferredRenderingAPI:@(true)}];
    scnView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scnView];
    
    //创建游戏场景
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
    //创建照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.png"];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    boxNode.position = SCNVector3Make(0, 0, -2);
    [scnView.scene.rootNode addChildNode:boxNode];
    
//    //滤镜1
//    CIFilter *filter1 = [CIFilter filterWithName:@"CIEdgeWork"];
//    boxNode.filters = @[filter1];
//    
//    //滤镜2
//    CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter2 setDefaults];
//    [filter2 setValue:@10 forKey:kCIInputRadiusKey];
//    boxNode.filters = @[filter2];
//  
//    //滤镜3
//    CIFilter *filter3 = [CIFilter filterWithName:@"CISepiaTone"];
//    [filter2 setDefaults];
//    [filter2 setValue:@0.8 forKey:kCIInputIntensityKey];
//    boxNode.filters = @[filter3];
//
//    //滤镜4
//    CIFilter *filter4 = [CIFilter filterWithName:@"CISepiaTone" withInputParameters:@{kCIInputIntensityKey: @5}];
//    boxNode.filters = @[filter4];
//    
//  
//    //滤镜5
//    CIFilter *filter5 = [CIFilter filterWithName:@"CIPixellate" withInputParameters:@{kCIInputIntensityKey: @10.0}];
//    boxNode.filters = @[filter5];
//
//    //滤镜6
//    CIFilter *filter6 = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
//    boxNode.filters = @[filter6];

    
    //滤镜属性是一个数组,那么必然可以组合使用
//    CIFilter *filter11 = [CIFilter filterWithName:@"CIPixellate" withInputParameters:@{kCIInputIntensityKey: @10.0}];
    //TODO:withParameters:@{kCIInputIntensityKey: @10.0}
    CIFilter *filter11 = [CIFilter filterWithName:@"CIPixellate"];

    CIFilter *filter22 = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
    boxNode.filters = @[filter11,filter22];
}


/*
 24-如何使用滤镜
 
 本节学习目标
 在SceneKit 游戏引擎中如何使用滤镜
 
 其实很简单的
 需要重点关注一个属性和一个类
 
 SCNNode的属性
 
 open var filters: [CIFilter]?
 
 CIFilter
 
 内置的核心图像滤镜处理,这个类可以创建很多滤镜效果,当然我们也可以自定义滤镜效果,关于这个类的详细使用情况请查阅苹果官方文档
 
 举个简单的例子告诉你怎么使用
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
 
 第六步 创建一个正方体
 
 let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
 box.firstMaterial?.diffuse.contents = "1.png"
 let boxNode = SCNNode(geometry: box)
 boxNode.position = SCNVector3Make(0, 0, -2)
 scene.rootNode.addChildNode(boxNode)
 
 可以添加一个环境光源如果不手动创建环境光,系统会自动创建一个环境光,注意一点,系统这个光源是没有办法获取的
 
 这个时候,你可以运行一下
 
 让学习成为一种习惯
 
 上面是基本的东西,相信所有跟着我的教程学习的所有伙伴都已经完全掌握了,那么我们接下来就演示一下如何对我们这个图片进行滤镜
 
 滤镜1
 
 let filter = CIFilter(name: "CIEdgeWork")!
 boxNode.filters = [filter]
 
 让学习成为一种习惯
 
 滤镜2
 
 let filter = CIFilter(name: "CIGaussianBlur")!
 filter.setDefaults()
 filter.setValue(10, forKey: kCIInputRadiusKey)
 boxNode.filters = [filter]
 
 让学习成为一种习惯
 
 滤镜3
 
 let filter = CIFilter(name: "CISepiaTone")!
 filter.setDefaults()
 filter.setValue(0.8, forKey: kCIInputIntensityKey)
 boxNode.filters = [filter]
 
 让学习成为一种习惯
 
 滤镜4
 
 let filter = CIFilter(name: "CISepiaTone",withInputParameters: [kCIInputIntensityKey: 5])!
 boxNode.filters = [filter]
 
 让学习成为一种习惯
 
 滤镜5
 
 let filter = CIFilter(name: "CIPixellate",
 withInputParameters: [kCIInputScaleKey: 10.0])!
 boxNode.filters = [filter]
 
 感谢一直关注我的朋友们,你们的认可,给了我前进的动力
 
 滤镜6
 
 let filter = CIFilter(name: "CIPhotoEffectProcess")!
 boxNode.filters = [filter]
 
 让学习成为一种习惯
 
 我们知道滤镜属性是一个数组,那么必然可以组合使用,我们下面演示一下
 
 let filter1 = CIFilter(name: "CIPixellate",
 withInputParameters: [kCIInputScaleKey: 10.0])!
 let filter2 = CIFilter(name: "CIPhotoEffectProcess")!
 boxNode.filters = [filter1,filter2]
 
 分享是一种快乐,点赞是一种美德
 
 偷偷的告诉你
 系统框架提供了很多滤镜效果,上面只是冰山一角,应该都满足大多数的滤镜效果,如果你真的需要自定义滤镜效果,那你可以使用 CIKernel,CISampler, CIFilterShape 他们 或者GLSL 进行自定义滤镜设计
 
 参考
 
 CIAdditionCompositing     //影像合成
 CIAffineTransform           //仿射变换
 CICheckerboardGenerator       //棋盘发生器
 CIColorBlendMode              //CIColor混合模式
 CIColorBurnBlendMode          //CIColor燃烧混合模式
 CIColorControls
 CIColorCube                   //立方体
 CIColorDodgeBlendMode         //CIColor避免混合模式
 CIColorInvert                 //CIColor反相
 CIColorMatrix                 //CIColor矩阵
 CIColorMonochrome             //黑白照
 CIConstantColorGenerator      //恒定颜色发生器
 CICrop                        //裁剪
 CIDarkenBlendMode             //亮度混合模式
 CIDifferenceBlendMode         //差分混合模式
 CIExclusionBlendMode          //互斥混合模式
 CIExposureAdjust              //曝光调节
 CIFalseColor                  //伪造颜色
 CIGammaAdjust                 //灰度系数调节
 CIGaussianGradient            //高斯梯度
 CIHardLightBlendMode          //强光混合模式
 CIHighlightShadowAdjust       //高亮阴影调节
 CIHueAdjust                   //饱和度调节
 CIHueBlendMode                //饱和度混合模式
 CILightenBlendMode
 CILinearGradient              //线性梯度
 CILuminosityBlendMode         //亮度混合模式
 CIMaximumCompositing          //最大合成
 CIMinimumCompositing          //最小合成
 CIMultiplyBlendMode           //多层混合模式
 CIMultiplyCompositing         //多层合成
 CIOverlayBlendMode            //覆盖叠加混合模式
 CIRadialGradient              //半径梯度
 CISaturationBlendMode         //饱和度混合模式
 CIScreenBlendMode             //全屏混合模式
 CISepiaTone                   //棕黑色调
 CISoftLightBlendMode          //弱光混合模式
 CISourceAtopCompositing
 CISourceInCompositing
 CISourceOutCompositing
 CISourceOverCompositing
 CIStraightenFilter            //拉直过滤器
 CIStripesGenerator            //条纹发生器
 CITemperatureAndTint          //色温
 CIToneCurve                   //色调曲线
 CIVibrance                    //振动
 CIVignette                    //印花
 CIWhitePointAdjust            //白平衡调节

 */

@end
