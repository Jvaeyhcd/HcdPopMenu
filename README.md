HcdPopMenu
------
![License](https://img.shields.io/cocoapods/l/HcdPopMenu.svg)
![Platform](https://img.shields.io/cocoapods/p/HcdPopMenu.svg)

![图片](https://raw.githubusercontent.com/Jvaeyhcd/HcdPopMenu/master/screen.gif)

### Requirements
* Xcode 6 or higher
* iOS 7.0 or higher
* ARC

### Installation
#### Manual Install

All you need to do is drop `HcdPopMenu` files into your project, and add `#include "HcdPopMenu.h"` to the top of classes that will use it.

#### Cocoapods

Change to the directory of your Xcode project:
``` bash
$ cd /path/to/YourProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add HcdPopMenu:
``` bash
pod 'HcdPopMenu'
```
Install into your Xcode project:
``` bash
$ pod install
```
Open your project in Xcode from the .xcworkspace file (not the usual project file)
``` bash
$ open YourProject.xcworkspace
```

> Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Before you `pod install`, you should run `pod setup`.

### Example Usage

``` objc
NSArray *array = @[@{kHcdPopMenuItemAttributeTitle : @"海量投单", kHcdPopMenuItemAttributeIconImageName : @"toudan_icon_hailiangtoudan"},
                              @{kHcdPopMenuItemAttributeTitle : @"定向投单", kHcdPopMenuItemAttributeIconImageName : @"toudan_icon_dingxiangtoudan"}];

[HcdPopMenuView createPopmenuItems:array closeImageName: @"center_exit" backgroundImageUrl:@"http://img3.duitang.com/uploads/item/201411/17/20141117102333_rwHMH.thumb.700_0.jpeg" tipStr:@"海量投单是所有人都可以看到的投单，定向投单则是针对有目的性的投单（如企业投单）" completionBlock:^(NSInteger index) {

}];
```
### SpecialThanks
https://github.com/MLGZ/PopMenu
