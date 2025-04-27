open System_defs
open Component_defs
open Ecs


let init dt =
  Ecs.System.init_all dt;
  Some ()


let update dt =
  let () = Input.handle_input () in
  Ai_system.update dt; 
  Destruction_system.update dt; 
  Physics_system.update dt; 
  Move_system.update dt;  
  Collision_system.update dt;
  Draw_system.update dt;
  None

let (let@) f k = f k




let rec run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  
  
  let _walls = Block.layout_1 () in
  let _platforms = Block.platforms () in
  let player = Player.create_instance "Thats me !" in 
  let crosshair = Crosshair_.create_instance () in 

  let global = Global.{ window; ctx; player; crosshair; waiting = 0; list_ai = []; list_block = _platforms} in
  Global.set global;
  Global.postGlobalCreation_assignTexture (player :> texture) (Player.cst_textureLink) ; 
  Global.postGlobalCreation_assignTexture (crosshair :> texture) (Crosshair_.cst_textureLink) ; 
  Global.assignPlatformTexture _platforms Block.cst_blockLink;
  Ia_drone.ready("joe", 100.0, 100.0);
  Ia_drone.ready("odile", 120.0, 520.0);
  Ia_drone.ready("serge", 700.0, 150.0);
  Ia_drone.ready("jeremy", 500.0, 400.0);

  let@ () = Gfx.main_loop ~limit:true init in
  let@ () = Gfx.main_loop update in ()
  (*Touche pour relancer : ne marche pas erreur avec stateMachine_drone*)
  (*let () =
    Input.register "p" (fun () -> run ());*)
;;







