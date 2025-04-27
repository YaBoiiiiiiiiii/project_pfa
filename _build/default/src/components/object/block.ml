open Ecs
open Component_defs
open System_defs



let cst_blockLink ="resources/images/platform.png"



let create (x, y, v, txt, width, height, mass) =
  let e = new block () in
  e#texture#set txt;
  e#position#set Vector.{x=float x;y = float y};
  e#velocity#set v;
  e#box#set Rect.{width;height};
  e#mass#set mass;
  Collision_system.(register (e:>t));
  Move_system.(register (e:>t));
  Draw_system.(register (e:>t));
  e


let create_random () =
  let x = Cst.window_width / 2 in
  let y = Cst.window_height / 2 in
  let vx = Random.float 5. in
  let vy = Random.float 5. in
  let txt = Texture.black in 
  let width = 20 in
  let height = 20 in
  let mass = 1.0 +. (Random.float 99.0) in
  create (x, y, Vector.{x = vx; y = vy}, txt, width, height, mass)
;;

let layout_1 () = 
  List.map create Cst.[
  (0, 575, Vector.zero, Texture. azure, 800 , 25, infinity); 
  (0, 0, Vector.zero, Texture. azure, 25,  600, infinity); 
  (775, 0, Vector.zero, Texture. azure, 25 , 600, infinity)
  ]
;;

(*Platforms list*)
let platforms () =
  List.map create Cst.[
    (100, 480, Vector.zero, Texture.black, 200, 25, infinity);
    (300, 400, Vector.zero, Texture.black, 100, 25, infinity);
    (450, 470, Vector.zero, Texture.black, 250, 25, infinity);
    (100, 320, Vector.zero, Texture.black, 180, 25, infinity);
    (400, 300, Vector.zero, Texture.black, 120, 25, infinity);
    (500, 200, Vector.zero, Texture.black, 170, 25, infinity);
    (80, 210, Vector.zero, Texture.black, 100, 25, infinity);
    (250, 100, Vector.zero, Texture.black, 200, 25, infinity);
    
  ]
;;