extends Control

const CARD = preload("res://scenes/card.tscn")

@onready var control: Control = $".."

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotatio_degrees = 5
@export var x_sep = -10
@export var y_min = 0
@export var y_max = 15

@export var card_max = 20
@export var prato = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add(card: Control) -> void:
	print("adicionado")
	if get_child_count() < card_max:
		add_child(card)
		card.size = Vector2(100, 140)
		control.jogar_carta(card.card_data)
		update_cards()

func update_cards() -> void:
	var cards = get_child_count()
	var all_cards_size = card.SIZE.x * cards + x_sep * (cards - 1)
	var final_x_sep = x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - card.SIZE.x * cards) / (cards - 1)
		all_cards_size = size.x
	
	var offset = (size.x - all_cards_size) / 2
	
	for i in cards:
		var card_i = get_child(i)
		print(card_i)
		#var y_multiplier = hand_curve.sample(1.0 / (cards -1) * i)
		#var rot_multiplier = rotation_curve.sample(1.0 / (cards -1) * i)
		
		#if cards == 1:
			#y_multiplier = 0.0
			#rot_multiplier = 0.0
		
		var final_x: float = offset + card.SIZE.x * i + final_x_sep * i
		#var final_y: float = y_min + y_max * y_multiplier
		
		card_i.position = Vector2(final_x, 0)
		#card_i.rotation_degrees = max_rotatio_degrees * rot_multiplier
