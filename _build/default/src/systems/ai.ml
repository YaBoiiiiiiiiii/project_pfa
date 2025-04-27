open Ecs 
open Component_defs

type t = ai

let init _ = () 

let state_computing (instance : t) = 
  instance#state_machine#get (instance :> id)
  ;;

let update _ sequence = 
  Seq.iter (fun (instance : t) -> (state_computing instance)) sequence; 
;; 

