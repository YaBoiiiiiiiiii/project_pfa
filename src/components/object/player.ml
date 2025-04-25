open Ecs
open Component_defs
open System_defs


(*type tag += Player*)
let cst_tag = Player


let cst_textureLink = "resources/images/man.png"


let cst_width = 20
let cst_height = 50


let cst_mass = 3.0


let cst_hp = 150.0


let cst_dmg = 0.0

(*Player specific variables/constants*)
let cst_jumpPush = -25.0

let create_player (x, y,name) =
  let e = new player name in
  e#tag#set cst_tag;

  e#texture#set Texture.default ;

  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width = cst_width; height = cst_height};

  e#mass#set cst_mass;
  e#forces#set (Vector.zero); 
  e#velocity#set (Vector.zero); 
  (**)


  e#hitBox#set Rect.{width = cst_width; height = cst_height};
  e#relativeHitBox#set (Vector.zero);
  e#damage#set cst_dmg; 


  e#hurtBox#set Rect.{width = 0; height = 0}; 
  e#relativeHurtBox#set (Vector.zero);
  e#healthPoint#set cst_hp;  

  Draw_system.(register (e :> t));
  Move_system.(register (e :> t));
  Physics_system.(register (e :> t));
  Destruction_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e

;;

let create_instance (name : string) : player=
  create_player (400, 300, name )
;;

let get_player () =
  let Global.{player} = Global.get () in 
  player
;;

let stop_player () = 
  (get_player())#velocity#set Vector.zero 
;;

let move_player player v =
  player#velocity#set (v) 
;;

let jump () = 
  let player_ = get_player() in 
  if player_#isInContact#get then 
    player_#forces#set Vector.{x = 0.0;  y = cst_jumpPush}
  else (*Cannot jump if it isn't in contact with a collidable.*)
    ()
;;


    