(* Code generation: translate takes a semantically checked Semantic ST and
produces C

*)

module A = Ast

module S = Semt

module StringMap = Map.Make(String)


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


let string_of_obj = function
    SId(s) -> "dampl_" ^ s
  (*
  | SBrac of string * sem_expr (* a[0] a[i] a[i+1] *)
  | SBrac2 of string * sem_expr * sem_expr (* a[0:2] *)
  | SAttr of string * string (* a$b *)
  *)

let rec string_of_expr = function
    SLiteral(l) -> string_of_int l
  | SBoolLit(true) -> "1"
  | SBoolLit(false) -> "0"
  | SFloatLit(f) -> string_of_float f
  | SStrLit(s) -> s
  | SObj(o) -> string_of_obj o
  | SBinop(t, e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | SUnop(t, o, e) -> string_of_uop o ^ string_of_expr e
  | SAssign(t, v, e) -> v ^ " = " ^ string_of_expr e
  | SCall(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  (*
  | STupInst of string (* tuple instantiation *)
  | STabInst of string (* table instantiation e.g. Foo[] *)
  | STupInit of string * expr list (* tuple init e.g. Foo{1,2,"abc"} *)
  | SArr of expr list (* arrays e.g. [1,2,3] *)
  | SDict of expr list * expr list (* dicts *)
  *)
  | SNoexpr -> ""


let rec string_of_stmt = function
    SBlock(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_expr expr ^ ";\n";
  | SReturn(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | SIf(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | SIf(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  (*
  | SFor(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
    *)
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s
  | SBreak -> "break;\n"
  | SContinue -> "continue;\n"


let string_of_typ = function
    Bool -> "int"
  | Int -> "int"
  | Float -> "float"
  | Void -> "void"
  (*
  | String -> "string"
  
  | Tuple of string
  | Table of string
  | Array of typ
 *)

let string_of_vdecl (t, id) = string_of_typ t ^ " dampl_" ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^ " dampl_" ^ fdecl.fname ^
  "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"



let string_of_program (statements, functions, tuples) = 
  "#include <stdio.h>;\n" ^ "#include <stdlib.h>;" ^
  "#include \"damplstd.h\";\n" ^
  String.concat "" (List.map string_of_fdecl funcs) ^ "\n" ^
  "\nint main(){\n" ^
  String.concat "" (List.map string_of_stmt statements) ^ 
  "}\n"
