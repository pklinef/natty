tree grammar DateWalker;

options {
  tokenVocab=Date;
  ASTLabelType=CommonTree;
}

@header { package com.natty.parse; }

@members {
  DateTime dateTime = new DateTime();
}

datetime 
  @after {
    dateTime.getDate();  
  }
  : ^(DATE_TIME date time?) 
  ;

date
  : relative_date 
  | explicit_date
  ;
  
time
  : explicit_time
  ;

explicit_date
  : ^(EXPLICIT_DATE MONTH DAY YEAR? ERA?)
    {System.out.println($MONTH.text);}
  ;

relative_date
  // a direction and number of days to seek
  : ^(RELATIVE_DATE SEEK_DIRECTION INTEGER) 
    {dateTime.seek($SEEK_DIRECTION.text, $INTEGER.text);}
  
  // a direction, seek type (day to day, or a week at a time), an amount to seek by, 
  // and a day of week to seek to
  | ^(RELATIVE_DATE SEEK_DIRECTION SEEK_TYPE INTEGER DAY_OF_WEEK) 
    {dateTime.seekToDayOfWeek($SEEK_DIRECTION.text, $SEEK_TYPE.text, $INTEGER.text, $DAY_OF_WEEK.text);}
    
  // a direction, seek type (which is ignored in this case) an amount to seek by, 
  // and an amount multipler span of time (day, week, month, year)
  | ^(RELATIVE_DATE SEEK_DIRECTION SEEK_TYPE INTEGER SPAN) 
    {dateTime.seekBySpan($SEEK_DIRECTION.text, $INTEGER.text, $SPAN.text);}
  ;
  
explicit_time 
  : ^(EXPLICIT_TIME INTEGER INTEGER AM_PM?)
  ;