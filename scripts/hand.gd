# hand.gd
extends Control

const CARD = preload("res://scenes/card.tscn")
signal card_drawn(card_node: Node2D)

@onready var sfx_new_hand: AudioStreamPlayer2D = $"../SFXNewHand"
@onready var sfx_new_hand_alternate: AudioStreamPlayer2D = $"../SFXNewHandAlternate"

@onready var control: Control = $".."

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotatio_degrees = 0
@export var x_sep = -10
@export var y_min = 0
@export var y_max = 0

@export var card_max = 7

@export var drag_cursor_texture: Texture2D 
@export var normal_cursor_texture: Texture2D 

var hovered_card: Control = null
@export var is_dragging_global: bool = false

@export var current_dragged_card: Control = null

var last_dragged_card: Control = null # Armazena a última carta que foi arrastada
var ignore_hover_until_mouse_leaves: bool = false # Flag para ignorar hover até o mouse sair

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update_cards()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
		var new_hovered_card: Control = null

		# Se estamos no estado de ignorar hover e o mouse ainda está sobre a carta que causou isso
		if ignore_hover_until_mouse_leaves and last_dragged_card and last_dragged_card.get_global_rect().has_point(mouse_pos):
			# Não faz nada, continua ignorando o hover
			pass 
		else:
			# Reseta o estado de ignorar se o mouse saiu da carta que causou isso
			if ignore_hover_until_mouse_leaves:
				ignore_hover_until_mouse_leaves = false
				last_dragged_card = null

			if not is_dragging_global: # Só avalia hover se não houver um drag global ativo
				var cards_to_check = get_children()
				cards_to_check.sort_custom(func(a, b): return a.z_index > b.z_index)

				var best_card_distance = INF
				var card_at_mouse_pos: Control = null

				for card in cards_to_check:
					if card.visible and card is Control and card.is_in_hand:
						var card_rect = card.get_global_rect()
						var hover_detection_rect = Rect2(
							card_rect.position.x + card_rect.size.x * 0.15,
							card_rect.position.y,
							card_rect.size.x * 0.7,
							card_rect.size.y
						)
						
						if hover_detection_rect.has_point(mouse_pos):
							var distance_to_center = mouse_pos.distance_squared_to(card.get_global_rect().get_center())
							if distance_to_center < best_card_distance:
								best_card_distance = distance_to_center
								card_at_mouse_pos = card
				
				new_hovered_card = card_at_mouse_pos
				
				if new_hovered_card != hovered_card:
					if hovered_card:
						hovered_card.z_index = 0
						hovered_card.scale = hovered_card.original_scale
					
					if new_hovered_card:
						new_hovered_card.z_index = 10
						new_hovered_card.scale = new_hovered_card.original_scale * new_hovered_card.scale_factor
					
					hovered_card = new_hovered_card
			
		get_viewport().set_input_as_handled()

func on_drag_started_globally(card_node):
	current_dragged_card = card_node
	Input.set_custom_mouse_cursor(drag_cursor_texture, Input.CURSOR_ARROW)

func on_drag_ended_globally(dragged_card: Control):
	Input.set_custom_mouse_cursor(normal_cursor_texture, Input.CURSOR_ARROW)
	# Esta função é chamada pela carta arrastada quando o drag termina.
	# Se a carta voltou para a mão e o mouse ainda está sobre ela, 
	# ativamos a flag para ignorar o hover.
	var mouse_pos = get_viewport().get_mouse_position()
	if dragged_card.is_in_hand and dragged_card.get_global_rect().has_point(mouse_pos):
		ignore_hover_until_mouse_leaves = true
		last_dragged_card = dragged_card
		# Desativa o hover imediatamente na carta que acabou de ser solta/voltou
		dragged_card.z_index = 0
		dragged_card.scale = dragged_card.original_scale
		hovered_card = null # Garante que nenhuma carta está em hover ativo neste momento

func get_card_position(index: int) -> Vector2:
	var cards = get_child_count()
	if cards == 0 or index < 0 or index >= cards:
		return global_position

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
		emit_signal("card_drawn", new_card)

func discard() -> void:
	while get_child_count() >= 1:
		var child = get_child(-1)
		child.reparent(get_tree().root)
		child.queue_free()
		update_cards()
		await get_tree().create_timer(0.1).timeout
		
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
