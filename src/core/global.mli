open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable player : player;
  crosshair : crosshair;
  mutable waiting : int;
  mutable list_ai : abstract_ai list ; (*List of Drawable/Collidable/Destructible items.*)
}

val get : unit -> t
val set : t -> unit

val chrono_bullet : float ref 

val new_ID : unit -> int64 

val pop_ai : id -> unit 
val add_ai : abstract_ai -> unit 
val get_ai : id -> abstract_ai option 
val clean_ai : unit -> unit 

val postGlobalCreation_assignTexture : texture -> string -> unit 


