open Ast
open Semt

module StringMap = Map.Make(String);;

open Stack

let built_in_decls = StringMap.singleton "print"
  { funid = -1; parsed = true; rtyp = Void; semfname = "print";
    semformals = [(String, "x")];
    semlocals = ref StringMap.empty; sembody = [] };;

let fun_decls = ref built_in_decls;;

let fun_abodies = ref StringMap.empty;;

let fun_count = ref 0;;

let fun_parser_stack = (Stack.create () : string Stack.t);;

let a = Stack.push "" fun_parser_stack;;


let get_id_typ_from_locals id fname =
  let semfdecl = StringMap.find fname !fun_decls in
  StringMap.find id !(semfdecl.semlocals);;

let get_obj_typ (o : sem_obj) : typ = match o with
    SId(id) ->
      let fname = (Stack.top fun_parser_stack) in
      if fname <> ""
      then get_id_typ_from_locals id fname
      else raise(Failure("var "^id^" not found, global var support to be implemented"))
  | _ -> raise(Failure("get_obj_typ case not implemented"))

let get_expr_typ (exp : sem_expr) : typ = match exp with (* TODO *)
    SLiteral(_) -> Int
  | SStrLit(_) -> String
  | SObj(o) -> get_obj_typ o
  | SCall(name,_) -> (StringMap.find name !fun_decls).rtyp
  | SNoexpr | _ -> Void
;; 

let rec get_typ_from_fun_sembody name body = match body with
    SReturn(exp)::l -> get_expr_typ exp
  | _::l -> get_typ_from_fun_sembody name l
  | [] -> Void;;

let rec validate_param_typs formals typs = match formals, typs with
   f::fl, t::tl -> ( (fst f) == t) && validate_param_typs fl tl
  | [], _::_ -> false
  | _::_, [] -> false
  | [], [] -> true;;

let rec generate_new_formals_and_locals oldformals typs =
  match oldformals, typs with
    oldformal::llst, t::tl ->
      let recval = generate_new_formals_and_locals llst tl in
      ( (t,snd oldformal)::(fst recval), StringMap.add (snd oldformal) t (snd recval) )
  | [], [] -> ([], StringMap.empty)
  | _, _ -> raise(Failure ( "generate_new_formals_and_locals error" ))
;;

let update_formal_typs_in_semfdecl (old : sem_func_decl) (typs : typ list) : sem_func_decl =
  let newformals, newlocals = generate_new_formals_and_locals old.semformals typs in 

  { old with
    semformals = newformals;
    semlocals = ref newlocals;
  }

let rec check_if_exists_in_stack stack str =
  if Stack.is_empty stack
  then false
  else
    if (Stack.pop stack) == str
    then true
    else check_if_exists_in_stack stack str;;

let rec parse_semfdecl semfdecl typs =
  if check_if_exists_in_stack (Stack.copy fun_parser_stack) semfdecl.semfname
  then () (* function already being parsed, do nothing *)
  else (
    Stack.push semfdecl.semfname fun_parser_stack;
    let newsemfdecl = update_formal_typs_in_semfdecl semfdecl typs in
    let abody = StringMap.find newsemfdecl.semfname !fun_abodies in
    fun_decls := StringMap.add newsemfdecl.semfname newsemfdecl !fun_decls;
    let newsembody = convert_stmts abody in 
    let newrtype = get_typ_from_fun_sembody semfdecl.semfname newsembody in
    if newrtype == Undefined then
    raise(Failure("cant determine fun "^semfdecl.semfname^" return type (mutual recursion?)"))
    else (
      let newnewsemfdecl = { newsemfdecl with
        sembody = newsembody;
        rtyp = newrtype;
        parsed = true;
      } in
      fun_decls := StringMap.add newnewsemfdecl.semfname newnewsemfdecl !fun_decls;
      ignore(Stack.pop fun_parser_stack);
      ()
    )
  )

and handle_scall (name : string) (typs : typ list) : unit =
  if (StringMap.mem name !fun_decls)
  then
    let semfdecl = StringMap.find name !fun_decls in
    if semfdecl.parsed then
      if (validate_param_typs semfdecl.semformals typs)
      then ()
      else raise(Failure ("fun "^name^" param types mismatch"))
    else
      if ( (List.length typs) == (List.length semfdecl.semformals) )
      then parse_semfdecl semfdecl typs
      else raise (Failure ("fun "^name^" call has wrong number of param"))
    (* ignore(check_if_call_expectations_match name semexprs) *)
  else
    raise( Failure ("fun "^name^" used but never declared"))
    (* fun_expectations := StringMap.add name (List.map get_expr_typ semexprs) !fun_expectations;; *)

