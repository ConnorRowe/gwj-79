extends Node2D

@onready var jiggly_camera_2d: JigglyCamera2D = $JigglyCamera2d
@onready var debug: Label = $Reference/Debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	debug.text = str(atan2($"Player".dir.y, $"Player".dir.x)) + "\n" + str(rad_to_deg(atan2($"Player".dir.y, $"Player".dir.x)))

func shake_screen(amount: float) -> void:
	jiggly_camera_2d.jiggle(amount)

func _on_player_on_player_shoot() -> void:
	#shake_screen(1)
	pass	
