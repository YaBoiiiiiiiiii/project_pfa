open Ecs
open Component_defs

type t = movable

let init _ = ()

let update _ el =
  Seq.iter (fun (e:t) ->
      let v = e#velocity#get in
      e#position#set Vector.(add v e#position#get);
      (*If the instance should reset its velocity after each iteration*)
      if (e#brake#get) then  e#velocity#set Vector.zero ; 
    ) el
