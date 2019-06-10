/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     START = 258,
     JSON = 259,
     YAML = 260,
     OBJECT = 261,
     KEY = 262,
     PARAGRAPH = 263,
     CONTENT = 264,
     COLON = 265,
     COMMA = 266,
     NULLVALUE = 267,
     BOOLEAN = 268,
     BOOLVALUE = 269,
     ARRAY = 270,
     OBJECTKEY = 271,
     OBJECTVALUE = 272,
     ARRAYKEY = 273,
     ARRAYVALUE = 274,
     list = 275,
     array = 276,
     blockline = 277,
     KEYVALUE = 278
   };
#endif
/* Tokens.  */
#define START 258
#define JSON 259
#define YAML 260
#define OBJECT 261
#define KEY 262
#define PARAGRAPH 263
#define CONTENT 264
#define COLON 265
#define COMMA 266
#define NULLVALUE 267
#define BOOLEAN 268
#define BOOLVALUE 269
#define ARRAY 270
#define OBJECTKEY 271
#define OBJECTVALUE 272
#define ARRAYKEY 273
#define ARRAYVALUE 274
#define list 275
#define array 276
#define blockline 277
#define KEYVALUE 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 10 "yaml.y"
{char* str; char* keyvalue;}
/* Line 1529 of yacc.c.  */
#line 97 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

