//
//  ViewController.m
//  CIFilter
//
//  Created by 朱明科 on 16/4/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISlider *gammaSlider;
@property (weak, nonatomic) IBOutlet UISlider *expoSlider;
@property(nonatomic)CIFilter *hueFilter;//色相
@property(nonatomic)CIFilter *gammaFilter;//饱和度
@property(nonatomic)CIFilter *expoFilter;//亮度
@property(nonatomic)CIContext *context;
@property(nonatomic)CIImage *ciImage;
@property(nonatomic)UIImage *tmpImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCIFilter];
}
-(void)initCIFilter{
    self.context = [CIContext contextWithOptions:nil];
    self.ciImage = [self CIImageWithData:_showImageView.image];
    
    self.hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];//色相
    [_hueFilter setDefaults];
    self.gammaFilter = [CIFilter filterWithName:@"CIGammaAdjust"];//饱和度
    [_gammaFilter setDefaults];
    self.expoFilter = [CIFilter filterWithName:@"CIExposureAdjust"];//亮度
    [_expoFilter setDefaults];
    
    [_hueSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [_gammaSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [_expoSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)hueSliderChange:(UISlider *)sender {
    float slideValue = sender.value;
    // 设置过滤器参数
    [_hueFilter setValue:_ciImage forKey:@"inputImage"];
    [_hueFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_hueFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_showImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
- (IBAction)gammaSliderChange:(UISlider *)sender {
    float slideValue = sender.value;
    [_gammaFilter setValue:_ciImage forKey:@"inputImage"];
    [_gammaFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputPower"];
    
    CIImage *outputImage = [_gammaFilter outputImage];
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    [_showImageView setImage:newImg];
    CGImageRelease(cgimg);
}
- (IBAction)expoSliderChange:(UISlider *)sender {
    float slideValue = sender.value;
    [_expoFilter setValue:_ciImage forKey:kCIInputImageKey];
    [_expoFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputEV"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_expoFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_showImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
-(void)endChange{
    self.context = [CIContext contextWithOptions:nil];
    self.ciImage = [self CIImageWithData:_tmpImage];
}
-(CIImage *)CIImageWithData:(UIImage *)dataImage{
    UIImage *img = dataImage;
    NSData *data = UIImagePNGRepresentation(img);
    CIImage *cimg = [CIImage imageWithData:data];
    return cimg;
}
- (IBAction)returnBtn:(id)sender {
    self.context = [CIContext contextWithOptions:nil];
    self.ciImage = [self CIImageWithData:[UIImage imageNamed:@"screen.png"]];
    self.showImageView.image = [UIImage imageNamed:@"screen.png"];
    self.hueSlider.value = 0;
    self.gammaSlider.value = 0;
    self.expoSlider.value = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
