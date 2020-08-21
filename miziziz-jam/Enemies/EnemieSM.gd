extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("wander")
	add_state("lights_out")
	call_deferred("set_state", states_dict.idle)
	
func _logic(delta):
	parent.handle_direction()
	parent.aim()
	parent.apply_direction_movement(delta)
	parent.apply_gravity(delta)
	parent.apply_movement()

func _handle_current_state():
	match current_state:
		states_dict.idle: 
			if parent.lights_out: return states_dict.lights_out
			elif parent.wandering: return states_dict.wander
		states_dict.wander: 
			if parent.lights_out: return states_dict.lights_out
			elif !parent.wandering: return states_dict.idle
		states_dict.lights_out: if !parent.lights_out: return states_dict.idle
			
	return

func _enter_state(new_state):
	if !parent.found_player:
		match new_state:
			states_dict.idle: 
				parent.animation_player.play("Idle")
				parent.idle_timer.start(rand_range(2, 3))
				
			states_dict.wander: 
				parent.run.play()
				parent.animation_player.play("Wander")
				parent.run_particle.create_particle()
				parent.wander_timer.start(rand_range(2, 3))
			
			states_dict.lights_out:
				parent.wandering = false
				parent.player_detection_collider.disabled = true
				parent.light.enabled = false
				parent.animation_player.play("Scared")
	
func _exit_state(_old_state):
	match old_state:
		states_dict.idle: parent.idle_timer.stop()
		states_dict.wander: 
			parent.run_particle.destroy_particle()
			parent.wander_timer.stop()
			parent.run.stop()
		states_dict.lights_out:
			parent.player_detection_collider.disabled = false
			parent.light.enabled = true
