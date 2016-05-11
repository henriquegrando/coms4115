open Ast
open Parser
open Semt

(* let already_included = ref [] *)

let remove_quotes str =
  String.sub str 1 ((String.length str)-2)

let get_file_from_include incl = match incl with
    StdIncl(name) -> ""
  | FileIncl(f) -> remove_quotes f

let rec join_ast_list l = match l with
    a::tl -> let rec_call = join_ast_list tl in
      ((fst a)@(fst rec_call),(snd a)@(snd rec_call))
  | [] -> ([],[])

let rec get_program_from_include incl = 
  let filename = get_file_from_include incl in
  let file = Pervasives.open_in filename in
  let lexbuf = Lexing.from_channel file in
  let includes,ast = Parser.program Scanner.token lexbuf in
  join_ast_list ((List.map get_program_from_include includes)@[ast])
  
let _ =
  let lexbuf = Lexing.from_channel stdin in
  let includes,ast = Parser.program Scanner.token lexbuf in
  let complete_ast = join_ast_list ((List.map get_program_from_include includes)@[ast]) in
  let semt = Sconv.convert complete_ast in
  print_string (Codegen.string_of_program semt);;

