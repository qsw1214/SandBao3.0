/*
**  xstring.h -- sz::XString
**  Copyright (C) 2013 Rick Xing. All rights reserved.
**  AUTHOR
**      Rick Xing <xingziwen@yahoo.com>
**  HISTORY
**      2013-06-19 # Created by Rick Xing
*/

#ifndef XSTRING_H
#define XSTRING_H

namespace sz
{
class XString
{
public:
    XString(void);
    XString(const XString& str);
    XString(const char* cstr);
    ~XString(void);

private:
    char* ptr;
    int length;
    void Clean(void);
    void Allocate(int len);

public:
    int Length(void) const;
    char* Buffer(void) const;

    XString& operator =(const XString& str);
    XString& operator =(const char* str);

    friend XString operator +(const XString& lstr, const XString& rstr);
    
    XString& Append(const XString& str);

    XString Mid(int beginpos, int len) const;
    XString Left(int len) const;
    XString Right(int len) const;

    friend bool operator ==(const XString& lstr, const XString& rstr);
    friend bool operator !=(const XString& lstr, const XString& rstr);

    XString Upper() const;
    XString Lower() const;

    int Find(const XString& str) const;//

    XString Trim(void) const;//

};
}

#endif
