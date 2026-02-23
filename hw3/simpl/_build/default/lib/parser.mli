
(* The type of tokens. *)

type token = 
  | WHILE
  | TRUE
  | TIMES
  | THEN
  | SKIP
  | SEMI
  | RPAREN
  | PLUS
  | NOT
  | NEQ
  | NAT of (int)
  | MINUS
  | LPAREN
  | LE
  | IF
  | IDENT of (string)
  | GT
  | FALSE
  | EQ
  | EOF
  | END
  | ELSE
  | DO
  | ASSIGN
  | ANDAND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.cmd)
