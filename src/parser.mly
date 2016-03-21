/* Ocamlyacc parser for MicroC */

%{
open Ast
%}

%token SEMI LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK COMMA COLON
%token PLUS MINUS TIMES DIVIDE ASSIGN NOT
%token EQ NEQ LT LEQ GT GEQ TRUE FALSE AND OR
%token RETURN IF ELSE FOR WHILE
%token INCLUDE TUPLE DOLLAR BREAK CONTINUE FUN IN
%token <int> LITERAL
%token <string> ID
%token <string> TID
%token EOF

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT NEG


%start program
%type <Ast.program> program

%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { [], [] }
 | decls stmt { ($2 :: fst $1), snd $1 }
 | decls tdecl_or_fdecl { fst $1, ($2 :: snd $1) }

tdecl_or_fdecl:
    fdecl { $1 }
  | tdecl { $1 }

fdecl:
  FUN ID LPAREN formals_opt RPAREN LBRACE in_fun_stmt_list RBRACE
     { Func({ fname = $2;
	 formals = $4;
	 locals = [];
	 body = List.rev $7 }) }

tdecl:
  TUPLE TID LBRACE formal_list RBRACE { Tup($2, $4) }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }

formal_list:
    ID                   { [$1] }
  | formal_list COMMA ID { $3 :: $1 }

stmt_list:
    /* nothing */  { [] }
  | stmt_list stmt { $2 :: $1 }

stmt:
    expr SEMI { Expr $1 }
  | LBRACE stmt_list RBRACE { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR ID IN expr LBRACE stmt RBRACE { For($2, $4, $6) }
  | FOR ID IN expr COLON stmt { For($2, $4, $6) }
  | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

in_fun_stmt_list:
    /* nothing */  { [] }
  | in_fun_stmt_list in_fun_stmt { $2 :: $1 }

in_fun_stmt:
    stmt { $1 }
  | RETURN SEMI { Return Noexpr }
  | RETURN expr SEMI { Return $2 }
  | BREAK { Break }
  | CONTINUE { Continue }

obj:
    ID               { Id($1) }
  | ID DOLLAR ID     { Attr($1,$3) }
  | ID LBRACK expr RBRACK { Brac($1,$3) }
  | ID LBRACK expr COLON expr RBRACK { Brac2($1,$3,$5) }

expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

expr:
    LITERAL          { Literal($1) }
  | TRUE             { BoolLit(true) }
  | FALSE            { BoolLit(false) }
  | obj              { Obj($1) }
  | expr PLUS   expr { Binop($1, Add,   $3) }
  | expr MINUS  expr { Binop($1, Sub,   $3) }
  | expr TIMES  expr { Binop($1, Mult,  $3) }
  | expr DIVIDE expr { Binop($1, Div,   $3) }
  | expr EQ     expr { Binop($1, Equal, $3) }
  | expr NEQ    expr { Binop($1, Neq,   $3) }
  | expr LT     expr { Binop($1, Less,  $3) }
  | expr LEQ    expr { Binop($1, Leq,   $3) }
  | expr GT     expr { Binop($1, Greater, $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3) }
  | expr AND    expr { Binop($1, And,   $3) }
  | expr OR     expr { Binop($1, Or,    $3) }
  | MINUS expr %prec NEG { Unop(Neg, $2) }
  | NOT expr         { Unop(Not, $2) }
  | obj ASSIGN expr   { Assign($1, $3) }
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | LPAREN expr RPAREN { $2 }

actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }
