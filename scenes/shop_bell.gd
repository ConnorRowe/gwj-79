extends Node2D

@onready var bell_rigid_body: RigidBody2D = $BellRigidBody
@onready var bell_jiggler: Jiggler = $BellRigidBody/BellSprite/BellJiggler
var opening_shop := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func deal_damage(dmg: int) -> void:
	bell_rigid_body.apply_impulse(Vector2.LEFT * 1600, Vector2.RIGHT * 32)
	bell_jiggler.jiggle(1)
	
	if not opening_shop:
		opening_shop = true
		get_tree().create_timer(.25).timeout.connect(open_shop)


func open_shop() -> void:
	pass


func close_shop() -> void:
	pass
