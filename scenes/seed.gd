extends Node2D

@onready var main: Main = get_tree().current_scene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var draw_pixels := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(2.5).connect("timeout", seed_fall)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draw_pixels:
		var draw_vec := Vector2(cos(GameUtils.process_tau), sin(GameUtils.process_tau))
		main.draw_pixel((draw_vec * 20) + Vector2(global_position), main.cursor_colour)
		main.draw_pixel((draw_vec * -20) + Vector2(global_position), main.cursor_colour)


func seed_fall():
	animation_player.play("seed_fall")
	draw_pixels = false
