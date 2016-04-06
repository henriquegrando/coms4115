(* Semantic tree generation for the DaMPL translator *)
(*
open Ast
open Semt

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)
(*

let check (statements, functions, tuples) =

  (*raise( Failure( "not implemented" ));;*)

  (* Raise an exception if the given list has a duplicate *)
  let report_duplicate exceptf list =
    let rec helper = function
  n1 :: n2 :: _ when n1 = n2 -> raise (Failure (exceptf n1))
      | _ :: t -> helper t
      | [] -> ()
    in helper (List.sort compare list)
  in

  (* Function declaration for named functions *)
  let built_in_decls =  StringMap.singleton "print"
   { rtyp = Void; semfname = "print"; semformals = [(String, "x")];
     semlocals = []; sembody = [] }
  in

  let function_decls = List.fold_left (fun m fd -> StringMap.add fd.semfname fd m)
                       built_in_decls functions
  in

  let function_decl s = try StringMap.find s function_decls
     with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let check_function func =

    report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.semfname)
      (List.map snd func.semformals);

    report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.semfname)
      (List.map snd func.semlocals);

      (* Return the type of an expression or raise an exception*)
      let rec expr = function
            SStrLit _ -> String
          | SCall(fname, actuals) -> let fd = function_decl fname in
           if List.length actuals != List.length fd.semformals then
             raise (Failure ("expecting " ^ string_of_int
               (List.length fd.semformals) ^ " arguments in " ))
           else
             fd.rtyp
          | _ -> raise( Failure( "not implemented" ))
      in

      (* Verify a statement or throw an exception *)
      let rec stmt = function
            SBlock sl -> let rec check_block = function
                 [SReturn _ as s] -> stmt s
               | SReturn _ :: _ -> raise (Failure "nothing may follow a return")
               | SBlock sl :: ss -> check_block (sl @ ss)
               | s :: ss -> stmt s ; check_block ss
               | [] -> ()
              in check_block sl
          | SExpr e -> ignore (expr e)
          | _ -> raise( Failure( "not implemented" ))
      in

      stmt (SBlock func.sembody)

  in
  List.iter check_function functions

*)
