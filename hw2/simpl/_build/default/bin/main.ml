(* main.ml *)
let parse_from_channel (ic : in_channel) : Simpl.Ast.cmd =
  let lexbuf = Lexing.from_channel ic in
  try
    Simpl.Parser.program Simpl.Lexer.token lexbuf
  with
  | Simpl.Lexer.Lexing_error msg ->
      let p = Lexing.lexeme_start_p lexbuf in
      failwith (Printf.sprintf "Lexer error at %d:%d: %s"
                  p.pos_lnum (p.pos_cnum - p.pos_bol) msg)
  | Simpl.Parser.Error ->
      let p = Lexing.lexeme_start_p lexbuf in
      failwith (Printf.sprintf "Parse error at %d:%d near '%s'"
                  p.pos_lnum (p.pos_cnum - p.pos_bol) (Lexing.lexeme lexbuf))

let () =
  if Array.length Sys.argv <> 2 then (
    prerr_endline "usage: simpl <file>";
    exit 2
  );
  let ic = open_in Sys.argv.(1) in
  let cmd = parse_from_channel ic in
  close_in ic;

  (* initial empty state *)
  let st0 = Simpl.Eval.empty_state in
  (* invoke eval_c *)
  let _st_final = Simpl.Eval.eval_c st0 cmd in
  ()