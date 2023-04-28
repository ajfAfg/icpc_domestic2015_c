let apply_prim op args =
  match op with
  (* NOTE: `args` is ensured not to be an empty list (See `parser.mll`). *)
  | Syntax.Plus -> List.fold_left ( + ) (List.hd args) (List.tl args)
  | Mult -> List.fold_left ( * ) (List.hd args) (List.tl args)

let rec eval = function
  | Syntax.ILit i -> i
  | Op (op, exps) -> List.map eval exps |> apply_prim op
