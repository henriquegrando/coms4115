open Ast
open Semt
open Stack
module StringMap = Map.Make(String);;
open Builtin

let param_separator = "__"

let fun_decls = ref StringMap.empty;;

let fun_abodies = ref StringMap.empty;;

let globals = ref StringMap.empty;;

let funs_to_reparse = ref [];;

let fun_parser_stack = (Stack.create () : string Stack.t);;

let tup_decls = ref StringMap.empty;;

let string_of_param_typ = function
    Bool -> "bool"
  | Int -> "int"
  | Float -> "float"
  | String -> "str"
  | Void -> "void"
  | Undefined -> raise(Failure("Undefined param on string_of_param_typ"))
  | _ -> raise(Failure("string_of_param_typ case not implemented"))

let get_built_in_name_folder map fun_prot =
  StringMap.add (get_built_in_name fun_prot) true map;;

let built_in_decls =
  List.fold_left get_built_in_name_folder StringMap.empty built_in_prototypes;;

let generate_fun_name (name : string) (typs: typ list) : string = 
  name^param_separator^(String.concat "_" (List.map string_of_param_typ typs))

let built_in_prot_map_folder map fun_prot =
  let build_formal ftyp = (ftyp,"x") in
  let build_formals typlist = List.map build_formal typlist in
  let rec build_prot_map rtyp name protlist mmap = match protlist with
      prot::l -> 
        let funname = generate_fun_name name prot in
        let semfdecl = {
          rtyp = rtyp; semfname = funname;
          originalname = name; semformals = build_formals prot;
          semlocals = ref StringMap.empty; sembody = [];
        } in StringMap.add funname semfdecl (build_prot_map rtyp name l mmap)
    | [] -> mmap
  in build_prot_map (get_built_in_rtyp fun_prot) (get_built_in_name fun_prot)
    (get_built_in_formals fun_prot) map;;


let parsed_funs = ref 
  (List.fold_left built_in_prot_map_folder StringMap.empty built_in_prototypes);;

let is_logical_op = function
  | Equal | Neq | Less | Leq | Greater | Geq | And | Or -> true
  | _ -> false

let pv k v = print_string("\nvar: "^k);;

let get_id_typ_from_locals id fname = 
  let semfdecl = StringMap.find fname !parsed_funs in
  StringMap.find id !(semfdecl.semlocals);;

let get_string_of_sem_obj semobj = match semobj with
    SId(id) -> id
  | _ -> raise(Failure("get_string_of_sem_obj case not implemented"))


let get_obj_typ (o : sem_obj) : typ = match o with
    SId(id) -> (* print_string(id); print_string(Stack.top fun_parser_stack); *)
      let fname = (Stack.top fun_parser_stack) in
      if fname <> "_global_"
      then get_id_typ_from_locals id fname
      else raise(Failure("var "^id^" not found, global var support to be implemented"))
  | _ -> raise(Failure("get_obj_typ case not implemented"))

let get_expr_typ (exp : sem_expr) : typ = match exp with (* TODO *)
    SLiteral(_) -> Int
  | SStrLit(_) -> String
  | SFloatLit(_) -> Float
  | SBoolLit(_) -> Bool
  | SObj(o) -> get_obj_typ o
  | SBinop(t,_,_,_) -> t
  | SUnop(t,_,_) -> t
  | SCall(name,_) -> (StringMap.find name !parsed_funs).rtyp
  | STupInst(tupname) -> Tuple(tupname)
  | STabInst(tupname) -> Table(tupname)
  | SNoexpr | _ -> Void
;; 

(* TODO: improve this function *)
let rec get_typ_from_fun_sembody name body = match body with
    SReturn(exp)::l ->
      let rettyp = get_expr_typ exp in
      if rettyp == Undefined then
      get_typ_from_fun_sembody name l
      else if rettyp == Void then
      raise(Failure("fun "^name^": cant return void"))
      else rettyp
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

