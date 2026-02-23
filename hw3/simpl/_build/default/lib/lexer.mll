{
  open Parser

  exception Lexing_error of string

  let keyword (s : string) : token option =
    match s with
    | "skip"  -> Some SKIP
    | "if"    -> Some IF
    | "then"  -> Some THEN
    | "else"  -> Some ELSE
    | "end"   -> Some END
    | "while" -> Some WHILE
    | "do"    -> Some DO
    | "true"  -> Some TRUE
    | "false" -> Some FALSE
    | "not"   -> Some NOT        (* ASCII alternative to ¬ *)
    | _ -> None
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z' '_']
let ident = alpha (alpha | digit)*

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }

  (* Comments: OCaml style *)
  | "(*" { comment lexbuf; token lexbuf }

  (* Multi-char operators first *)
  | ":=" { ASSIGN }
  | "&&" { ANDAND }
  | "<=" { LE }     (* ASCII alternative to ≤ *)
  | "!=" { NEQ }    (* ASCII alternative to ≠ *)

  (* Unicode single-char operators (UTF-8 literals) *)
  | "≤"  { LE }
  | "≠"  { NEQ }
  | "~"  { NOT }
  | "×"  { TIMES }

  (* Single-char tokens *)
  | ";"  { SEMI }
  | "("  { LPAREN }
  | ")"  { RPAREN }

  | "+"  { PLUS }
  | "-"  { MINUS }
  | "*"  { TIMES }  (* accept '*' as alternative to × *)
  | "="  { EQ }
  | ">"  { GT }

  (* Identifiers / keywords *)
  | ident as s {
      match keyword s with
      | Some kw -> kw
      | None -> IDENT s
    }

  (* Naturals *)
  | digit+ as n { NAT (int_of_string n) }

  | eof { EOF }

  | _ as c {
      raise (Lexing_error (Printf.sprintf "Unexpected character: %C" c))
    }

and comment = parse
  | "*)" { () }
  | eof  { raise (Lexing_error "Unterminated comment") }
  | _    { comment lexbuf }
