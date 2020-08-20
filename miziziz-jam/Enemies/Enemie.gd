extends KinematicBody2D

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 20
export(int) var FRICTION = 300
export(int) var GRAVITY = 10
const FLOOR = Vector2(0, -1)

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var run_particle_pivot = $RunParticlePivot
onready var run_particle = $RunParticlePivot/RunParticle
onready var wander_timer = $WanderTimer
onready var idle_timer = $IdleTimer
onready var ray_left = $Rays/Left
onready var ray_right = $Rays/Right
onready var hey = $Hey
onready var run = $Run
onready var player_detection = $PlayerDetection

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
var BODY_MASS = 200
var wandering = false
var found_player = false
var player_body

signal is_player

func apply_gravity(delta):
	velocity.y += GRAVITY * BODY_MASS * delta

func apply_direction_movement(delta):
	var _from = direction * MAX_SPEED if wandering else Vector2.ZERO
	var _to = ACCELERATION * delta if wandering else FRICTION * delta
	velocity = velocity.move_toward(_from, _to)
	
func apply_movement():
	velocity = move_and_slide(velocity, FLOOR)
	
func handle_direction():
	if !_is_ray_colliding(ray_left): direction = Vector2.RIGHT
	elif !_is_ray_colliding(ray_right): direction = Vector2.LEFT
	elif is_on_wall(): direction = -direction
	
	run_particle_pivot.rotation_degrees = 180 if direction == Vector2.LEFT else 0
	
func _is_ray_colliding(ray):
	return ray.is_colliding()

func aim():
	if player_body and !found_player:
		var space_state = get_world_2d().direct_space_state
		var collided = space_state.intersect_ray(position, player_body.position, [self])
		
		if collided and collided.collider.name == "Player":
			wandering = false
			found_player = true
			hey.play()
			emit_signal("is_player")
	
func _on_WanderTimer_timeout():
	wandering = false
	direction = -direction

func _on_IdleTimer_timeout():
	wandering = true

func _on_PlayerDetection_body_entered(body):
	player_body = body

func _on_PlayerDetection_body_exited(_body):
	player_body = null

func _on_Run_finished():
	if wandering: run.play()
