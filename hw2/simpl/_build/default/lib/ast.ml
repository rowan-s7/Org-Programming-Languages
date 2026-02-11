(* ast.ml *)

(* ident: Variable Names *)
type ident = string

(* aop: Binary Arithmetic operators
 * Add: +
 * Sub: -
 * Mul: *
*)
type aop = Add | Sub | Mul


(* rel: relations
 * Eq:  =
 * Neq: !=
 * Le:  <=
 * Gt:  >
*)
type rel = Eq | Neq | Le | Gt

(* aexp: Arithmetic expressions *)
type aexp =
  | Nat of int                   (* Natural numbers: 1, 2, 77, etc *)
  | Var of ident                 (* Variables *)
  | ABin of aop * aexp * aexp    (* Binary Arithmetic: 1+2, x+3, 3-2, etc.
                                    note that aop specifies the operation in question *)

(* bexp: Boolean expressions *)
type bexp =
  | BTrue                        (* true *)
  | BFalse                       (* false *)
  | Rel of rel * aexp * aexp     (* Comparison expressions: 1<=2, 3!=4, x=1, etc.
                                  note that rel specifies which comparison to use *)
  | Not of bexp                  (* boolean negation: (not (x=2)), (not false), (not (x<=3)), etc. *)
  | And of bexp * bexp           (* logical and: (and true false), (and (x=1) (y<=3)), etc. *)

(* cmd: commands *)
type cmd =
  | Skip                         (* skip *)
  | Assign of ident * aexp       (* Assignment: (x := 3), (x:=y), (y:=x+(3*z)), etc. *)
  | Seq of cmd * cmd             (* Sequencing: (c1; c2) *)
  | If of bexp * cmd * cmd       (* If-then-else: (if b then c1 else c2 end) *)
  | While of bexp * cmd          (* While: (while b do c end) *)

  
