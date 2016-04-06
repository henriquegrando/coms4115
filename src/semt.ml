(* Semantic Tree *)

open Ast

type typ = Undefined | Bool | Int | Float | Void | String | Tuple of string | Table of string | Array of typ


type typed_id = typ * string

type sem_tup = string * typed_id list (* tuple creation *)

type sem_obj = (* lhs *)
    SId of string
  | SBrac of string * sem_expr (* a[0] a[i] a[i+1] *)
  | SBrac2 of string * sem_expr * sem_expr (* a[0:2] *)
  | SAttr of string * string (* a$b *)
and
 sem_expr =
    SLiteral of int
  | SBoolLit of bool
  | SFloatLit of float
  | SStrLit of string
  | SObj of typ * sem_obj
  | SBinop of typ * sem_expr * op * sem_expr(* as on lhs *)
  | SUnop of typ * uop * sem_expr
  | SAssign of typ * sem_obj * sem_expr
  | SCall of string * sem_expr list
  (* TODO: add typ below *)
  | STupInst of string (* tuple instantiation *)
  | STabInst of string (* table instantiation e.g. Foo[] *)
  | STupInit of string * sem_expr list (* tuple init e.g. Foo{1,2,"abc"} *)
  | SArr of sem_expr list (* arrays e.g. [1,2,3] *)
  | SDict of sem_expr list * sem_expr list (* dicts *)
  | SNoexpr
 

type sem_stmt =
    SBlock of sem_stmt list
  | SExpr of sem_expr
  | SReturn of sem_expr
  | SIf of sem_expr * sem_stmt * sem_stmt
  | SFor of string * sem_expr * sem_stmt (* for i in a *)
  | SWhile of sem_expr * sem_stmt
  | SBreak
  | SContinue

type sem_func_decl = {
    rtyp: typ;
    semfname : string;
    semformals : typed_id list;
    semlocals : typed_id list;
    sembody : sem_stmt list;
  }


type sem_program = sem_stmt list * sem_func_decl list * sem_tup list