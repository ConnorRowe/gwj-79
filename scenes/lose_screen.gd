extends Control

@onready var transition: Transition = $Transition

func _ready() -> void:
	transition.fade_in()


func _on_play_button_pressed() -> void:
	$Transition.transition_to_scene("res://scenes/main_menu.tscn")
