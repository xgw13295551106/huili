//
//  LCStatusProgressView.m
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/30.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "LCStatusProgressView.h"

#define space 25  ///< 距离屏幕两侧的距离
#define item_w 28.5   ///< item的宽
#define item_h item_w   ///< item的高
#define itemSpace (win_width-2*15 - 2*space - 4*item_w)/3  ///< item之间的间距
#define itemLine_w itemSpace -2*5 ///< 计算方式：两个item中心之间的距离


@interface LCStatusProgressView (){
    CGFloat self_width;
    CGFloat self_height;
}

@property (nonatomic,strong)NSArray *itemsArray;

@property (nonatomic,strong)UIImage *selectImage;

@property (nonatomic,strong)UIImage *unSelectImage;

@property (nonatomic,strong)UIColor *selectColor;

@property (nonatomic,strong)UIColor *unSelectColor;


@end

@implementation LCStatusProgressView

static int keyTag = 400;  ///< 上面label初始tag
static int valueTag = 500;  ///< 下面label初始label
static int itemTag = 600;  ///< item的初始tag
static int lineTag = 800;  ///< line的初始tag

+ (instancetype)getStatusProgressView:(CGRect)frame andItems:(NSArray<NSDictionary *> *)items andSelectImage:(UIImage *)selectImage andUnSelectImage:(UIImage *)unSelectImage andSelectColor:(UIColor *)selectColor andUnSelectColor:(UIColor *)unSelectColor{
    return [[LCStatusProgressView alloc]initWithFrame:frame andItems:items andSelectImage:selectImage andUnSelectImage:unSelectImage andSelectColor:selectColor andUnSelectColor:unSelectColor];
}


- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray<NSDictionary *> *)items andSelectImage:(UIImage *)selectImage andUnSelectImage:(UIImage *)unSelectImage andSelectColor:(UIColor *)selectColor andUnSelectColor:(UIColor *)unSelectColor{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        self.itemsArray = items;
        self.selectImage = selectImage;
        self.unSelectImage = unSelectImage;
        self.selectColor = selectColor;
        self.unSelectColor = unSelectColor;
        //开始布局
        [self setUpControls:frame];
    }
    return self;
}

- (void)setUpControls:(CGRect)frame{
    [self setBackgroundColor:[UIColor whiteColor]];
    for (int i =0; i<self.itemsArray.count; i++) {
        //item
        NSDictionary *dic = self.itemsArray[i];
        CGFloat item_x = space + i*(item_w + itemSpace);
        CGFloat item_y = self_height/2 - item_h/2 - 15;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(item_x, item_y, item_w, item_h)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:self.unSelectImage];
        imageView.tag = itemTag + i;
        [self addSubview:imageView];
        
        if (i<self.itemsArray.count-1) {
            //横线
            CGFloat line_x = imageView.maxX+5;
            CGFloat line_h = 5;
            CGFloat line_y = imageView.center.y - line_h/2;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(line_x, line_y, itemLine_w, line_h)];
            [lineView setBackgroundColor:self.unSelectColor];
            lineView.tag = lineTag+i;
            [self insertSubview:lineView belowSubview:imageView];
        }
        //上方label
        UILabel *keyLabel = [[UILabel alloc]init];
        keyLabel.font = [UIFont systemFontOfSize:12];
        keyLabel.textColor = self.unSelectColor;
        keyLabel.text = dic.allKeys.firstObject;
        keyLabel.tag = keyTag +i;
        [keyLabel sizeToFit];
        keyLabel.center = CGPointMake(imageView.center.x, imageView.origin.y-3-keyLabel.size.height/2);
        [self addSubview:keyLabel];
        
        //下方label
        UILabel *valueLabel = [[UILabel alloc]init];
        valueLabel.text = dic.allValues.firstObject;
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textColor = [UIColor colorWithHexString:@"C0C1C0"];
        [valueLabel sizeToFit];
        valueLabel.tag = valueTag +i;
        valueLabel.center = CGPointMake(imageView.center.x, CGRectGetMaxY(imageView.frame)+3+valueLabel.size.height/2);
        [self addSubview:valueLabel];
        
    }
    self.height = self.height-15;//这里是针对本项目进行的特殊处理
}
//通过下标赋值
- (void)setSelectIndex:(int)selectIndex{
    _selectIndex = selectIndex;
    if (selectIndex > self.itemsArray.count) {
        selectIndex = (int)self.itemsArray.count;
    }
    if (selectIndex <= 0) {
        selectIndex = 0;
        return;
    }
    for (int i = 0; i<selectIndex; i++) {
        UIImageView *imageView = [self viewWithTag:i+itemTag];
        [imageView setImage:self.selectImage];
        UILabel *keyLabel = [self viewWithTag:i+keyTag];
        keyLabel.textColor = self.selectColor;
        UILabel *valueLabel = [self viewWithTag:valueTag +i];
        valueLabel.textColor = self.selectColor;
        if (i<selectIndex-1) {
            UIView *lineView = [self viewWithTag:i+lineTag];
            [lineView setBackgroundColor:self.selectColor];
        }
    }
    
}

@end
