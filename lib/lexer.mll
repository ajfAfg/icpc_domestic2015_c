{
type intermediate_token =
  | INTV of int
  | PLUS
  | MULT
  | NEWLINE
  | PERIOD of int
  | EOF
}

rule sub = parse
  | ['0'-'9']
    { INTV (int_of_string (Lexing.lexeme lexbuf)) }
  | '+'
    { PLUS }
  | '*'
    { MULT }
  | '\n'
    { NEWLINE }
  | '.'+
    { PERIOD (String.length @@ Lexing.lexeme lexbuf) }
  | eof
    { EOF }

{
let create () =
  let main' =
    let stack = Stack.create () in
    fun lexbuf ->
      match sub lexbuf with
      | PERIOD n -> (
          match Stack.top_opt stack with
          | Some m when n = m -> []
          | Some m when n > m ->
              Stack.push n stack;
              [ Parser.INPERIOD ]
          | None ->
              Stack.push n stack;
              [ Parser.INPERIOD ]
          | Some _m ->
              let tokens = ref [] in
              while n <> Stack.top stack do
                ignore @@ Stack.pop stack;
                tokens := Parser.DEPERIOD :: !tokens
              done;
              !tokens)
      | INTV n -> [ Parser.INTV n ]
      | PLUS -> [ Parser.PLUS ]
      | MULT -> [ Parser.MULT ]
      | NEWLINE -> [ Parser.NEWLINE ]
      | EOF ->
          let tokens = ref [] in
          while Stack.length stack <> 0 do
            ignore @@ Stack.pop stack;
            tokens := Parser.DEPERIOD :: !tokens
          done;
          !tokens @ [ Parser.EOF ]
  in

  let main'' =
    let pre_tokens = ref [] in
    let rec next_token lexbuf =
      match !pre_tokens with
      | x :: xs ->
          pre_tokens := xs;
          x
      | [] -> (
          match main' lexbuf with
          | x :: xs ->
              pre_tokens := xs;
              x
          | [] -> next_token lexbuf)
    in
    next_token
  in
  main''
}
