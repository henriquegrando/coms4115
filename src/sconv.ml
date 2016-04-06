open Ast
open Semt

module StringMap = Map.Make(String);;

let built_in_decls = StringMap.singleton "print"
  { parsed = true; rtyp = Void; semfname = "print";
    semformals = [(String, "x")];
    semlocals = ref StringMap.empty; sembody = [] };;

let fun_decls = ref built_in_decls;;

let fun_abodies = ref StringMap.empty;;

(* type id_typ = Variable | Function *)

let get_expr_typ (exp : sem_expr) : typ = match exp with (* TODO *)
    SStrLit(_) -> String
  | _ -> Void
;; 



(*
let rec validate_expectation_list expectlst exprs = match expectlst, exprs with
    expect::elst, expr::exprlst -> (expect == (get_expr_typ expr)) && validate_expectation_list elst exprlst
  | [], a::_ -> false
  | a::_, [] -> false
  | [], [] -> true;;

let check_if_call_expectations_match (name : string) (exprs : sem_expr list) : unit =
  let expectlst = StringMap.find name !fun_expectations in
  (if not (validate_expectation_list expectlst exprs)
    then raise(Failure("call mismatch for "^name)) );;
*)

let validate_scall (name : string) (semexprs : typ list) : unit =
  if (StringMap.mem name !fun_decls)
  then
    ignore(check_if_call_expectations_match name semexprs)
  else
    raise( Failure ("fun "^name^" used but not declared"))
    (* fun_expectations := StringMap.add name (List.map get_expr_typ semexprs) !fun_expectations;; *)

let rec convert_expr (exp : expr) : sem_expr = match exp with
    StrLit(s) ->  SStrLit(s)
  | Call(s,lst) -> (let exprs = convert_exprs lst in
          (validate_scall s (List.map get_expr_typ exprs) );
          SCall(s,exprs) )
  | _ -> raise( Failure ("convert_expr case not implemented"))
and convert_exprs (exps : expr list) : sem_expr list = match exps with
    e :: l -> (convert_expr e) :: (convert_exprs l)
  | [] -> [];;

let rec convert_stmt stmt = match stmt with
    Block(lst) -> SBlock(convert_stmts lst)
  | Expr(exp) -> SExpr(convert_expr exp)
  | Return(exp) -> SReturn(convert_expr exp)
  | If(exp,s1,s2) -> SIf(convert_expr exp, convert_stmt s1, convert_stmt s2)
  | _ ->  raise( Failure ("convert_stmt case not implemented"))

and convert_stmts stmts = match stmts with
    s :: l -> (convert_stmt s) :: (convert_stmts l)
  | [] -> [];;


let convert_id_to_undef_typed_id (id : string) : typed_id = (Undefined, id);;

let rec convert_ids_to_undef_typed_ids (ids : string list) : typed_id list = match ids with
    id :: l -> (convert_id_to_undef_typed_id id) :: (convert_ids_to_undef_typed_ids l)
  | [] -> [];;

let rec get_typ_from_fun_sembody name body = match body with
    SReturn(exp)::l -> get_expr_typ exp
  | _::l -> get_typ_from_fun_sembody name l
  | [] -> Void;;
  
(* let convert_ids_to_semlocals *)

(*
let convert_fun_decl fd = 
  let body = convert_stmts fd.body in
  let rettyp = (get_typ_from_fun_sembody fd.fname body) in
  let return = { parsed = false;
   rtyp = if (rettyp == Undefined)
          then raise(Failure("fun "^fd.fname^" has Undefined return"))
          else rettyp;
   semfname = fd.fname;
   semformals = (convert_ids_to_undef_typed_ids fd.formals);
   semlocals = ref StringMap.empty;
   sembody = body; } in
  (* ignore(if StringMap.mem fd.fname !fun_decls then raise (Failure("cant redeclare "^fd.fname)) ); *)
  fun_decls := StringMap.add fd.fname return !fun_decls;
  return;;
*)

let create_fun_decl fd = 
  (* let body = convert_stmts fd.body in
  let rettyp = (get_typ_from_fun_sembody fd.fname body) in *)
  fun_abodies := StrignMap.add fd.fname fd.body !fun_abodies;
  let semfdecl = { parsed = false;
   rtyp = Undefined;
   semfname = fd.fname;
   semformals = (convert_ids_to_undef_typed_ids fd.formals);
   semlocals = ref StringMap.empty;
   sembody = []; } in
  fun_decls := StringMap.add fd.fname semfdecl !fun_decls;
  ();;

let create_funs_from_decls decls = match decls with
    Func(f_decl)::l -> create_fun_decl f_decl; create_funs_from_decls l
  | Tup(_)::l -> create_funs_from_decls l
  | [] -> ();;

(*
let rec convert_funs_from_decls decls = match decls with
    Func(f_decl)::l -> (convert_fun_decl f_decl) :: (convert_funs_from_decls l)
  | Tup(_)::l -> (convert_funs_from_decls l)
  | [] -> [];;
*)

let convert (stmts, decls) =
  create_funs_from_decls;
  (*let fun_att = convert_funs_from_decls decls in*)
  (* TODO: get fdecls from map and create a list to be returned *)
  (convert_stmts stmts,[],[]);;


