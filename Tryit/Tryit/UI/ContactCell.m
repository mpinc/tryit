//
//  ContactCell.m
//  Tryit
//
//  Created by Mars on 3/5/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

@property (strong, nonatomic) TIContact *ticontact;

@end

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContact:(TIContact*) contact
{
    self.ticontact = contact;

    self.contactNameLabel.text = contact.contactName;
    self.emailAddressLabel.text = contact.email;
    [self.headImageView setImage:contact.image];
    [self.selectSwitch setOn:contact.isSelected];

}

- (IBAction)switchChange:(id)sender {

    UISwitch *switchButton = (UISwitch *) sender;
    [self.ticontact setIsSelected:switchButton.isOn];

}

@end
