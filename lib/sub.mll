{
let stack = Stack.create ()

exception Eof
}

rule main = parse
  | (".")+
    {
      let n = String.length @@ Lexing.lexeme lexbuf in
      match Stack.top_opt stack with
        | Some m when n = m -> ""
        (* NOTE: INPERIOD *)
        | Some m when n > m ->
            Stack.push n stack;
            "("
        (* NOTE: INPERIOD *)
        | None ->
            Stack.push n stack;
            "("
        (* NOTE: DEPERIOD *)
        | Some m ->
            let rparens = ref "" in
            while n <> Stack.top stack do
              ignore @@ Stack.pop stack;
              rparens := !rparens ^ ")"
            done;
            !rparens
    }
  | eof
    { raise Eof }
  | _
    { Lexing.lexeme lexbuf }

{
let string_of_sub_lexbuf lexbuf =
  let rec string_of_sub_lexbuf' lexbuf =
    (* NOTE: `main lexbuf ^ string_of_sub_lexbuf' lexbuf` resulsts in a runtime error. *)
    let s = main lexbuf in
    try s ^ string_of_sub_lexbuf' lexbuf with Eof -> ""
  in
  string_of_sub_lexbuf' lexbuf
}
