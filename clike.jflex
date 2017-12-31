import java.math.BigDecimal;

%%

//macros and defenitions


%class Lexer 
%unicode 
%line
%column
%type String


%{ StringBuilder string = new StringBuilder();
%}

StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

decIntgereLiteral = 0 | [1-9][0-9]*

alphabet = [a-zA-Z]

//identifiers = (_)*{alphabet}+((_)*({alphabet}|{decIntgereLiteral})+)*

//(_)*[a-zA-Z]+([_]*([a-zA-Z]+|(0|[1-9])+))*

identifier = [_]+[0-9]+((_)*([a-zA-Z]|(0|[1-9]))+)* | ([_])*[a-zA-Z]+((_)*([a-zA-Z]|(0|[1-9]))+)*

badIdentifier = [0-9]+[a-zA-Z]+((_)*([a-zA-Z]|(0|[1-9]))+)*

Integer = ("-"|"+")?{decIntgereLiteral}

float = ("-"|"+")?"."{decIntgereLiteral} |  ("-"|"+")?{decIntgereLiteral}"."{decIntgereLiteral}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/*ENotation = "-"?[0-9]("e"|"E")("-"|"+"?){decIntgereLiteral}*/

ENotation = ({float}|("-"|"+"?){decIntgereLiteral})("e"|"E")("-"|"+"?){decIntgereLiteral}

comment = "%%"{InputCharacter}* {LineTerminator}? | "%&" [^*] ~"&%"

hex = 0[xX]0*{HexDigit}{1,9}
HexDigit  = [0-9a-fA-F]

%state STRING

%%

//grammar



<YYINITIAL>{

/* keywords */

"break"                         {return "break";}  
"bool"                          {return "bool";}
"byte"                          {return "byte";}
"case"                          {return "case";}
"char"                          {return "char";}
"const"                         {return "const";}
"continue"                      {return "continue";}
"default"                       {return "default";}
"do"                            {return "do";}
"double"                        {return "double";}
"else"                          {return "else";}
"extern"                        {return "extern";}
"float"                         {return "float";}
"for"                           {return "for";}
"goto"                          {return "goto";}
"if"                            {return "if";}
"include"                       {return "include";}
"int"                           {return "int";}
"long"                          {return "long";}
"return"                        {return "return";}
"record"                        {return "record";}
"sizeof"                        {return "sizeof";}
"string"                        {return "string";}
"switch"                        {return "switch";}
"until"                         {return "until";}
"void"                          {return "void";}
"while"                         {return "while";}


/* boolean literals */

"true"                          {return "true";}
"false"                         {return "false";}

/* seperators */

  ")"                            { return "RPAREN"; }
  "("                            { return "LPAREN"; }
  "{"                            { return "LBRACE"; }
  "}"                            { return "RBRACE"; }
  "["                            { return "LBRACK"; }
  "]"                            { return "RBRACK"; }
  ";"                            { return "SEMICOLON"; }
  ","                            { return "COMMA"; }
  "."                            { return "DOT"; }

  /* operators */

  "="                            { return "EQ"; }
  ">"                            { return "GT"; }
  "<"                            { return "LT"; }
  "!"                            { return "NOT"; }
  "~"                            { return "COMP"; }
  ":"                            { return "COLON"; }
  "=="                           { return "EQEQ"; }
  "<="                           { return "LTEQ"; }
  ">="                           { return "GTEQ"; }
  "!="                           { return "NOTEQ"; }
  "&&"                           { return "ANDAND"; }
  "||"                           { return "OROR"; }
  "++"                           { return "PLUSPLUS"; }
  "--"                           { return "MINUSMINUS"; }
  "+"                            { return "PLUS"; }
  "-"                            { return "MINUS"; }
  "*"                            { return "MULT"; }
  "/"                            { return "DIV"; }
  "&"                            { return "AND"; }
  "|"                            { return "OR"; }
  "^"                            { return "XOR"; }
  "%"                            { return "MOD"; }

  \"                             {yybegin(STRING); string.setLength(0);}

{identifier}                     {return "id";}

{hex}                           {String temp = "";
              for (int i = 2 ; i < yytext().length() ; i ++){
                temp += yytext().charAt(i);
              }
              int result = Integer.valueOf(temp , 16);
              return ("hex: " + result);}

//{alphabet}                     {return "1";}

{float}                           {return "float";}

{Integer}                         {return "Integer";}

{ENotation}                      {BigDecimal temp = new BigDecimal(yytext());
              return ("ENotation: " + temp.toPlainString());}
 
{WhiteSpace}                     {/* ignore */}

{comment}                        {return "comment";}

{badIdentifier}                 {return ("invalid Identifier at line: " + yyline + " and column: " + yycolumn);}


<<EOF>>                          {return "EOF";}
}

<STRING> {
  \"                             { yybegin(YYINITIAL); return ("string = " + string.toString()); }
  
  {StringCharacter}+             { string.append( yytext() ); }
  
  /* escape sequences */
  "\\b"                          { string.append( '\b' ); }
  "\\t"                          { string.append( '\t' ); }
  "\\n"                          { string.append( '\n' ); }
  "\\f"                          { string.append( '\f' ); }
  "\\r"                          { string.append( '\r' ); }
  "\\\""                         { string.append( '\"' ); }
  "\\'"                          { string.append( '\'' ); }
  "\\\\"                         { string.append( '\\' ); }
  /*[0-3]?{OctDigit}?{OctDigit}  { char val = (char) Integer.parseInt(yytext().substring(1),8);
                        				   string.append( val ); }*/
  
  /* error cases */
  \\.                            { yybegin(YYINITIAL);  System.out.println("not valid string");}
  {LineTerminator}               { yybegin(YYINITIAL);  System.out.println("not valid string");}
 
 <<EOF>>                         { yybegin(YYINITIAL);  System.out.println("not valid string");}
  
}


[^]         {return ("Error at line: " + yyline + " and column: " + yycolumn);}