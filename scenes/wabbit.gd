extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
var main: Main
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent()
	animation_player.play("eat_carrot")

func _process(_delta: float) -> void:
	main.draw_rainbow_line(Vector2i(sprite_2d.global_position))


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	main.coin_stack.add_coin()
	queue_free()
