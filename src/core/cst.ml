let font_name = if Gfx.backend = "js" then "mingliu" else "resources/images/mingliu.TTF"
let font_color = Gfx.color 0 0 0 255
let window_width = 800
let window_height = 600

let up = Vector.{x = 0.0; y = -1.0}

let right = Vector.{x = 1.0; y = 0.0}

let left = Vector.{x = -1.0; y = 0.0}

let down = Vector.{x = 0.0; y = 1.0}

let g = Vector.{x = 0.0; y = 1.0 }

(*Unused*)
let slowDownCoeff = 0.1 
let crosshair_speed = 16.0 
let player_speed = 8.0

(*Prevents the player from firing a bullet within an interval of 0.5 seconds*)
let bulletTiming = 0.5 

let cst_bg = "resources/images/bg.png"