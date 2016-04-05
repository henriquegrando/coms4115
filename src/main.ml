open Ast
open Parser
open Semt


  let lexbuf = Lexing.from_channel stdin in
  let rec loop acc =  function
      | EOF   ->  string_of_token EOF :: acc |> List.rev
      | x     ->  loop (string_of_token x :: acc) (Scanner.token lexbuf)
  in
      loop [] (Scanner.token lexbuf) 
      |> String.concat " " 
      |> print_endline
