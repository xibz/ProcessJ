%{
#include "y.tab.h"

  int printToken(char *string, int type) {
    printf("[%s ; text=%s ; line=%d]\n",string,yytext,yylineno);
    return type;
  }

%}

%option yylineno

LineTerminator  \r|\n|\r\n
InputCharacter  [^\r\n]
WhiteSpace  \r|\n|\r\n|[ \t\f]

/* Comments */
TraditionalComment  "/*"[^*]{CommentContent}\*+"/"
UnterminatedComment  "/*"[^*]{CommentContent}\**"/"?
EndOfLineComment  "//"{InputCharacter}*{LineTerminator}
Comment  {TraditionalComment}|{EndOfLineComment} 
CommentContent  ([^*]|\*+[^*/])*

/* Integer Literals */
DecIntegerLiteral  0|[1-9][0-9]*
DecLongLiteral     {DecIntegerLiteral}[lL]
HexIntegerLiteral  0[xX]0*{HexDigit}{1,8}
HexLongLiteral     0[xX]0*{HexDigit}{1,16}[lL]
HexDigit           [0-9a-fA-F]
OctIntegerLiteral  0+[1-3]?{OctDigit}{1,15}
OctLongLiteral     0+1?{OctDigit}{1,21}[lL]
OctDigit           [0-7]      

/* Floating Point Literals */
FloatLiteral   ({FLit1}|{FLit2}|{FLit3}|{FLit4})[fF]
DoubleLiteral  {FLit1}|{FLit2}|{FLit3}|{FLit4} 
FLit1  [0-9]+\.[0-9]*{Exponent}?
FLit2  \.[0-9]+{Exponent}?
FLit3  [0-9]+{Exponent}
FLit4  [0-9]+{Exponent}?

Exponent  [eE][+\-]?[0-9]+       

/* Identifiers */ 
Identifier  [A-Za-z_][A-Za-z0-9_]*