and convert_obj (o : obj) : sem_obj = match o with
    Id(id) -> SId(id)
  | _ -> raise(Failure("convert_obj case not implemented"))

and convert_expr (exp : expr) : sem_expr = match exp with
    Literal(i) -> SLiteral(i)
  | StrLit(s) ->  SStrLit(s)
  | Call(s,lst) -> (let exprs = convert_exprs lst in
          (handle_scall s (List.map get_expr_typ exprs) );
          SCall(s,exprs) )
  | Obj(o) -> SObj(convert_obj o)
  | Noexpr -> SNoexpr
  | _ -> raise( Failure ("convert_expr case not implemented"))
and convert_exprs (exps : expr list) : sem_expr list = match exps with
    e :: l -> (convert_expr e) :: (convert_exprs l)
  | [] -> []

and convert_stmt stmt = match stmt with
    Block(lst) -> SBlock(convert_stmts lst)
  | Expr(exp) -> SExpr(convert_expr exp)
  | Return(exp) -> SReturn(convert_expr exp)
  | If(exp,s1,s2) -> SIf(convert_expr exp, convert_stmt s1, convert_stmt s2)
  | _ ->  raise( Failure ("convert_stmt case not implemented"))

and convert_stmts stmts = match stmts with
    s :: l -> (convert_stmt s) :: (convert_stmts l)
  | [] -> []
(*
and convert_stmt_ignoring_unparsed_call stmt = match stmt with
    Call(name,_) ->
      let semfdecl = StringMap.find name !fun_decls in
      if semfdecl.parsed
      then convert_stmt stmt
      else SIgnoredCall
  | _ -> convert_stmt stmt

  and convert_stmts_ignoring_unparsed_calls stmts = match stmts with
    s :: l -> (convert_stmt_ignoring_unparsed_call s) :: (convert_stmts_ignoring_unparsed_calls l)
  | [] -> [];;
*)

let convert_id_to_undef_typed_id (id : string) : typed_id = (Undefined, id);;

let rec convert_ids_to_undef_typed_ids (ids : string list) : typed_id list = match ids with
    id :: l -> (convert_id_to_undef_typed_id id) :: (convert_ids_to_undef_typed_ids l)
  | [] -> [];;

let create_fun_decl fd = 
  (* let body = convert_stmts fd.body in
  let rettyp = (get_typ_from_fun_sembody fd.fname body) in *)
  fun_abodies := StringMap.add fd.fname fd.body !fun_abodies;
  let semfdecl = { funid = (let id = !fun_count in (fun_count := !fun_count + 1); id);
   parsed = false;
   rtyp = Undefined;
   semfname = fd.fname;
   semformals = (convert_ids_to_undef_typed_ids fd.formals);
   semlocals = ref StringMap.empty;
   sembody = []; } in
  fun_decls := StringMap.add fd.fname semfdecl !fun_decls;
  ();;

let rec create_funs_from_decls decls = match decls with
    Func(f_decl)::l -> create_fun_decl f_decl; create_funs_from_decls l
  | Tup(_)::l -> create_funs_from_decls l
  | [] -> ();;

let string_of_typ = function
    Bool -> "Bool"
  | Int -> "Int"
  | Float -> "Float"
  | Void -> "Void"
  | Undefined -> "Undefined"
  | _ -> "unknown";;

let rec remove_formals_from_locals formals map = match formals with
  | f::lst -> StringMap.remove (snd f) (remove_formals_from_locals lst map)
  | [] -> map;;

let map_to_list_fold_helper k v l =
  (* print_string ("function: "^(string_of_typ v.rtyp)^" "^v.semfname^"\n" ); *)
  v.semlocals := remove_formals_from_locals v.semformals !(v.semlocals);
  if (v.funid == -1 || not v.parsed) then l else v::l;;

let convert (stmts, decls) =
  create_funs_from_decls decls;
  let semstmts = convert_stmts stmts in
  (
    List.rev (semstmts),
    (StringMap.fold map_to_list_fold_helper !fun_decls []),
    []
  );;


