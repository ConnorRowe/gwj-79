extends Control

@onready var transition: Transition = $Transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_drums()
	transition.fade_in()


func _on_play_button_pressed() -> void:
	transition.transition_to_scene("res://scenes/main_menu.tscn")
