class_name CoinStack
extends Node2D

const ANIMATED_COIN = preload("res://scenes/animated_coin.tscn")
const COIN_SIDE = preload("res://assets/coin_side.png")

@onready var coins: Node2D = $Coins

var coin_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		add_coin()


func add_coin() -> void:
	var new_coin = Sprite2D.new()
	coins.add_child(new_coin)
	new_coin.texture = COIN_SIDE
	new_coin.position.x = randi_range(-4, 4)
	new_coin.position.y = coin_count * -4
	new_coin.visible = false
	
	var anim_coin = ANIMATED_COIN.instantiate()
	add_child(anim_coin)
	anim_coin.position = new_coin.position
	anim_coin.on_coin_anim_finished.connect(unhide_coin.bind(new_coin))
	#anim_coin.tree_exiting.connect(func(): new_coin.visible = true)
	
	coin_count += 1


func unhide_coin(coin: Sprite2D):
	coin.visible = true
