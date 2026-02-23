(* ast.ml *)

type ident = string

type aop = Add | Sub | Mul

type rel = Eq | Neq | Le | Gt

type aexp =
  | Nat of int
  | Var of ident
  | ABin of aop * aexp * aexp

type bexp =
  | BTrue
  | BFalse
  | Rel of rel * aexp * aexp
  | Not of bexp
  | And of bexp * bexp

type cmd =
  | Skip
  | Assign of ident * aexp
  | Seq of cmd * cmd
  | If of bexp * cmd * cmd
  | While of bexp * cmd
