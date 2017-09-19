# LFBFanView
这个一个扇形动态加载图，用来表示你当前的信息所在总信息的比例，欢迎各位在项目中使用，如果有什么不好的体验可以反馈给我，我会在第一时间加以修改
## 安装方法

   在项目中使用LFBFanView类，仅仅只需要将LFBFanView文件夹拖入项目中就可以了

## 效果展示

 ![](https://github.com/LiuFuBo1991/LFBFanView/raw/master/gif/fangit.gif)

## 属性

@property (nonatomic, assign) CGFloat percent;<br>
有效运动百分比，在你项目中可能叫其他名字，它表示的完成进度所在百分比<br>
@property (nonatomic, assign) NSInteger barCount;<br>
当前扇形所包含bar的条数，一般情况下不建议自己设置<br>
@property (nonatomic, strong) UIColor *normalColor;<br>
低层扇形条的颜色，用户可自行设置<br>
@property (nonatomic, strong) UIColor *hightlightColor;<br>
代表完成进度的扇形条颜色，用户可自行设置<br>
@property (nonatomic, strong) UIColor *fanColors;<br>
整个扇形的背景颜色，系统默认颜色为橘黄色，可以自己设置<br>
@property (nonatomic, assign) CGFloat energyPercent;<br>
电量所在百分比，该百分比是指当前设备电量所占百分比，如果有其他需求的用户可以自行修改我的源码以适应自己的需求<br>

## Release Notes

 Version 1.0.0

 完成了基本功能编写，用户可以设置的属性都放置在.h文件中，

 Version 1.0.1

 将之前用户可以设置的属性放到LFBFanView.h文件中，并通过model的形式来设置参数，这样用户不用担心参数设置顺序问题。
