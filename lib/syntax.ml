type op = Plus | Mult
type exp = ILit of int | Op of op * exp list
