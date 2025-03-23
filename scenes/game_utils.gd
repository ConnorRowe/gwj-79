extends Node

const HIT_PARTICLES = preload("res://scenes/HitParticles.tscn")
const TAU_PROC_SPEED := 2.0

var process_tau := 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		


func instantiate_and_position_tscn(tscn: PackedScene, global_position: Vector2) -> Node2D:
	var scene := tscn.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.global_position = global_position
	return scene


func spawn_hit_particles(global_position: Vector2, colour: Color) -> void:
	instantiate_and_position_tscn(HIT_PARTICLES, global_position).self_modulate = colour


func _process(delta: float) -> void:
	process_tau = wrapf(process_tau + (delta * TAU_PROC_SPEED), 0, TAU)
