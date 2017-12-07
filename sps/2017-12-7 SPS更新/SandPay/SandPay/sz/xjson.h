/*
**  xjson.h -- JavaScript Object Notation
**  Copyright (C) 2013 Rick Xing. All rights reserved.
**  AUTHOR
**      Rick Xing <xingziwen@yahoo.com>
**  HISTORY
**      2013-06-24 # Created by Rick Xing
*/

#ifndef XJSON_H
#define XJSON_H

namespace sz
{
class XJson
{
public:
    XJson(void);
    ~XJson(void);

    void Clean(void);

    int GetNumOfElements(void);

    void AddElement(const char* name, const char* value, bool isString = true);
    void AddElement(const char* value, bool isString = true);

    void GetJsonObject(char* doc, int* doc_len);
    void GetJsonArray(char* doc, int* doc_len);

    bool Parse(char* doc);

    bool GetElement(const char* name, char* value, int* value_len);
    bool GetElement(int index, char* name, int* name_len, char* value, int* value_len);
    bool GetElement(int index, char* value, int* value_len);

    int GetJsonType(void);

public:
    static const int MAX_NUM_OF_ELEMENTS = 128;

public:

public:
    static const int JSON_TYPE_OBJECT = 1;
    static const int JSON_TYPE_ARRAY = 2;

private:
    int NumOfElements;
    char* ElementNameSet[MAX_NUM_OF_ELEMENTS];
    char* ElementValueSet[MAX_NUM_OF_ELEMENTS];
    bool ElementIsStringSet[MAX_NUM_OF_ELEMENTS];
    int JsonType;
    bool DoubleQuote_Door;

public:
    void UtilTrim(char * str);
    void UtilCutDoubleQuote(char * str);

};
}

static const char PUNC_BRACE_LEFT = '{';
static const char PUNC_BRACE_RIGHT = '}';
static const char PUNC_BRACKET_LEFT = '[';
static const char PUNC_BRACKET_RIGHT = ']';
static const char PUNC_COMMA = ',';
static const char PUNC_COLON = ':';
static const char PUNC_DOUBLE_QUOTE = '"';

#endif
