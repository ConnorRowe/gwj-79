class_name Shop
extends Node2D

signal shop_closed

const rat_quips := ["I have the best deals anywhere!", "I sell only the finest goods", "Heh heh. Glad I could help!",
"I hope youre grateful Im here!", "We rats need to stick together, maybe next time Ill give you a discount. Heh nah.",
"Im Gorbo the Rat, welcome to my upgrade emporium.", "Wait I think Im having heart palpatations.", "I believe in classical liberal economics. Yes I was dropped on my head as a baby. But what makes you say that...",
":: breathes heavily ::", "Youre terribly small. What do you want today", "I wonder what these aliens even want...", "I bet I could work out a business deal with the green blokes.",
"Those little green buggers would listen to my business acumen.", "I have an MBA from St Ratius University you know.", "No I wont tell you how I got my paws on all these black market machine gun turret upgrades. Stop asking.",
"Hello. My father was the Earl of Ratshire by the way."]

@onready var quip_label: Label = $VBox/PanelContainer/QuipLabel
@onready var blink_sprite: AnimatedSprite2D = $Sprite2D/BlinkSprite
@onready var blink_timer: Timer = $BlinkTimer
var is_open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_quip()

func opening_shop() -> void:
	new_quip()
	is_open = true


func new_quip() -> void:
	quip_label.text = rat_quips[randi_range(0, len(rat_quips) - 1)]


func _on_blink_timer_timeout() -> void:
	blink_sprite.play("default")
	blink_timer.wait_time = randf_range(2, 6)


func _on_back_button_pressed() -> void:
	is_open = false
	shop_closed.emit()
