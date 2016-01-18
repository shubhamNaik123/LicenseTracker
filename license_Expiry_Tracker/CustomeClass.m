//
//  CustomeClass.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 15/01/16.
//  Copyright © 2016 SJI. All rights reserved.
//

#import "CustomeClass.h"

@implementation CustomeClass

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(8,18,102,65);
    self.imageView.frame = CGRectMake(8,18,102,65);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
@end
