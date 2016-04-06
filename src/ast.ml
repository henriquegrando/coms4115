(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or

type uop = Neg | Not



type tup = string * string list (* tuple creation *)

type obj = (* lhs *)
    Id of string
  | Brac of string * expr (* a[0] a[i] a[i+1] *)
  | Brac2 of string * expr * expr (* a[0:2] *)
  | Attr of string * string (* a$b *)
and
 expr =
    Literal of int
  | BoolLit of bool
  | FloatLit of float
  | StrLit of string
  | Obj of obj
  | Binop of expr * op * expr(* as on lhs *)
  | Unop of uop * expr
  | Assign of obj * expr
  | Call of string * expr list
  | TupInst of string (* tuple instantiation *)
  | TabInst of string (* table instantiation e.g. Foo[] *)
  | TupInit of string * expr list (* tuple init e.g. Foo{1,2,"abc"} *)
  | Arr of expr list (* arrays e.g. [1,2,3] *)
  | Dict of expr list * expr list (* dicts *)
  | Noexpr

type stmt =
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of string * expr * stmt (* for i in a *)
  | While of expr * stmt
  | Break
  | Continue

type func_decl = {
    fname : string;
    formals : string list;
    locals : string list;
    body : stmt list;
  }


type program_decl =
    Func of func_decl
  | Tup of tup

type program = stmt list * program_decl list
