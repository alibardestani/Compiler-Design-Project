%{
#include <stdio.h>
#include <stdlib.h>

%define api.value.type union
%define parse.error verbose

void concatAndAdd(long long *int1, long long int2, long long int3);
void concatAndMinus(long long *int1, long long int2, long long int3);
void concatAndMul(long long *int1, long long int2, long long int3);
void concatAndDiv(long long *int1, long long int2, long long int3);
void printAdd(long long *int1, long long int2, long long int3);
void printMin(long long *int1, long long int2, long long int3);
void printMul(long long *int1, long long int2, long long int3);
void printDiv(long long *int1, long long int2, long long int3);

int yylex(void);
void yyerror(char *);
int tempNum = 0;
%}

%token digit

%%

S: S E'\n' {$$=$2; printf("\n\nOutput = %lld \n\n",$$);tempNum = 0;}
 | ;
E: E '+' T {concatAndAdd(&$$,$1,$3); printAdd(&$$,$1,$3);}
 | E '-' T {concatAndMinus(&$$,$1,$3); printMin(&$$,$1,$3);}
 | T       {$$=$1;}
 ;
T: T '*' F {concatAndMul(&$$,$1,$3); printMul(&$$,$1,$3);}
 | T '/' F {concatAndDiv(&$$,$1,$3); printDiv(&$$,$1,$3);}
 | F       {$$=$1;}
 ;
F:'(' E ')'	  {$$=$2;}
 |digit   {$$=$1;}
 ;

%%

void concatAndAdd(long long *int1, long long int2, long long int3) {
    char str2[40], str3[40];
    sprintf(str2, "%lld", int2);
    sprintf(str3, "%lld", int3);

    strcat(str2, str3);

    *int1 = atoll(str2);
}

void concatAndMinus(long long *int1, long long int2, long long int3) {
    char str2[40], str3[40];
    sprintf(str2, "%lld", int2);
    sprintf(str3, "%lld", int3);

    int len2 = strlen(str2);
    int len3 = strlen(str3);

    for (int i = 0; i < len2; i++) {
        for (int j = 0; j < len3; j++) {
            if (str2[i] == str3[j]) {
                memmove(&str2[i], &str2[i + 1], len2 - i);
                len2--;
                i--;
                break;
            }
        }
    }

    *int1 = atoll(str2);
}

void concatAndMul(long long *int1, long long int2, long long int3) {
    char str2[40], str3[40];
    sprintf(str2, "%lld", int2);
    sprintf(str3, "%lld", int3);

    int sum = 0;
    int len2 = strlen(str2);
    int len3 = strlen(str3);

    for (int i = 0; i < len3; i++) {
        sum += str3[i] - '0';
    }

    while (sum >= 10) {
        int su = 0;
        while (sum > 0) {
            su += sum % 10;
            sum /= 10;
        }
        sum = su;
    }

    int f = 0;
    for (int i = 0; i < len3; i++) {
        int isDuplicate = 0;

        for (int j = 0; j < len2; j++) {
            if (str3[i] == sum) {
                f = 1;
                break;
            }
        }
    }

    if (f == 0) {
        sprintf(str2, "%lld", int2);
        sprintf(str3, "%d", sum);

        strcat(str2, str3);
    }

    *int1 = atoll(str2);
}

void concatAndDiv(long long *int1, long long int2, long long int3) {
    char str2[40], str3[40];
    sprintf(str2, "%lld", int2);
    sprintf(str3, "%lld", int3);

    int sum = 0;
    int len2 = strlen(str2);
    int len3 = strlen(str3);

    for (int i = 0; i < len3; i++) {
        sum += str3[i] - '0';
    }

    while (sum >= 10) {
        int su = 0;
        while (sum > 0) {
            su += sum % 10;
            sum /= 10;
        }
        sum = su;
    }

    sprintf(str3, "%lld", sum);
    len3 = strlen(str3);

    for (int i = 0; i < len2; i++) {
        for (int j = 0; j < len3; j++) {
            if (str2[i] == str3[j]) {
                memmove(&str2[i], &str2[i + 1], len2 - i);
                len2--;
                i--;
                break;
            }
        }
    }

    *int1 = atoll(str2);
}

void printAdd(long long *int1, long long int2, long long int3) {
    printf("t%d = %lld + %lld;\n", ++tempNum, int2, int3);
    printf("t%d = %lld;\n", tempNum, *int1);
}

void printMin(long long *int1, long long int2, long long int3) {
    printf("t%d = %lld - %lld;\n", ++tempNum, int2, int3);
    printf("t%d = %lld;\n", tempNum, *int1);
}

void printMul(long long *int1, long long int2, long long int3) {
    printf("t%d = %lld * %lld;\n", ++tempNum, int2, int3);
    printf("t%d = %lld;\n", tempNum, *int1);
}

void printDiv(long long *int1, long long int2, long long int3) {
    printf("t%d = %lld / %lld;\n", ++tempNum, int2, int3);
    printf("t%d = %lld;\n", tempNum, *int1);
}

int main() {
    printf("Enter Arithmetic Expressions : \n\n");
    yyparse();
    return 0;
}

void yyerror(char *msg) {
    printf("\n\n%s", msg);
    printf("\n\n Invalid Arithmetic Expression\n\n");
}
