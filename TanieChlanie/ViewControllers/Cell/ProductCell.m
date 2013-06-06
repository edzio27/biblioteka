//
//  ProductCell.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ProductCell.h"
#import "AppDelegate.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.backgroundView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 55)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
        self.titleLabel.font = [UIFont fontWithName:@"Curier-Bold" size:13];
        self.titleLabel.numberOfLines = 3;
        [self addSubview:self.titleLabel];
        
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 , 260, 30)];
        self.authorLabel.backgroundColor = [UIColor clearColor];
        self.authorLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
        self.authorLabel.textColor = RED_COLOR;
        self.authorLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.authorLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 55, 40, 25)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = RED_COLOR;
        self.dateLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:15];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
