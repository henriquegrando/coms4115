(* Code generation: translate takes a semantically checked Semantic ST and
produces C

*)

open Ast

open Semt

module StringMap = Map.Make(String)

let simple_string_of_typ = function
    Bool -> "int"
  | Int -> "int"
  | Float -> "float"
  | Void -> "void"
  | String -> "str"
  | Array(_) -> "arr"
  | Table(_) -> "arr"
  | Tuple(_) -> "tup"
  | _ -> raise(Failure("simple_string_of_typ failure"))

let string_of_typ = function
    Bool -> "int"
  | Int -> "int"
  | Float -> "float"
  | Void -> "void"
  | String -> "String"
  | Array(_) -> "Array"
  | Table(_) -> "Array"
  | Undefined -> raise(Failure("Undefined type on string_of_typ"))
  (*
  
  
  | Tuple of string
  | Table of string
  | Array of typ
 *)
  | _ -> raise ( Failure( "string_of_typ case not implemented" ))

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "&&"
  | Or -> "||"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"

let set_or_insert t =
  if t then "insert" else "set"

let empty_inx = SString("INT_MIN")

let rec string_of_obj = function
    SId(s) -> "dampl_" ^ s
  | SBrac(o,e,_,t) -> "dampl_arr_get__" ^ simple_string_of_typ t ^ "("
      ^ string_of_obj o ^ "," ^ string_of_expr e ^ ")"
  | SBrac2(o,e1,e2,t) ->
      let e1 = if e1 = SNoexpr then empty_inx else e1 in
      let e2 = if e2 = SNoexpr then empty_inx else e2 in
      "dampl_arr_get_range__arr(" ^ string_of_obj o ^ ","
      ^ string_of_expr e1 ^ "," ^ string_of_expr e2 ^ ")"
  | _ -> raise ( Failure( "string_of_obj case not implemented" ))
 (* | SAttr(otyp,atyp,o,name,inx) -> (match otyp with
        Tuple(tname) -> 
    ) *)
  (*
  | SBrac of string * sem_expr (* a[0] a[i] a[i+1] *)
  | SBrac2 of string * sem_expr * sem_expr (* a[0:2] *)
  | SAttr of string * string (* a$b *)
  *)

and string_of_expr = function
    SLiteral(l) -> string_of_int l
  | SBoolLit(true) -> "1"
  | SBoolLit(false) -> "0"
  | SFloatLit(f) -> string_of_float f
  | SStrLit(s) -> s
  | SObj(o) -> string_of_obj o
  | SBinop(t, e1, o, e2) -> ( match t with
        String -> "dampl_str_concat("^ string_of_expr e1 ^ "," ^ string_of_expr e1 ^ ")"
      | _ -> "(" ^ string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2 ^ ")"
    )
  | SUnop(t, o, e) -> "(" ^ string_of_uop o ^ string_of_expr e ^ ")"
  | SAssign(t, o, e) -> ( match o with
        SBrac(o2,e2,is_ins,_) -> ( if e2 = SNoexpr
          then ( "dampl_arr_append__" ^ simple_string_of_typ t
         ^ "(" ^ string_of_obj o2 ^ "," ^ string_of_expr e ^ ")")
         else ( "dampl_arr_" ^ set_or_insert is_ins ^ "__" ^ simple_string_of_typ t
         ^ "(" ^ string_of_obj o2 ^ "," ^ string_of_expr e2 ^ "," ^ string_of_expr e ^ ")" )
      )
      | SBrac2(o2,e21,e22,_) ->
        let e21 = if e21 = SNoexpr then empty_inx else e21 in
        let e22 = if e22 = SNoexpr then empty_inx else e22 in
        "dampl_arr_set_range__arr(" ^ string_of_obj o2 ^ ","
        ^ string_of_expr e21 ^ "," ^ string_of_expr e22 ^ "," ^ string_of_expr e ^ ")"
      | _ -> string_of_obj o ^ " = " ^ string_of_expr e
  )
  | SCall(f, el) ->
      "dampl_" ^ f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | SArr(t,exprs) -> if (List.length exprs) = 0
      then "dampl_arr_new()"
      else (
        let create_append expr =
            "dampl_arr_append__"^simple_string_of_typ t^"(a,"^string_of_expr expr^");\n"
        in "({\nArray a=dampl_arr_new();\n"
          ^(String.concat "" (List.map create_append exprs))
          ^"a;})"
      )
  (*
  | STupInst of string (* tuple instantiation *)
  | STabInst of string (* table instantiation e.g. Foo[] *)
  | STupInit of string * expr list (* tuple init e.g. Foo{1,2,"abc"} *)
  | SArr of expr list (* arrays e.g. [1,2,3] *)
  | SDict of expr list * expr list (* dicts *)
  *)
  | SNoexpr -> ""
  | SString(s) -> s
  | _ -> raise ( Failure( "string_of_expr case not implemented" ))


let rec string_of_stmt = function
    SBlock(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_expr expr ^ ";\n";
  | SReturn(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | SIf(e, s, SBlock([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | SIf(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  
  | SFor(str,t, e, s) -> "{\n"
      ^ string_of_typ t ^ " dampl_"^str^" = dampl_arr_get__"^simple_string_of_typ t^"(0);\n"
      ^ "int i_"^str ^ " = 0;\n"
      ^ "for (;"
        ^"i_"^str^" < dampl_arr_size(" ^ string_of_expr e ^ ");"
        ^"dampl_"^str^" = dampl_arr_get__"^simple_string_of_typ t^"(++i_"^str ^ ")"
      ^")\n"^string_of_stmt s
  
     (* "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
    *)
  | SWhile(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s
  | SBreak -> "break;\n"
  | SContinue -> "continue;\n"


let string_of_vdecl (id, t) = string_of_typ t ^ " dampl_" ^ id ^ ";\n"

let string_of_formal f = (string_of_typ (fst f))^" dampl_"^(snd f)

let string_of_global global =
  string_of_typ (fst global) ^ " " ^ " dampl_" ^ (snd global) ^";\n";;

let fdecl_prototype fdecl =
  string_of_typ fdecl.rtyp ^ " " ^ " dampl_" ^ fdecl.semfname ^
  "(" ^ String.concat ", " (List.map string_of_formal fdecl.semformals) ^
  ");\n";;

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^ " dampl_" ^ fdecl.semfname ^
  "(" ^ String.concat ", " (List.map string_of_formal fdecl.semformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl (StringMap.bindings !(fdecl.semlocals) ) ) ^
  String.concat "" (List.map string_of_stmt fdecl.sembody) ^
  "}\n\n"



let string_of_program (globals, statements, functions, tuples) = 
  "#include <stdio.h>\n" ^ "#include <stdlib.h>\n" ^
  "#include \"dampllib.h\"\n\n" ^
  String.concat "" (List.map string_of_global globals) ^ "\n" ^
  String.concat "" (List.map fdecl_prototype functions) ^ "\n" ^
  String.concat "" (List.map string_of_fdecl functions) ^
  "int main(){\n" ^
  String.concat "" (List.map string_of_stmt statements) ^ 
  "return 0;\n}\n"
