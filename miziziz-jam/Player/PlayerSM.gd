extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("dash")
	add_state("fall")
	add_state("wallslide")
	call_deferred("set_state", states_dict.idle)
	
func _logic(delta):
	parent.handle_input()
	parent.apply_input_movement(delta)
	parent.apply_gravity(delta)
	parent.apply_movement()

func _handle_current_state():
	match current_state:
		
		states_dict.idle: 
			if parent.dash.is_dashing: return states_dict.dash
			elif parent.input_velocity: return states_dict.run 
			elif !parent.is_on_floor(): return states_dict.jump if parent.velocity.y < 0 else states_dict.fall
			
		states_dict.run: 
			if parent.dash.is_dashing: return states_dict.dash
			elif !parent.input_velocity: return states_dict.idle 
			elif !parent.is_on_floor(): return states_dict.jump if parent.velocity.y < 0 else states_dict.fall
			
		states_dict.jump: 
			if parent.dash.is_dashing: return states_dict.dash
			elif parent.can_wall_slide(): 
				parent.slidin_the_wall = true
				return states_dict.wallslide
			elif parent.velocity.y > 0: return states_dict.fall
		
		states_dict.fall:
			if parent.dash.is_dashing: return states_dict.dash
			elif parent.is_on_floor(): 
				parent.double_jump.double_jump = false
				parent.fall_particle.create_particle()
				return states_dict.idle
			elif parent.can_wall_slide(): 
				parent.slidin_the_wall = true
				return states_dict.wallslide
			elif parent.velocity.y < 0: return states_dict.jump
		
		states_dict.wallslide: 
			if parent.dash.is_dashing: 
				parent.slidin_the_wall = false
				return states_dict.dash
			elif parent.is_on_floor() or !parent.can_wall_slide(): 
				parent.slidin_the_wall = false
				parent.double_jump.double_jump = false
				return states_dict.fall
				
		states_dict.dash: 
			if !parent.dash.is_dashing: 
				if parent.velocity.y < 0: return states_dict.jump
				elif parent.velocity.y > 0: return states_dict.fall
				else: return states_dict.idle

	return

func _enter_state(new_state):
	match new_state:
		states_dict.idle: parent.animation_player.play("Idle")
		states_dict.run: 
			parent.animation_player.play("Run")
			parent.run_particle.create_particle()
		states_dict.jump: parent.animation_player.play("Jump")
		states_dict.dash: parent.animation_player.play("Dash")
		states_dict.fall: 
			if [states_dict.idle, states_dict.run].has(old_state): parent.coyote_timer.start()
			parent.animation_player.play("Fall")
		states_dict.wallslide: 
			parent.wall_particle.create_particle()
			parent.velocity.y = 0
			parent.sprite.flip_h = parent.can_wall_slide()[1]
			parent.animation_player.play("WallSlide")

func _exit_state(old_state):
	match old_state:
		states_dict.dash: if parent.is_on_floor(): parent.double_jump = false
		states_dict.wallslide: 
			parent.wall_particle.destroy_particle()
			parent.double_jump.double_jump = false
		states_dict.run: parent.run_particle.destroy_particle()

func _input(event):
	
	if event.is_action_pressed("ui_up"): 
		if !parent.slidin_the_wall and !parent.double_jump.double_jump:
			parent.double_jump.double_jump = (!parent.is_on_floor() and !parent.dash.is_dashing and parent.coyote_timer.is_stopped())
			parent.coyote_timer.stop()
			
			if parent.double_jump.double_jump and parent.double_jump.has_double_jump: parent.double_jump.apply_double_jump()
			elif !parent.double_jump.double_jump: parent.apply_jump()
			
		elif parent.slidin_the_wall:
			parent.apply_wall_jump()
	
	if event.is_action_pressed("ui_dash") and parent.dash.can_dash and parent.dash.has_dash: 
		parent.dash.apply_dash()
	
	if event.is_action_pressed("ui_space") and parent.slow_mo.has_slow_mo: parent.apply_slow()
