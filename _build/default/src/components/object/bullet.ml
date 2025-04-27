open Ecs
open Component_defs
open System_defs

(*type tag += Bullet*)
let cst_tag = Bullet 

let cst_textureLink = "resources/images/bullet.png"

let cst_width = 20 
let cst_height = 20 

let cst_mass = 1.1

let cst_damage = 50.0

let cst_healthPoint = 10000.0

let cst_power = 20.

let cst_behavior = 0 (*Does not ever change*)

let iaBullet_unregister (id_ : id) = 
  let instance : abstract_ai =
    match (Global.get_ai id_) with 
    | Some x -> x  
    | None -> failwith "Id not found"
  in 
  Global.(pop_ai (id_)); 
  Collision_system.(unregister (instance :> t));
  Destruction_system.(unregister (instance :> t)); 
  Draw_system.(unregister (instance :> t)); 
  Ai_system.(unregister (instance :> t));
  Move_system.(unregister (instance :> t));
;;

let bullet_stateMachine(id_ : id) = 
  let instance : abstract_ai =
    match (Global.get_ai id_) with 
    | Some x -> x  
    | None -> failwith "bullet_Id not found"
  in 
  (*If the bullet damaged something and is in contact : immediately self destroy*)
  let result = (instance#impactInfo#get) in 
  if not(result = []) then 
    iaBullet_unregister(id_) 
  else 
    ()
;;

let create_bullet (x, y, normalisedFiringDirection, cst_protectedTag) =
  let e = new abstract_ai "BULLET" in
  e#id#set Global.(new_ID ()) ; 
  e#tag#set Bullet;
  e#protectedTag#set cst_protectedTag;
  e#impactInfo#set [];

  let Global.{ctx} = Global.get () in 
  let cst_texture = Texture.loadImage (ctx) (cst_textureLink) in 
  e#texture#set cst_texture ;

  e#position#set Vector.{x = x; y = y};
  e#box#set Rect.{width = cst_width; height = cst_height};
  e#requiresRayCast#set true; (*The bullet move fast enough to potentially clip through collidables*)

  e#mass#set cst_mass;
  (**)
  e#velocity#set Vector.{ x = -.normalisedFiringDirection.x *. cst_power; 
  y = -.normalisedFiringDirection.y *. cst_power}; 
  (**)
  e#forces#set Vector.zero;
  e#brake#set false; 

  e#hitBox#set Rect.{width = 0; height = 0}; 
  e#relativeHitBox#set (Vector.zero);
  e#damage#set cst_damage;

  e#hurtBox#set Rect.{width = cst_width; height = cst_height};
  e#relativeHurtBox#set (Vector.zero);
  e#healthPoint#set cst_healthPoint; 

  e#behavior#set cst_behavior; 
  e#state_machine#set (bullet_stateMachine) ; 
  e#unregister#set iaBullet_unregister; 
  
  (*Collision_system.(register (e :> t));*)
  Destruction_system.(register (e :> t)); 
  Draw_system.(register (e :> t)); 
  Ai_system.(register (e :> t)); 
  Move_system.(register (e:> t)); 
  (*Not affected by physics.*)


  Global.(add_ai e)
;;

let stop_bullet b = 
  b#velocity#set Vector.zero 
;;
