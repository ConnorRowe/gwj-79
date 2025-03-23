extends Control

signal unpause

@onready var paused_label: Label = $PausedLabel
var is_in_pause_menu := false

func _on_timer_timeout() -> void:
	paused_label.visible = !paused_label.visible


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	GameStatsInst.reset_stats()
	$Transition.transition_to_scene("res://scenes/main_menu.tscn")


func _input(event: InputEvent) -> void:
	if is_in_pause_menu and event.is_action_pressed("pause"):
		# unpause
		unpause.emit()


func _on_unpause_button_pressed() -> void:
	unpause.emit()
