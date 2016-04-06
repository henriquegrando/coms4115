(* Semantic tree generation for the DaMPL translator *)

open Ast
open Semt

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions) =
  (*raise( Failure( "not implemented" ));;*)

  (* Function declaration for named functions *)
  let built_in_decls =  StringMap.singleton "print"
   { rtyp = Void; fname = "print"; formals = [(String, "x")];
     locals = []; body = [] }
  in

  let function_decls = List.fold_left (fun m fd -> StringMap.add fd.fname fd m)
                       built_in_decls functions
  in

  let function_decl s = try StringMap.find s function_decls
     with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let check_function func =

    report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.fname)
      (List.map snd func.formals);

    report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.fname)
      (List.map snd func.locals);

      (* Return the type of an expression or raise an exception*)
      let rec expr = function
            SStrLit _ -> String
          | SCall(fname, actuals) as call -> let fd = function_decl fname in
           if List.length actuals != List.length fd.formals then
             raise (Failure ("expecting " ^ string_of_int
               (List.length fd.formals) ^ " arguments in " ^ string_of_expr call))
           else
             List.iter2 (fun (ft, _) e -> let et = expr e in
                ignore (check_assign ft et
                  (Failure ("illegal actual argument found " ^ string_of_typ et ^
                  " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))))
               fd.formals actuals;
             fd.typ
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
      in

      stmt (SBlock func.body)

  in
  List.iter check_function functions

