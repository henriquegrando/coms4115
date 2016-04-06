open Ast
open Parser
open Semt




let _ =
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in
  let semt = Sconv.convert ast in
  print_string (Codegen.string_of_program semt);;