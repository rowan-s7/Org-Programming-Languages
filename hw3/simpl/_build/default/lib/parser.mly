/* lib/parser.mly */
%{
  open Ast
%}

%token SKIP IF THEN ELSE END WHILE DO
%token TRUE FALSE
%token NOT                 /* '~' */
%token ASSIGN              /* ':=' */
%token SEMI                /* ';' */

%token PLUS MINUS TIMES    /* '+', '-', '*' */

%token EQ NEQ LE GT        /* '=', '!=', '<=', '>' */
%token ANDAND              /* '&&' */

%token LPAREN RPAREN

%token <int> NAT
%token <string> IDENT
%token EOF

%start <Ast.cmd> program

/* Precedence (lowest → highest) */
%right SEMI
%left ANDAND
%right NOT
%nonassoc EQ NEQ LE GT
%left PLUS MINUS
%left TIMES

%%

program:
  | c=cmd EOF { c }
  ;

cmd:
  | c=cmd_seq { c }
  ;

(* Right-associative sequencing: c1 ; (c2 ; ...) *)
cmd_seq:
  | c1=cmd_atom SEMI c2=cmd_seq { Seq (c1, c2) }
  | c=cmd_atom                  { c }
  ;

cmd_atom:
  | SKIP                                  { Skip }
  | x=IDENT ASSIGN a=aexp                 { Assign (x, a) }
  | IF b=bexp THEN c1=cmd ELSE c2=cmd END { If (b, c1, c2) }
  | WHILE b=bexp DO c=cmd END             { While (b, c) }
  | LPAREN c=cmd RPAREN                   { c }
  ;

aexp:
  | a=a_add { a }
  ;

a_add:
  | a1=a_add PLUS  a2=a_mul { ABin (Add, a1, a2) }
  | a1=a_add MINUS a2=a_mul { ABin (Sub, a1, a2) }
  | a=a_mul                 { a }
  ;

a_mul:
  | a1=a_mul TIMES a2=a_atom { ABin (Mul, a1, a2) }
  | a=a_atom                 { a }
  ;

a_atom:
  | n=NAT                { Nat n }
  | x=IDENT              { Var x }
  | LPAREN a=aexp RPAREN { a }
  ;

bexp:
  | b=b_and { b }
  ;

b_and:
  | b1=b_and ANDAND b2=b_not { And (b1, b2) }
  | b=b_not                  { b }
  ;

b_not:
  | NOT b=b_not { Not b }
  | b=b_atom    { b }
  ;

b_atom:
  | TRUE                     { BTrue }
  | FALSE                    { BFalse }
  | a1=aexp r=relop a2=aexp  { Rel (r, a1, a2) }
  | LPAREN b=bexp RPAREN     { b }
  ;

relop:
  | EQ  { Eq }
  | NEQ { Neq }
  | LE  { Le }
  | GT  { Gt }
  ;
