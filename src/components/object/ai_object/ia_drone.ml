open Ecs
open Component_defs
open System_defs 

(*type tag += Body*)

(*Initial/Constant values for the abstract_ai class*)
type state = Idle | Attack;; 

let cst_protectedTag = Null_ :: Body :: [] 

let cst_textureLink = "resources/images/drone.png"

let cst_box : Rect.t = Rect.{width=48; height=48}

let cst_mass : float = 0.0
let cst_speed : float = 0.8
(*let cst_resolver*)

let cst_hitBox : Rect.t = Rect.{width=48; height=48}
let cst_relativeHitBox : Vector.t = Vector.{x= -0.0; y = 0.0}
let cst_dmg : float = 10.0  

let cst_hurtBox : Rect.t = Rect.{width=48; height=48}
let cst_relativeHurtBox : Vector.t = Vector.{x= 0.0; y = 0.0}
let cst_hp : float = 250.0

let cst_behavior : int = 0 

(*drone's specific variables/constants*)
let cst_detectionRange : float = 600.0

let to_enum (args : int) = 
  match args with 
  | 0 -> Idle ; 
  | 1 -> Attack; 
  | _ -> failwith "Invalid state "
;;

let to_int (args : state) = 
  match args with 
  |Idle -> 0
  |Attack -> 1


let const_unregister (instance) = 
  Global.(pop_ai (instance :> id)); 
  Destruction_system.(unregister (instance :> t)); 
  Draw_system.(unregister (instance :> t)); 
  Ai_system.(unregister (instance :> t));
  Move_system.(unregister (instance :> t));
;;

let iaDrone_unregister (id_ : id) : unit = 
  let instance : abstract_ai =
    match (Global.get_ai id_) with 
    | Some x -> x  
    | None -> failwith "Id not found"
  in 
  const_unregister instance ; 
;;

let stateMachine_drone (id_ : id) =
  let instance : abstract_ai =
    match (Global.get_ai id_) with 
    | Some x -> x  
    | None -> failwith "Id not found"
  in 
  let current_behavior : state = (to_enum (instance#behavior#get)) in  

  if (instance#healthPoint#get <= 0.0) then 
    const_unregister instance  

  else 
    let Global.{player; _ } = Global.get() in 
    let vector_toPlayer : Vector.t = (Vector.sub player#position#get instance#position#get) in
    match current_behavior with 
    | Idle -> 
        let distance_toPlayer : float = Vector.norm vector_toPlayer in
        if distance_toPlayer >= cst_detectionRange then 
          ()
        else 
        instance#behavior#set (to_int Attack);
      
    | Attack -> 
        let distance_toPlayer : float = Vector.norm vector_toPlayer in
        if distance_toPlayer >= cst_detectionRange then 
          instance#behavior#set (to_int Idle) 
        else 
          instance#velocity#set (Vector.mult cst_speed (Vector.normalize vector_toPlayer))

;;

let ready (name, x, y) = 
  let e = new abstract_ai name in
  e#id#set Global.(new_ID ()) ; 
  e#tag#set Body; 
  e#protectedTag#set cst_protectedTag;

  let Global.{ctx} = Global.get () in 
  let cst_texture = Texture.loadImage (ctx) (cst_textureLink) in 
  e#texture#set cst_texture ;

  e#position#set Vector.{x=x; y=y} ;
  e#box#set cst_box ;

  e#mass#set cst_mass; 
  (**)
  e#velocity#set Vector.zero; 
  (**)

  e#hitBox#set cst_hitBox;
  e#relativeHitBox#set cst_relativeHitBox;
  e#damage#set cst_dmg ;

  e#hurtBox#set cst_hurtBox;
  e#relativeHurtBox#set cst_relativeHurtBox;
  e#healthPoint#set cst_hp ;
  

  e#behavior#set cst_behavior; 
  e#state_machine#set (stateMachine_drone) ; 
  e#unregister#set iaDrone_unregister; 

  Collision_system.(register (e :> t)); 
  Destruction_system.(register (e :> t)); 
  Draw_system.(register (e :> t)); 
  Ai_system.(register (e :> t)); 
  Move_system.(register (e:> t)); 

  Global.(add_ai e)
  
;; 


