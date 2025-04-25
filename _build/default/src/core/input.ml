open Component_defs 

let key_table = Hashtbl.create 1
let has_key s = Hashtbl.mem key_table s
let set_key s= Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s

let action_table = Hashtbl.create 1
let register key action = Hashtbl.replace action_table key action

let handle_input () =
  let () =
    match Gfx.poll_event () with
      KeyDown s -> set_key s
    | KeyUp s -> unset_key s
    | Quit -> exit 0
    | _ -> ()
  in
  Hashtbl.iter (fun key action ->
      if has_key key then action ()) action_table

(*let () = Don´t even think about it.
  register "n" (fun () -> ignore (Block.create_random ()))*)


let () =
(*Crosshair's movement*)
  register "i" (fun () -> 
    Crosshair_.stop_crosshair();
    Crosshair_.move_crosshair (Crosshair_.get_crosshair()) 
                          (Vector.mult Cst.crosshair_speed Cst.up));

  register "k" (fun () -> 
    Crosshair_.stop_crosshair();
    Crosshair_.move_crosshair (Crosshair_.get_crosshair()) 
                          (Vector.mult Cst.crosshair_speed Cst.down));

  register "l" (fun () -> 
    Crosshair_.stop_crosshair();
    Crosshair_.move_crosshair (Crosshair_.get_crosshair()) 
                          (Vector.mult Cst.crosshair_speed Cst.right));
  
  register "j" (fun () -> 
    Crosshair_.stop_crosshair();
    Crosshair_.move_crosshair (Crosshair_.get_crosshair()) 
                          (Vector.mult Cst.crosshair_speed Cst.left));
;; 

let () =
(*Player's movement*)
    register "w" (fun () -> 
      Player.jump (););

    register "d" (fun () -> 
      Player.stop_player(); 
      Player.move_player (Player.get_player()) 
                            (Vector.mult Cst.player_speed Cst.right));
    
    register "a" (fun () -> 
      Player.stop_player(); 
      Player.move_player (Player.get_player()) 
                            (Vector.mult Cst.player_speed Cst.left));
;;

let () = 
(*Bullet's spawn logic*)
  let protectedTag_ = Null_:: Player :: Bullet :: [] in
  let auxilary () = 
    let record = Sys.time() in 
    let chrono_bullet = !Global.chrono_bullet in 
    if chrono_bullet < 0.0 then 
      begin 
      Global.chrono_bullet := record ; (*If the game just begun : Global isn't ready, skip*)
      end
    else 
      begin
        let p = Player.get_player() in 
        let c = Crosshair_.get_crosshair() in 
        (*Prevent the Player from spawning too many bullets*)
        if record -. chrono_bullet < Cst.bulletTiming then 
          ()
        else 
          let directionNormalised =  Vector.normalize (Vector.sub (p#position#get) (c#position#get)) in 
          let spawnPoint = Vector.add (p#position#get) (directionNormalised) in
          Bullet.create_bullet (spawnPoint.x , spawnPoint.y , directionNormalised, protectedTag_) ; 
          Global.chrono_bullet := record
      end 
  in
  register "f" (fun() ->auxilary ()); 
;;

(*
(p#position#get).x, (p#position#get).y
Format.eprintf "true"; 
*)