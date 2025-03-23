extends Node2D

signal on_bell_rung

@onready var bell_rigid_body: RigidBody2D = $BellRigidBody
@onready var bell_jiggler: Jiggler = $BellRigidBody/BellSprite/BellJiggler
@onready var bell_player: AudioStreamPlayer = $BellPlayer
var opening_shop := false


func deal_damage(_dmg: int) -> void:
	bell_rigid_body.apply_impulse(Vector2.LEFT * 1600, Vector2.RIGHT * 32)
	bell_jiggler.jiggle(1)
	bell_player.play()

	if not opening_shop:
		opening_shop = true
		get_tree().create_timer(.25).timeout.connect(open_shop)


func open_shop() -> void:
	on_bell_rung.emit()
	opening_shop = false
	