/* String Literals */
StringCharacter  [^\r\n\"\\]
SingleCharacter [^\r\n\'\\]
StringEscape    \\([btnfr"'\\]|[0-3]?{OctDigit}?{OctDigit}|u{HexDigit}{HexDigit}{HexDigit}{HexDigit}) 

%%

"boolean"   return printToken("BOOLEAN",BOOLEAN); 
"byte"      return printToken("BYTE",BYTE);
"int"       return printToken("INT",INT);
"long"      return printToken("LONG",LONG);
"short"     return printToken("SHORT",SHORT);
"float"     return printToken("FLOAT",FLOAT);
"string"    return printToken("STRING",STRING);
"double"    return printToken("DOUBLE",DOUBLE);
"char"      return printToken("CHAR",CHAR);
"proc"      return printToken("PROC",PROC);
"mobile"    return printToken("MOBILE",MOBILE);
"chan"      return printToken("CHAN",CHAN);
"barrier"   return printToken("BARRIER",BARRIER);
"timer"     return printToken("TIMER",TIMER);
"read"      return printToken("READ",READ);
"write"     return printToken("WRITE",WRITE);
"shared"    return printToken("SHARED",SHARED);
"timeout"   return printToken("TIMEOUT",TIMEOUT);
"skip"      return printToken("SKIP",SKIP);
"stop"      return printToken("STOP",STOP);
"sync"      return printToken("SYNC",SYNC);
"claim"     return printToken("CLAIM",CLAIM);
"seq"       return printToken("SEQ",SEQ);
"par"       return printToken("PAR",PAR);
"if"        return printToken("IF",IF);
"else"      return printToken("ELSE",ELSE);
"for"       return printToken("FOR",FOR);
"while"     return printToken("WHILE",WHILE);
"switch"    return printToken("SWITCH",SWITCH);
"case"      return printToken("CASE",CASE);
"do"        return printToken("DO",DO);
"default"   return printToken("DEFAULT",DEFAULT);
"break"     return printToken("BREAK",BREAK);
"continue"  return printToken("CONTINUE",CONTINUE);
"return"    return printToken("RETURN",RETURN);
"new"       return printToken("NEW",NEW);  
"resume"    return printToken("RESUME",RESUME);
"suspend"   return printToken("SUSPEND",SUSPEND);
"with"      return printToken("WITH",WITH);
"pri"       return printToken("PRI",PRI);
"alt"       return printToken("ALT",ALT);
"protocol"  return printToken("PROTOCOL",PROTOCOL);
"extends"   return printToken("EXTENDS",EXTENDS);
"void"      return printToken("VOID",VOID);
"implements" return printToken("IMPLEMENTS",IMPLEMENTS);
"record"    return printToken("RECORD",RECORD);
"enroll"    return printToken("ENROLL",ENROLL);
"package"   return printToken("PACKAGE",PACKAGE);
"native"    return printToken("NATIVE",NATIVE);
"const"     return printToken("CONST",CONST);
"import"    return printToken("IMPORT",IMPORT);
"public"    return printToken("PUBLIC",PUBLIC);
"private"   return printToken("PRIVATE",PRIVATE);
"protected" return printToken("PROTECTED",PROTECTED);
"true"      return printToken("BOOLEAN_LITERAL",BOOLEAN_LITERAL); 
"false"     return printToken("BOOLEAN_LITERAL",BOOLEAN_LITERAL); 
"("         return printToken("LPAREN",LPAREN); 
")"         return printToken("RPAREN",RPAREN);  
"{"         return printToken("LBRACE",LBRACE);  
"}"         return printToken("RBRACE",RBRACE);  
":"         return printToken("COLON",COLON);
";"         return printToken("SEMICOLON",SEMICOLON);  
","         return printToken("COMMA",COMMA);  
"."         return printToken("DOT",DOT);  
"["         return printToken("LBRACK",LBRACK);
"]"         return printToken("RBRACK",RBRACK);
"="         return printToken("EQ",EQ);  
">"         return printToken("GT",GT);
"<"         return printToken("LT",LT); 
"<<"        return printToken("LSHIFT",LSHIFT); 
">>"        return printToken("RSHIFT",RSHIFT); 
">>>"       return printToken("URSHIFT",URSHIFT); 
"!"         return printToken("NOT",NOT); 
"~"         return printToken("COMP",COMP); 
"=="        return printToken("EQEQ",EQEQ); 
"<="        return printToken("LTEQ",LTEQ); 
">="        return printToken("GTEQ",GTEQ); 
"!="        return printToken("NOTEQ",NOTEQ); 
"&&"        return printToken("ANDAND",ANDAND); 
"||"        return printToken("OROR",OROR); 
"++"        return printToken("PLUSPLUS",PLUSPLUS); 
"--"        return printToken("MINUSMINUS",MINUSMINUS); 
"+"         return printToken("PLUS",PLUS); 
"-"         return printToken("MINUS",MINUS); 
"*"         return printToken("MULT",MULT); 
"/"         return printToken("DIV",DIV); 
"&"         return printToken("AND",AND); 
"|"         return printToken("OR",OR); 
"^"         return printToken("XOR",XOR); 
"%"         return printToken("MOD",MOD); 
"*="        return printToken("MULTEQ",MULTEQ); 
"/="        return printToken("DIVEQ",DIVEQ); 
"%="        return printToken("MODEQ",MODEQ); 
"+="        return printToken("PLUSEQ",PLUSEQ); 
"-="        return printToken("MINUSEQ",MINUSEQ); 
"<<="       return printToken("LSHIFTEQ",LSHIFTEQ); 
">>="       return printToken("RSHIFTEQ",RSHIFTEQ); 
">>>="      return printToken("URSHIFTEQ",URSHIFTEQ); 
"&="        return printToken("ANDEQ",ANDEQ); 
"^="        return printToken("XOREQ",XOREQ); 
"|="        return printToken("OREQ",OREQ);  
"?"         return printToken("QUEST",QUEST);

{DecIntegerLiteral} return printToken("INTEGER_LITERAL",INTEGER_LITERAL);
{DecLongLiteral}    return printToken("LONG_LITERAL",LONG_LITERAL);
{HexIntegerLiteral} return printToken("INTEGER_LITERAL",INTEGER_LITERAL);
{HexLongLiteral}    return printToken("LONG_LITERAL",LONG_LITERAL);
{OctIntegerLiteral} return printToken("INTEGER_LITERAL",INTEGER_LITERAL);
{OctLongLiteral}    return printToken("LONG_LITERAL",LONG_LITERAL);
{FloatLiteral}      return printToken("FLOAT_LITERAL",FLOAT_LITERAL);
{DoubleLiteral}     return printToken("DOUBLE_LITERAL",DOUBLE_LITERAL);

\"{StringCharacter}*\"       return printToken("STRING_LITERAL",STRING_LITERAL);
\"{StringCharacter}*{LineTerminator} printf("Unterminated string at end-of-line \"%s\" at line %d\n",yytext, yylineno+1); exit(1); 

\'{SingleCharacter}\'        return printToken("CHARACTER_LITERAL",CHARACTER_LITERAL);
\'{StringEscape}\'           return printToken("CHARACTER_LITERAL",CHARACTER_LITERAL);
\'{SingleCharacter}?{LineTerminator} printf("Unterminated character at end-of-line \"%s\" at line %d\n", yytext, yylineno+1); exit(1);
\'{StringEscape}?{LineTerminator} printf("Unterminated string at end-of-line \"%s\" at line %d\n", yytext, yylineno+1); exit(1); 

{Comment}                    ;
{UnterminatedComment}        printf("Unterminated comment at EOF at line %d\n", yylineno+1);  exit(1);

{WhiteSpace}                 ;

{Identifier}                 return printToken("IDENTIFIER",IDENTIFIER);

.|\n                         printf("Illegal character %s at line %d\n", yytext, yylineno+1); exit(1);




%%





