open Icpc_domestic2015_c

let rec read_input () =
  let n = read_line () |> int_of_string in
  if n = 0 then []
  else
    let v =
      List.init n (fun _ -> read_line ())
      |> String.concat "\n"
      (* NOTE:
          To simplify the grammar definition,
          a newline is inserted at the end of the input string.
      *)
      |> Fun.flip ( ^ ) "\n"
    in
    v :: read_input ()

let () =
  read_input ()
  |> List.map (fun exp_str ->
         exp_str |> Lexing.from_string
         |> Parser.exp (Lexer.create ())
         |> Eval.eval)
  |> List.map string_of_int |> String.concat "\n" |> print_endline
