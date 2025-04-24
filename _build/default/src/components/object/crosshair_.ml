open Ecs
open Component_defs
open System_defs

let cst_textureLink = "resources/images/cross.png"

let create_crosshair (x, y, width, height) =
  let e = new crosshair in
  
  e#texture#set Texture.default ;
  
  e#position#set Vector.{x = float x; y = float y};
  e#box#set Rect.{width; height};

  e#velocity#set (Vector.zero); 
  
  Draw_system.(register (e :> t));
  Move_system.(register (e :> t)); 
 
  e

let create_instance () : crosshair= 
  create_crosshair Cst.(400, 300, 50, 50) ;;

let get_crosshair () =
  let Global.{crosshair} = Global.get () in 
  crosshair

let stop_crosshair () = 
  (get_crosshair())#velocity#set Vector.zero 
  

let move_crosshair crosshair v =
  crosshair#velocity#set (v) ;