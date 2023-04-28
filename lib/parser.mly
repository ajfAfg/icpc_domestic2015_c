%{
open Syntax
%}

%token INPERIOD DEPERIOD
%token NEWLINE
%token PLUS MULT
%token EOF
%token <int> INTV

%start exp
%type <Syntax.exp> exp
%%

exp :
  | e=exp_ EOF
    { e }
  | { failwith "Syntax error" }

exp_ :
  | i=INTV NEWLINE
    { ILit i }
  | op=op NEWLINE
    INPERIOD es=nonempty_list(e=exp_ {e}) DEPERIOD
    { Op (op, es) }

%inline op :
  | PLUS
    { Plus }
  | MULT
    { Mult }
