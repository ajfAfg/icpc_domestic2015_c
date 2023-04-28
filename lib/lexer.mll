{
let stack = Stack.create ()
}

rule sub = parse
  | ['0'-'9']
    { [ Parser.INTV (int_of_string (Lexing.lexeme lexbuf)) ] }
  | '+'
    { [ Parser.PLUS ] }
  | '*'
    { [ Parser.MULT ] }
  | '\n'
    { [ Parser.NEWLINE ] }
  | '.'+
    {
      let n = String.length @@ Lexing.lexeme lexbuf in
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
          !tokens
    }
  | eof
    {
      let tokens = ref [] in
      while Stack.length stack <> 0 do
        ignore @@ Stack.pop stack;
        tokens := Parser.DEPERIOD :: !tokens
      done;
      !tokens @ [ Parser.EOF ]
    }

{
let create () =
  let pre_tokens = ref [] in
  let rec next_token lexbuf =
    match !pre_tokens with
    | x :: xs ->
        pre_tokens := xs;
        x
    | [] -> (
        match sub lexbuf with
        | x :: xs ->
            pre_tokens := xs;
            x
        | [] -> next_token lexbuf)
  in
  next_token
}
