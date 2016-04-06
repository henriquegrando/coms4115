open Ast
open Semt

module StringMap = Map.Make(String);;

let built_in_decls = StringMap.singleton "print"
   { rtyp = Void; semfname = "print"; semformals = [(String, "x")];
     semlocals = []; sembody = [] };;

let fun_decls = ref built_in_decls;;

type id_typ = Variable | Function

let get_expr_typ exp = Void;; (* TODO *)

let rec convert_expr exp = match exp with
    StrLit(s) ->  SStrLit(s)
  | Call(s,lst) -> if (StringMap.mem s !fun_decls)
          then SCall(s,convert_exprs lst)
          else raise (Failure ("fun "^s^" not defined"))
  | _ -> raise( Failure ("convert_expr case not implemented"))
and convert_exprs exps = match exps with
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
  


let convert_fun_decl fd = 
  let body = convert_stmts fd.body in
  let rettyp = (get_typ_from_fun_sembody fd.fname body) in
  let return = { rtyp = if (rettyp == Undefined)  
          then raise(Failure("fun "^fd.fname^" has Undefined return"))
          else rettyp;
   semfname = fd.fname;
   semformals = (convert_ids_to_undef_typed_ids fd.formals);
   semlocals = (convert_ids_to_undef_typed_ids fd.locals);
   sembody = body; } in
  ignore(if StringMap.mem fd.fname !fun_decls then raise (Failure("cant redeclare "^fd.fname)) );
  fun_decls := StringMap.add fd.fname return !fun_decls;
  return;;

let rec convert_funs_from_decls decls = match decls with
    Func(f_decl)::l -> (convert_fun_decl f_decl) :: (convert_funs_from_decls l)
  | Tup(_)::l -> (convert_funs_from_decls l)
  | [] -> [];;

let convert (stmts, decls) =
  let fun_att = convert_funs_from_decls decls in
  (convert_stmts stmts,fun_att,[]);;


