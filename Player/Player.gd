extends KinematicBody2D

export(int) var ACCELERATION = 1000
export(int) var MAX_SPEED = 120
export(int) var FRICTION = 900
export(int) var GRAVITY = 10
export(int) var JUMP_HEIGHT = -600
const FLOOR = Vector2(0, -1)

onready var animation_player = $AnimationPlayer
onready var ray_left = $WallCast/Left
onready var ray_right = $WallCast/Right
onready var sprite = $Sprite
onready var run_particle_pivot = $RunParticlePivot
onready var wall_sliding_pivot = $WallSlidingPivot
onready var slow_mo = $SlowMotion
onready var coyote_timer = $CoyoteTimer
onready var run_particle = $RunParticlePivot/RunParticle
onready var wall_particle = $WallSlidingPivot/WallSlidingParticle
onready var fall_particle = $FallParticle
onready var camera_shake = $Camera2D/ScreenShake
onready var dash = $Dash
onready var double_jump = $DoubleJump
onready var lights_out = $LightsOut
onready var jump_sound = $Jump
onready var undo = $Undo

var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO
var BODY_MASS = 200

var slidin_the_wall = false
var is_jumping = false

func apply_gravity(delta):
	BODY_MASS = 200
	if !is_on_floor(): BODY_MASS = 160
	if slidin_the_wall: BODY_MASS = 20
	velocity.y += GRAVITY * BODY_MASS * delta
	if dash.is_dashing and velocity.y > 0: velocity.y = 0
	
func apply_input_movement(delta):
	var _from = input_velocity * MAX_SPEED if input_velocity else Vector2.ZERO
	var _to = ACCELERATION * delta if input_velocity else FRICTION * delta
	velocity = velocity.move_toward(_from, _to)
	
func apply_movement():
	velocity = move_and_slide(velocity, FLOOR)

func apply_jump():
	velocity.y = JUMP_HEIGHT
	
func apply_wall_jump():
	velocity.y = JUMP_HEIGHT * 0.8
	velocity.x = -JUMP_HEIGHT * 0.4 if !sprite.flip_h else JUMP_HEIGHT * 0.4
	
func handle_input():
	input_velocity = Vector2.ZERO
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity = input_velocity.normalized()
	if input_velocity and !slidin_the_wall: 
		sprite.flip_h = true if input_velocity.x < 0 else false
		run_particle_pivot.rotation_degrees = 180 if sprite.flip_h else 0
		wall_sliding_pivot.rotation_degrees = 0 if sprite.flip_h else 180

func can_wall_slide():
	var left = _is_on_wall(ray_left) and input_velocity.x < 0
	var right = _is_on_wall(ray_right) and input_velocity.x > 0
	
	if left or right: return [left, right] 
	return
	
func _is_on_wall(ray2d):
	for ray in ray2d.get_children():
		if ray.is_colliding(): return true
	
	return false
