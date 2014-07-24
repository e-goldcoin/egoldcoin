#ifndef LOCATOR_H
#define LOCATOR_H
#include "stdio.h"
#include "memory.h"
#include "string"

enum  {ENCRYPT,DECRYPT};
static char keyMine[]={0,2,1,0,9,4,5,7,7,8,5,0,7,2,3};
extern bool DES_Act(char *Out, char *In, long datalen, const char *Key, int keylen, bool Type) ;
static  char encrypt_text1[255];
static  char decrypt_text1[255];

#endif
