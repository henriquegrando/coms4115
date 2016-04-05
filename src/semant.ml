(* Semantic tree generation for the DaMPL translator *)

open Ast
open Semt

module StringMap = Map.Make(String)

(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions) =
  raise( Failure( "not implemented" ));;

(* Function declaration for named functions *)
let built_in_decls =  StringMap.add "print"
 { typ = Void; fname = "print"; formals = [(String, "x")];
   locals = []; body = [] }
in

let function_decls = List.fold_left (fun m fd -> StringMap.add fd.fname fd m)
                     built_in_decls functions
in

let function_decl s = try StringMap.find s function_decls
   with Not_found -> raise (Failure ("unrecognized function " ^ s))
in

let check_function func =

List.iter (check_not_void (fun n -> "illegal void formal " ^ n ^
  " in " ^ func.fname)) func.formals;

report_duplicate (fun n -> "duplicate formal " ^ n ^ " in " ^ func.fname)
  (List.map snd func.formals);

List.iter (check_not_void (fun n -> "illegal void local " ^ n ^
  " in " ^ func.fname)) func.locals;

report_duplicate (fun n -> "duplicate local " ^ n ^ " in " ^ func.fname)
  (List.map snd func.locals);

in 
    (* Return the type of an expression or raise an exception*)
    let rec expr = function
          StrLit _ -> String
        | Call(fname, actuals) as call -> let fd = function_decl fname in
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
          Block sl -> let rec check_block = function
               [Return _ as s] -> stmt s
             | Return _ :: _ -> raise (Failure "nothing may follow a return")
             | Block sl :: ss -> check_block (sl @ ss)
             | s :: ss -> stmt s ; check_block ss
             | [] -> ()
            in check_block sl
        | Expr e -> ignore (expr e)
    in

    stmt (Block func.body)

in
List.iter check_function functions

