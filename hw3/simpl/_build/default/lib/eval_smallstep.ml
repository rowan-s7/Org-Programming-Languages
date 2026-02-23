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


(* step_a: evaluate a single step of an aexp according to the state st. Return the new aexp.
   The cases for Nat, Var, and Add are already implemented for you;
   you must implement the cases for Mul and Sub.
 *)
let rec step_a (st: state) (expr: aexp) : aexp = match expr with
  | Nat n -> Nat n
  | Var x -> Nat (get st x)
  | ABin(Add, Nat n1, Nat n2) -> Nat (n1 + n2)
  | ABin(Add, Nat n, a) -> ABin(Add, Nat n, step_a st a)
  | ABin(Add, a1, a2) -> ABin(Add, step_a st a1, a2)
  (* Subtract *)
  | ABin(Sub, Nat n1, Nat n2) -> Nat (n1 - n2)
  | ABin(Sub, Nat n, a) -> ABin(Sub, Nat n, step_a st a)
  | ABin(Sub, a1, a2) -> ABin(Sub, step_a st a1, a2)
  (*Multiply*)
  | ABin(Mul, Nat n1, Nat n2) -> Nat (n1 * n2)
  | ABin(Mul, Nat n, a) -> ABin(Mul, Nat n, step_a st a)
  | ABin(Mul, a1, a2) -> ABin(Mul, step_a st a1, a2)


(* multistep_a: repeatedly apply step_a until a final value is reached. Return the integer corresponding to that value*)
let rec multistep_a (st: state) (expr: aexp) : int = match expr with
  | Nat n -> n
  | a -> multistep_a st (step_a st a)


(* step_b: evaluate a single step of a bexp according to the state st. Return the new bexp. *)
let rec step_b (st: state) (expr: bexp) : bexp =
  (* YOUR CODE HERE *)
  match expr with
  | BTrue -> BTrue
  | BFalse -> BFalse

  | Rel(r, Nat n1, Nat n2) ->
      begin
        match r with
        | Eq  -> if n1 = n2 then BTrue else BFalse
        | Neq -> if n1 <> n2 then BTrue else BFalse
        | Le  -> if n1 <= n2 then BTrue else BFalse
        | Gt  -> if n1 > n2 then BTrue else BFalse
      end
  | Rel (r, Nat n, a) ->
      Rel (r, Nat n, step_a st a)

  | Rel (r, a1, a2) ->
      Rel (r, step_a st a1, a2)

  | Not BTrue -> BFalse
  | Not BFalse -> BTrue
  | Not b -> Not (step_b st b)

  | And (BFalse, _) -> BFalse
  | And (BTrue, b) -> b
  | And (b1, b2) -> And (step_b st b1, b2)
  

(* multistep_a: repeatedly apply step_b until a final value is reached. Return the boolean corresponding to that value. *)
let rec multistep_b (st: state) (expr: bexp) : bool =
  (* YOUR CODE HERE *)
  match expr with
  | BTrue -> true
  | BFalse -> false
  | b -> multistep_b st (step_b st b)

(* step_b: evaluate a single step of a cmd according to the state st. Return the resulting state and the new command *)
let rec step_c (st: state) (cmd: cmd) : (state * cmd) =
  (* YOUR CODE HERE *)
  match cmd with
  | Skip ->
      (st, Skip)

  | Assign (x, Nat n) ->
      (set st x n, Skip)

  | Assign (x, a) ->
      (st, Assign (x, step_a st a))

  | Seq (Skip, c2) ->
      (st, c2)

  | Seq (c1, c2) ->
      let (st', c1') = step_c st c1 in
      (st', Seq (c1', c2))

  | If (BTrue, c1, c2) ->
      (st, c1)

  | If (BFalse, c1, c2) ->
      (st, c2)

  | If (b, c1, c2) ->
      (st, If (step_b st b, c1, c2))

  | While (b, c) ->
      (st, If (b, Seq (c, While (b, c)), Skip))

(* multistep_c: repeatedly apply step_c until there's nothing left to execute. Return the final state. *)
let rec multistep_c (st: state) (cmd: cmd) : state =
  (* YOUR CODE HERE *)
  match cmd with
  | Skip -> st
  | c ->
      let (st', c') = step_c st c in
      multistep_c st' c'
