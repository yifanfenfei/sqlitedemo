//
//  myViewController.h
//  sqlitedemo
//
//  Created by sun jianfeng on 2/21/13.
//  Copyright (c) 2013 oo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myViewController : UIViewController
{
   IBOutlet UIImageView* myImageView;
    UIImage* image;
}
@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UIImage* image;
@end
