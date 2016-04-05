(* Semantic tree generation for the DaMPL translator *)

open Ast
open Semt

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions) =
  raise( Failure( "not implemented" ));;