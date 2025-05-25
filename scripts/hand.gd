# hand.gd
extends Control

const CARD = preload("res://scenes/card.tscn")
signal card_drawn(card_node: Node2D)

#Sons
@onready var sfx_new_hand: AudioStreamPlayer2D = $"../SFXNewHand"
@onready var sfx_new_hand_alternate: AudioStreamPlayer2D = $"../SFXNewHandAlternate"

@onready var control: Control = $".."

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotatio_degrees = 5
@export var x_sep = -10
@export var y_min = 0
@export var y_max = -15

@export var card_max = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	update_cards()

func get_card_position(index: int) -> Vector2:
	var cards = get_child_count()
	if cards == 0 or index < 0 or index >= cards:
		return global_position # Posição padrão se não houver cartas ou índice inválido

	var all_cards_size = card.SIZE.x * cards + x_sep * (cards - 1)
	var final_x_sep = x_sep

	if all_cards_size > size.x:
		final_x_sep = (size.x - card.SIZE.x * cards) / (cards - 1)
		all_cards_size = size.x

	var offset = (size.x - all_cards_size) / 2

	var y_multiplier = hand_curve.sample(1.0 / (cards - 1) * index) if cards > 1 else 0.0
	var final_x: float = offset + card.SIZE.x * index + final_x_sep * index
	var final_y: float = y_min + y_max * y_multiplier

	return global_position + Vector2(final_x, final_y)

func draw(carta: CartaData) -> void:
	print("draw")
	if get_child_count() < card_max:
		var new_card = CARD.instantiate()
		add_child(new_card)
		new_card.set_card(carta)
		# A posição final será atualizada no Control através da animação
		emit_signal("card_drawn", new_card)

func discard() -> void:
	while get_child_count() >= 1:
		var child = get_child(-1)
		child.reparent(get_tree().root)
		child.queue_free()
		update_cards()
		await get_tree().create_timer(0.1).timeout # Reduzi o delay para o descarte
		
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
		var y_multiplier = hand_curve.sample(1.0 / (cards -1) * i)
		var rot_multiplier = rotation_curve.sample(1.0 / (cards -1) * i)
		
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		
		var final_x: float = offset + card.SIZE.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		card_i.position = Vector2(final_x, final_y)
		card_i.rotation_degrees = max_rotatio_degrees * rot_multiplier
