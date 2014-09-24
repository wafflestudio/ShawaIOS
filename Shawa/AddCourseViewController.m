//
//  AddCourseViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AddCourseViewController.h"

@interface AddCourseViewController (){
    CGPoint originCenter;
}
@end

@implementation AddCourseViewController

@synthesize delegate;
@synthesize saveBarButtonItem, cancelBarButtonItem;
@synthesize monButton, tueButton, wedButton, thuButton, friButton, satButton, sunButton;
@synthesize startTimeButton, endTimeButton;
@synthesize courseNameTextField, courseLocationTextField;
@synthesize course, isNewCourse;

- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonClicked:(id)sender{
    if([self verifyCourse] == NO){
        return;
    }
    
    [self setCourseWithIBOutlets:course];
    
    if(self.isNewCourse){
        [self.delegate addNewCourse:course];
    }else{
        [self.delegate updateCourse:course];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)verifyCourse{
    if(!(monButton.selected || tueButton.selected || wedButton.selected || thuButton.selected || friButton.selected || satButton.selected || sunButton.selected)){
        return NO;
    }
    if([courseNameTextField.text isEqual:@""] || courseNameTextField.text == nil){
        return NO;
    }
    NSString * startTime = [startTimeButton titleForState:UIControlStateNormal];
    NSString * endTime = [startTimeButton titleForState:UIControlStateNormal];
    
    /*
    if([ (startTime = [startTime substringToIndex:3]) isEqualToString:@"오후"]){
        if([ (endTime = [endTime substringToIndex:3]) isEqualToString:@"오전"]){
            return NO;
        }
    }
    */
    if([startTime compare:endTime]){
        return NO;
    }
    if([[startTimeButton titleForState:UIControlStateNormal] isEqualToString:[endTimeButton titleForState:UIControlStateNormal]]){
        return NO;
    }
    return YES;
}

- (IBAction)dayButtonClicked:(id)sender{
    UIButton * button = (UIButton *)sender;
    if(button.selected){
        [button setSelected:NO];
    }else{
        [button setSelected:YES];
    }
}
- (IBAction)deleteButtonClicked:(id)sender{
    [course.lectures removeAllObjects];
    [self.delegate deleteCourse:course];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)startTimeButtonClicked:(id)sender{
    [self callDP:sender];
}

- (IBAction)endTimeButtonClicked:(id)sender{
    [self callDP:sender];
}

- (void)viewDidLoad{
    
    // Adding or Editting
    if(course == nil || [[course lectures] count]==0){
        course = [Course new];
        self.deleteButton.hidden = YES;
    }else{
        [self setIBOutletsWithCourse:course];
        self.deleteButton.hidden = NO;
    }
    
    // Set Time Buttons
    startTimeButton.tag = 2;
    startTimeButton.titleLabel.text = [NSString stringWithFormat:@"%@", @"10:00"];
    
    endTimeButton.tag = 3;
    endTimeButton.titleLabel.text = [NSString stringWithFormat:@"%@", @"11:00"];
    
    // Set originCenter
    originCenter = self.view.center;
}

- (void)setIBOutletsWithCourse:(Course *)_course{
    //set Text Field
    courseNameTextField.text = _course.courseName;
    courseLocationTextField.text = ((Lecture *)[_course.lectures objectAtIndex:0]).location;
    
    //set Day Buttons
    for(Lecture * lecture in _course.lectures){
        if(lecture.day == MON){
            [self dayButtonClicked:monButton];
        }
        else if(lecture.day == TUE){
            [self dayButtonClicked:tueButton];
        }
        else if(lecture.day == WED){
            [self dayButtonClicked:wedButton];
        }
        else if(lecture.day == THU){
            [self dayButtonClicked:thuButton];
        }
        else if(lecture.day == FRI){
            [self dayButtonClicked:friButton];
        }
        else if(lecture.day == SAT){
            [self dayButtonClicked:satButton];
        }
        else if(lecture.day == SUN){
            [self dayButtonClicked:sunButton];
        }
    }
    
    //set Time Buttons
    Lecture * strLecture = [_course.lectures objectAtIndex:0];
    int hour = strLecture.period + 8;
    int minute = (strLecture.period - (int)strLecture.period) * 60;
    NSString * hourString;
    NSString * minuteString;
    
    if(hour < 10){
        hourString = [NSString stringWithFormat:@"0%d", hour];
    }else{
        hourString = [NSString stringWithFormat:@"%d", hour];
    }
    
    if(minute < 10){
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    }else{
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    
    [startTimeButton setTitle:[NSString stringWithFormat:@"%@:%@", hourString, minuteString]
                     forState:UIControlStateNormal];
    
    hour = strLecture.period + strLecture.duration + 8;
    minute = (strLecture.period + strLecture.duration + 8 - hour) * 60;
    
    [endTimeButton setTitle:[NSString stringWithFormat:@"%d:%d", hour, minute]
                   forState:UIControlStateNormal];
}

- (void)setCourseWithIBOutlets:(Course *)_course{
    _course.courseName = courseNameTextField.text;
    [_course.lectures removeAllObjects];
    
    // get period and duration
    NSString * startTimeString = [startTimeButton titleForState:UIControlStateNormal];
    NSString * endTimeString = [endTimeButton titleForState:UIControlStateNormal];
    
    /*
    double shour = [[[startTimeString substringFromIndex:3] substringToIndex:2] integerValue];
    double sminute = [[startTimeString substringFromIndex:6] integerValue];
    double period = shour + sminute/60 - 8;
    
    double ehour = [[[endTimeString substringFromIndex:3] substringToIndex:2] integerValue];
    double eminute = [[endTimeString substringFromIndex:6] integerValue];
    double duration = ehour + eminute/60 - shour - sminute/60;

     */
    double shour = [[startTimeString substringToIndex:2] integerValue];
    double sminute = [[startTimeString substringFromIndex:3] integerValue];
    double period = shour + sminute/60 - 8;
    
    double ehour = [[endTimeString substringToIndex:2] integerValue];
    double eminute = [[endTimeString substringFromIndex:3] integerValue];
    double duration = ehour + eminute/60 - shour - sminute/60;

    if(monButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:MON period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(tueButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:TUE period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(wedButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:WED period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(thuButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:THU period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(friButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:FRI period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(satButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:SAT period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
    if(sunButton.selected){
        Lecture * lecture = [[Lecture alloc] initWithDay:SUN period:period duration:duration location:@""];
        lecture.location = courseLocationTextField.text;
        [_course.lectures addObject:lecture];
    }
}
- (NSDate*)clampDate:(NSDate *)dt toMinutes:(int)minutes {
    int referenceTimeInterval = (int)[dt timeIntervalSinceReferenceDate];
    int remainingSeconds = referenceTimeInterval % (minutes*60);
    int timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minutes*60)/2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval +((minutes*60)-remainingSeconds);
    }
    return [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
}

// DatePicker
- (void)changeDate:(UIDatePicker *)sender{
    NSDate * date = (NSDate *)sender.date;
    date = [self clampDate:date toMinutes:15];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString * dateString = [dateFormatter stringFromDate:date];
    UIButton * timeButton = (UIButton *)[self.view viewWithTag:[(UIDatePicker *)sender tag] - 10];
    [timeButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:11] removeFromSuperview];
    [[self.view viewWithTag:12] removeFromSuperview];
    [[self.view viewWithTag:13] removeFromSuperview];
    [[self.view viewWithTag:14] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.01]];
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:11].alpha = 0;
    [self.view viewWithTag:12].frame = datePickerTargetFrame;
    [self.view viewWithTag:13].frame = datePickerTargetFrame;
    [self.view viewWithTag:14].frame = toolbarTargetFrame;
    
    [UIView setAnimationDelegate:self];
    self.view.center = originCenter;
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
}

- (void)callDP:(id)sender {
    if ([self.view viewWithTag:10]) {
        return;
    }
    
    NSInteger moveCenter = courseNameTextField.frame.origin.y - self.view.frame.size.height + (216 + 44 + 20);
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44 + moveCenter, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216 + moveCenter, 320, 216);

    // UIDatePicker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    [datePicker setMinuteInterval:15];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker addTarget:self action: @selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    datePicker.tag = [(UIButton *)sender tag] + 10;

    // set default date.
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString * timeString;
    if([sender tag] == 2){
        timeString = [startTimeButton titleForState:UIControlStateNormal];
    }else if ([sender tag]==3){
        timeString = [endTimeButton titleForState:UIControlStateNormal];
    }
    [datePicker setDate:[format dateFromString:timeString]];
    
    // set minimum time
    NSString *dateString = @"09:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm";
    [datePicker setMinimumDate:[dateFormatter dateFromString:dateString]];
    
    // set maximum time
    dateString = @"22:00";
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    [datePicker setMaximumDate:[dateFormatter dateFromString:dateString]];

    // Dark Background
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 11;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    

    // UIToolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 14;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    
    [self.view addSubview:darkView];
    [self.view addSubview:datePicker];
    [self.view addSubview:toolBar];
    
    // Animation
    [UIView beginAnimations:@"MoveIn" context:nil];
    self.view.center = CGPointMake(originCenter.x, originCenter.y-moveCenter);
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

// CourseName
#pragma UITextFieldDelegate start
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSInteger moveCenter = courseNameTextField.frame.origin.y - self.view.frame.size.height + (216 + 44 + 50);
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44+moveCenter, 320, 44);

    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 11;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 14;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    //Move View up
    [UIView beginAnimations:@"MoveIn" context:nil];
    self.view.center = CGPointMake(originCenter.x, originCenter.y - moveCenter);
    toolBar.frame = toolbarTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

#pragma end

- (void)dismissKeyboard{
    [[self.view viewWithTag:11] removeFromSuperview];
    [[self.view viewWithTag:14] removeFromSuperview];
    
    [self.view endEditing:YES];
    
    
    //Move View down
    [UIView beginAnimations:@"MoveOut" context:nil];
    self.view.center = CGPointMake(originCenter.x, originCenter.y);
    [UIView commitAnimations];
}

@end
