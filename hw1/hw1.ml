(*Copyright Rowan Sharwood 2026*)

(*Part 1: Fibonacci*)
let rec fibonacci n =
  if n = 1 then 1
  else if n = 2 then 1
  else fibonacci (n - 1) + fibonacci (n - 2);;
(*Part 2 List Length*)
let rec list_length li =
  match li with
  | [] -> 0
  | _::t -> 1 + list_length t;;
