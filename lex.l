%{
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

%{
#include "y.tab.h"
%}

%%

[0-9]+ {
    yylval = strtoll(yytext, NULL, 10);
    return digit;
}

[-+*/()\n]    return *yytext;

. ;

%%
