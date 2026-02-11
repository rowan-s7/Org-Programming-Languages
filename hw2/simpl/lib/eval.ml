(* ast.ml *)
open Ast

type state = (string * int) list

let empty_state : state = []

(* get: return the value of the variable x according to the state st
   for simplicity, returns 0 if x is not defined
 *)
let rec get (st : state) (x : string) : int =
  match st with
  | [] -> 0
  | (y, v) :: tl ->
      if x = y then v else get tl x

(* set: return the result of updating the state st by assigning the value v to the variable x *)
let set (st : state) (x : string) (v : int) : state =
  (x, v) :: st

let show_one_var tup = print_endline ((fst tup) ^ " = " ^ (string_of_int (snd tup)))
let showstate st = List.iter show_one_var st

(* eval_a: evaluate the arithmetical expression aexp according to the state st *)
let rec eval_a (st: state) (expr: aexp) : int = match expr with
  | Nat n -> n
  | Var x -> get st x
  | ABin(op, a1, a2) -> let n1 = eval_a st a1 in
                         let n2 = eval_a st a2 in
                         match op with
                         | Add -> n1 + n2
                         | Sub -> n1 - n2
                         | Mul -> n1 * n2

(* eval_b: evaluate the boolean expression bexp according to the state st *)
let rec eval_b (st: state) (expr: bexp) : bool = match expr with
  | BTrue -> true
  | BFalse -> false
  | Rel(r, a1, a2) -> let n1 = eval_a st a1 in
                      let n2 = eval_a st a2 in
                      (match r with
                       | Eq -> n1 == n2
                       | Neq -> n1 != n2
                       | Le -> n1 <= n2
                       | Gt -> n1 > n2)
  | Not(b) -> not (eval_b st b)
  | And(b1, b2) -> (eval_b st b1) && (eval_b st b2)

(* eval_c: evaluate the command cmd according to the state st
   This function should recursively evaluate the command cmd, starting in the the state st,
   and return new state that results from executing cmd in the state st.

   Examples:

   * (x := 1)
     * evaluating Assign("x", Nat(1)) should return a new state st' where x is defined
       (if it wasn't already) and now has the value of 1

   * (x := y)
     * evaluating Assign("x", Var("y")) should return a new state st' where x is
       defined (if it wasn't already) and now has same value as y (and y's value
       has not changed)

   * (x := x+1)
     * evaluating Assign("x", ABin(Add, Var("x"), Nat(1))) should return a new state st'
       where the value of x has been incremented by 1

   * (skip)
     * Evaluating Skip should return the original state st with no changes

   * (x := 1; y := 1)
     * evaluating Seq(Assign("x", Nat(1)), Assign("y", Nat(1))) should return a new state st'
       where x and y have both been defined (if they weren't already) and both have the
       value of 1

   * (if x=1 then y:= 1 else skip)
     * evaluating If(Rel(Eq, Var("x"), Nat(3)), Assign("y", Nat(1)), Skip)
       should return a new state st' where the value of y has been updated to 1
       *if* x has the value of 3 in state st,
       and should *otherwise* return the original state st unmodified
 *)
let rec eval_c (st: state) (cmd: cmd) : state =
  (* YOUR CODE HERE  / Copyright 2026 Rowan Sharwood*)
  match cmd with
  | Skip ->
      st

  | Assign (x, a) ->
      let v = eval_a st a in
      set st x v

  | Seq (c1, c2) ->
      let st1 = eval_c st c1 in
      eval_c st1 c2

  | If (b, c1, c2) ->
      if eval_b st b then
        eval_c st c1
      else
        eval_c st c2

  | While (b, c) ->
      if eval_b st b then
        let st1 = eval_c st c in
        eval_c st1 (While (b, c))
      else
        st