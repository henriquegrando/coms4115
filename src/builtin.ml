open Ast
open Semt 

let built_in_prototypes = [
  (Void,"print",[
    [String];
    [Int];
    [Float];
  ]);
  (String,"str",[
    [String];
    [Int];
    [Float];
  ]);
  (Float,"float",[
    [String];
    [Int];
    [Float];
  ]);
  (Int,"int",[
    [String];
    [Int];
    [Float];
  ]);
  (Int,"len",[
    [String];
  ]);
  (Void,"die",[[]]);
  (String,"readfile",[
    [String]
  ]);
  (Array(String),"strsplit",[
    [String]
  ]);
  (Void,"writefile",[
    [String];
    [String];
  ]);
];;

let get_built_in_rtyp = function
    (t,_,_) -> t 

let get_built_in_name = function
    (_,name,_) -> name 

let get_built_in_formals = function
    (_,_,formals) -> formals 