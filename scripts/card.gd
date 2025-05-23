class_name card
extends Panel

const SIZE = Vector2(100, 140)

@export var nome_t: String
@export var desc_t: String
@export var custo_t: String
@export var ingrediente_t: bool = false
@export var card_data: CartaData

@onready var control: ColorRect = $"../../ColorRect"
@onready var prato: ColorRect = $"../../prato"

@onready var nome: Label = $nome
@onready var desc: Label = $desc
@onready var custo: Label = $custo

var original_position: Vector2
var original_size: Vector2
var drag_offset: Vector2

var is_dragging: bool = false
var is_in_hand: bool = true
var is_playable: bool = true
var is_played: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nome.text = nome_t
	desc.text = desc_t
	custo.text = custo_t

func set_card(carta: CartaData) -> void:
	nome.text = carta.nome
	desc.text = carta.desc
	custo.text = carta.custo
	nome_t = carta.nome
	desc_t = carta.desc
	custo_t = carta.custo
	ingrediente_t = carta.ingrediente
	card_data = carta

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_in_hand and is_playable:
			start_drag(event, true)
		elif event.pressed and is_played:
			start_drag(event, false)
		elif not event.pressed and is_dragging:
			end_drag()

func start_drag(event: InputEventMouseButton, from_hand: bool):
	is_dragging = true
	drag_offset = position - get_global_mouse_position()
	# Efeitos visuais
	z_index = 10
	scale = Vector2(1.2, 1.2)
	self.rotation = 0
	if from_hand:
		get_node("..").update_cards()
	

func end_drag():
	print("enddrag card")
	if is_played:
		print('played')
		var drop_area = get_drop_area(false)
		if drop_area:
			if drop_area.prato:
				is_dragging = false
				is_played = false
				get_parent().on_dentro_pressed()
			else:
				get_parent().on_lixo_pressed()
		else:
			is_dragging = false
			position = Vector2(0.0, 0.0)
			
	else:
		print('teste')
		# Verifica se foi solta em uma área válida
		var drop_area = get_drop_area(true)
		if drop_area and drop_area.can_accept_card(self) and !card_data.is_processo:
			is_dragging = false
			is_played = true
			play_card(drop_area)
		elif card_data.is_processo and drop_area and drop_area.drop_processo(self):
			is_dragging = false
			queue_free()
		else:
			is_dragging = false
			return_to_hand()
	
	# Restaura efeitos visuais
	z_index = 0
	scale = Vector2(1.0, 1.0)

func get_drop_area(from_hand: bool) -> Control:
	# Obtém a posição do mouse
	var mouse_pos = get_global_mouse_position()
	
	# Verifica todas as áreas de jogo
	var play_areas = get_tree().get_nodes_in_group("area_final")
	if from_hand:
		play_areas = get_tree().get_nodes_in_group("area")
	for area in play_areas:
		if area.get_global_rect().has_point(mouse_pos):
			return area
	return null

func play_card(play_area: Control):
	print("card playing")
	is_in_hand = false
	is_playable = false
	play_area.drop_card(self)
	#get_parent().remove_child(self)
	#play_area.add_child(self)
	#position = Vector2.ZERO
	#rotation_degrees = 0
	
	emit_signal("card_played", self)

func return_to_hand():
	# Animação de retorno à mão
	#var tween = create_tween()
	#tween.tween_property(self, "position", original_position, 0.3)\
		#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	#tween.parallel().tween_property(self, "size", original_size, 0.3)
	get_node("..").update_cards()

func _process(delta):
	if is_dragging:
		# Atualiza posição mantendo o offset do clique
		position = get_global_mouse_position() + drag_offset

func on_efeito_carta_on_board():
	print("vi processo")
	print(card_data.nome)
	for efeito in card_data.efeitos_on_board:
		if efeito.has("funcao") && is_played && has_method(efeito["funcao"]):
			var funcao_nome = efeito["funcao"]
			var parametro = efeito.get("parametro") # get para lidar com parâmetros opcionais
			if parametro is Array:
				match parametro.size():
					1:
						call(funcao_nome, parametro[0])
					2:
						call(funcao_nome, parametro[0], parametro[1])
					3:
						call(funcao_nome, parametro[0], parametro[1], parametro[2])
			elif parametro:
				print(parametro)
				call(funcao_nome, parametro)
			else:
				call(funcao_nome)
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", card_data.nome, "'.")

#funcoes on board

func bota_na_mao(carta: String):
	print("botando na mao")
	$"../../..".bota_na_mao(carta)