let update_formal_typs_in_semfdecl (newname: string) (old : sem_func_decl) (typs : typ list) : sem_func_decl =
  let newformals, newlocals = generate_new_formals_and_locals old.semformals typs in 
  { old with
    semfname = newname;
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

let add_id_to_map mapref semobj expr_typ =
  (* print_string("adding "^(get_string_of_sem_obj semobj)); *)
  mapref := StringMap.add (get_string_of_sem_obj semobj) expr_typ !mapref;
  (* (StringMap.iter pv !mapref); *)
  ()

let rec parse_semfdecl newname semfdecl typs =
  let callername = Stack.top fun_parser_stack in
  if check_if_exists_in_stack (Stack.copy fun_parser_stack) semfdecl.semfname
  then (* function already being parsed, so reparse caller later *)
    (funs_to_reparse := callername :: (!funs_to_reparse) )
  else (
    Stack.push newname fun_parser_stack;
    let newsemfdecl = update_formal_typs_in_semfdecl newname semfdecl typs in
    (* the part below is copied to check_if_fun_needs_reparse *)
    (* so any changes made here must be also done there *)
    let abody = StringMap.find semfdecl.semfname !fun_abodies in
    parsed_funs := StringMap.add newsemfdecl.semfname newsemfdecl !parsed_funs;
    let newsembody = convert_stmts abody in 
    let newrtype = get_typ_from_fun_sembody newsemfdecl.semfname newsembody in
    if newrtype == Undefined then (
    ignore(Stack.pop fun_parser_stack);
    (funs_to_reparse := (newsemfdecl.semfname) :: (!funs_to_reparse) )
    ) else (
      let newnewsemfdecl = { newsemfdecl with
        sembody = newsembody;
        rtyp = newrtype;
      } in
      parsed_funs := StringMap.add newnewsemfdecl.semfname newnewsemfdecl !parsed_funs;
      ignore(Stack.pop fun_parser_stack);
      ()
    )
  )


and handle_scall (name : string) (typs : typ list) : string =
  let newname = generate_fun_name name typs in (
    if (StringMap.mem newname !parsed_funs)
    then ()
    else (
      if (StringMap.mem name built_in_decls) then
      raise(Failure("builtin fun "^name^" does not accept such params"))
      else
        if StringMap.mem name !fun_decls then (
          let semfdecl = StringMap.find name !fun_decls in
          if ( (List.length typs) == (List.length semfdecl.semformals) )
          then parse_semfdecl newname semfdecl typs
          else raise (Failure ("fun "^name^" call has wrong number of param"))
        ) else raise( Failure ("fun "^name^" used but never declared"))
    )
  ); newname

and convert_obj (o : obj) : sem_obj = match o with
    Id(id) -> SId(id)
  | _ -> raise(Failure("convert_obj case not implemented"))

(*
and str_of_obj = function
Id(s) -> s
*)

and convert_expr (exp : expr) : sem_expr = match exp with
    Literal(i) -> SLiteral(i)
  | StrLit(s) ->  SStrLit(s)
  | FloatLit(f) -> SFloatLit(f)
  | BoolLit(b) -> SBoolLit(b)
  | Assign(o,e) -> convert_assign o e
  | Binop(e1,op,e2) -> 
    let seme1 = convert_expr e1 in let seme2 = convert_expr e2 in
    if is_logical_op op
    then raise(Failure("logical op not implemented"))
    else let e1typ = get_expr_typ seme1 in let e2typ = get_expr_typ seme2 in
      if e1typ = String then 
        if e2typ = String && op = Add
        then SBinop(String,seme1,op,seme2)
        else raise(Failure("Invalid string operation"))
      else if e2typ = String then 
        if e1typ = String && op = Add
        then SBinop(String,seme1,op,seme2)
        else raise(Failure("Invalid string operation"))
      else if e1typ = Bool || e2typ = Bool
        then raise(Failure("logical expression inside arithmetic expression"))
      else
        let resulttyp = if e1typ = Float || e2typ = Float
          then Float else Int in
        SBinop(resulttyp,seme1,op,seme2)
  | Call(s,lst) -> ( (* (print_string("_"^s^"_in "^(Stack.top fun_parser_stack)^"\n"); *)
          let exprs = convert_exprs lst in 
          let typs = (List.map get_expr_typ exprs) in
          let funname = (handle_scall s typs ) in
          SCall(funname,exprs) )
  | Obj(o) -> SObj(convert_obj o)
  | TupInst(tup) -> (
      if StringMap.mem tup !tup_decls
      then STupInst(tup)
      else raise(Failure("tuple"^tup^" never declared"))
    )
  | TabInst(tup) -> (
      if StringMap.mem tup !tup_decls
      then STabInst(tup)
      else raise(Failure("tuple"^tup^" never declared"))
    )
  | Noexpr -> SNoexpr
  | _ -> raise( Failure ("convert_expr case not implemented"))

and convert_exprs exps = (List.map convert_expr exps)


and convert_stmt stmt = match stmt with
    Block(lst) -> SBlock(convert_stmts lst)
  | Expr(exp) -> (* print_string("E_in "^(Stack.top fun_parser_stack)^"\n"); *)
      SExpr(convert_expr exp)
  | Return(exp) -> (* print_string("R_in "^(Stack.top fun_parser_stack)^"\n"); *)
      SReturn(convert_expr exp)
  | If(exp,s1,s2) -> SIf(convert_expr exp, convert_stmt s1, convert_stmt s2)
  | _ ->  raise( Failure ("convert_stmt case not implemented"))

and convert_stmts stmts = (List.map convert_stmt stmts)


and convert_assign o e = (
  (* print_string("converting "^(get_string_of_sem_obj (convert_obj o) )^"\n"); *)
  let semexpr = convert_expr e in
  let semobj = convert_obj o in
  let expr_typ = (get_expr_typ semexpr) in
  if (Stack.top fun_parser_stack) = "_global_"
  then (
    if StringMap.mem (get_string_of_sem_obj semobj) !globals
    (* outside function, global environment *)
    then (
      let expectedtyp = StringMap.find (get_string_of_sem_obj semobj) !globals in
      if expectedtyp == get_expr_typ semexpr || (expectedtyp = Float && (get_expr_typ semexpr) = Int)
        then SAssign(expr_typ,semobj, semexpr)
      else if (expectedtyp = Int && expr_typ = Float)
        then ( add_id_to_map globals semobj expr_typ;
        SAssign(Float,semobj, semexpr) )
      else raise(Failure("cant change global "^(get_string_of_sem_obj semobj)^" type"))
    ) else ( add_id_to_map globals semobj expr_typ;
    SAssign(expr_typ,semobj, semexpr)
    )
  ) else (
    (* inside function, local environment *)
    let semfdecl = StringMap.find (Stack.top fun_parser_stack) !parsed_funs in
    if StringMap.mem (get_string_of_sem_obj semobj) !(semfdecl.semlocals)
    (* check if it is a local variable *)
    then (
      let expectedtyp = StringMap.find (get_string_of_sem_obj semobj) !(semfdecl.semlocals) in
      if expectedtyp == get_expr_typ semexpr || (expectedtyp = Float && expr_typ = Int)
        then SAssign(expr_typ,semobj, semexpr)
      else if (expectedtyp = Int && expr_typ = Float)
        then ( (add_id_to_map (semfdecl.semlocals) semobj expr_typ);
        SAssign(Float,semobj, semexpr) )
      else raise(Failure("cant change var "^(get_string_of_sem_obj semobj)^" type"))
    ) else (
      (* check if it is a global *)
      if StringMap.mem (get_string_of_sem_obj semobj) !globals
      then (
        let expectedtyp = StringMap.find (get_string_of_sem_obj semobj) !globals in
        if expectedtyp == get_expr_typ semexpr  || (expectedtyp = Float && expr_typ = Int)
          then SAssign(expr_typ,semobj, semexpr)
        else if (expectedtyp = Int && expr_typ = Float)
          then (add_id_to_map globals semobj expr_typ;
          SAssign(Float,semobj, semexpr) )
        else raise(Failure("cant change global "^(get_string_of_sem_obj semobj)^" type"))
        (* if not local or global, create new local var *)
      ) else ( add_id_to_map (semfdecl.semlocals) semobj expr_typ;
      SAssign(expr_typ,semobj, semexpr)
      )
    )
  )
)
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
  let semfdecl = {
   rtyp = Undefined;
   semfname = fd.fname;
   originalname = fd.fname;
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

let fun_map_to_list_fold_helper k v l =
  (* print_string ("function: "^(string_of_typ v.rtyp)^" "^v.semfname^"\n" ); *)
  v.semlocals := remove_formals_from_locals v.semformals !(v.semlocals);
  if ( StringMap.mem v.originalname built_in_decls) then l else v::l;;

let globals_map_to_list_fold_helper k v l = (v,k)::l

(*
let reparse_fun2 name =
  Stack.push name fun_parser_stack;
  let semfdecl = StringMap.find name !fun_decls in
  let abody = StringMap.find name !fun_abodies in
  let newsembody = convert_stmts abody in
  let newrtype = get_typ_from_fun_sembody semfdecl.semfname newsembody in
  if newrtype == Undefined then
  raise(Failure("could not determine fun "^name^" return type"))
  else (
    let newnewsemfdecl = { semfdecl with
      sembody = newsembody;
      rtyp = newrtype;
    } in
    fun_decls := StringMap.add newnewsemfdecl.semfname newnewsemfdecl !fun_decls;
    ignore(Stack.pop fun_parser_stack);
    ()
  )
*)


let reparse_fun name =
  Stack.push name fun_parser_stack;
  let semfdecl = StringMap.find name !parsed_funs in
  let abody = StringMap.find semfdecl.originalname !fun_abodies in
  let newsembody = convert_stmts abody in 
  let newrtype = get_typ_from_fun_sembody semfdecl.originalname newsembody in
  if newrtype == Undefined then (
  ignore(Stack.pop fun_parser_stack);
  raise(Failure("could not determine fun "^name^" return type"))
  ) else (
    let newnewsemfdecl = { semfdecl with
      sembody = newsembody;
      rtyp = newrtype;
    } in
    parsed_funs := StringMap.add newnewsemfdecl.semfname newnewsemfdecl !parsed_funs;
    ignore(Stack.pop fun_parser_stack);
    ()
  )

let create_tup_decl tdecl =
  let create_tup_item inx item = 
    (tup_decls := StringMap.add (fst tdecl) (Tuple("")) !tup_decls);
    (tup_decls := StringMap.add ((fst tdecl)^"$"^(snd item)) (fst item) !tup_decls);
    (tup_decls := StringMap.add ((fst tdecl)^"$"^(string_of_int inx)) (fst item) !tup_decls);
    () 
  in List.iteri create_tup_item (snd tdecl) ;;

let create_tups_from_decls decls = match decls with
    Func(_)::l -> create_funs_from_decls l
  | Tup(t)::l -> create_tup_decl t; create_funs_from_decls l
  | [] -> ();;


let convert (stmts, decls) =
  create_tups_from_decls decls;
  (Stack.push "_global_" fun_parser_stack);
  create_funs_from_decls decls;
  let semstmts = convert_stmts stmts in
  (List.iter print_string !funs_to_reparse); 
  (List.iter reparse_fun !funs_to_reparse);
  (
    (StringMap.fold globals_map_to_list_fold_helper !globals []),
    List.rev (semstmts),
    (StringMap.fold fun_map_to_list_fold_helper !parsed_funs []),
    []
  );;


