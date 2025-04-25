open Ecs
open Component_defs
open Cst 

type t = physics

let init _ = ()

(*
Calculate the "velocity" value of a physics instance based on gravity "g" 
and the "forces" and "mass" value of said instance. 

A very naive (or nonsensical) physics system.
*)
let update _ seqElement = 
  let auxilary e = 
    let result : Vector.t = e#forces#get in 

    let y_ = ref(result.y +. (Cst.g).y *. e#mass#get) in 
    (*Arbitrarily decides the limit value for y_*)
    if !y_ > (5.0 *. e#mass#get) then y_ := 5.0 *. e#mass#get;
    let x_ = result.x *. (100.0 -. Cst.slowDownCoeff ) in 
    e#forces#set Vector.{x = x_; y = !y_}; 
    e#velocity#set (Vector.add Vector.{x = x_; y = !y_} e#velocity#get);
  in 

  Seq.iter (auxilary) seqElement; 
;;


(*Format.eprintf "%a\n%!" Vector.pp e#velocity#get;*)