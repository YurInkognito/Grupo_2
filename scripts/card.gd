class_name card
extends Panel

const SIZE = Vector2(100, 140)

@onready var sfx_select_card: AudioStreamPlayer2D = $SFXSelectCard
@onready var sfx_throw_card: AudioStreamPlayer2D = $SFXThrowCard

@export var card_vazia: Texture2D

@export var nome_t: String
@export var desc_t: String
@export var custo_t: String
@export var ingrediente_t: bool = false
@export var card_data: CartaData

@export var processo: Texture2D
@export var umami: Texture2D
@export var refrescante: Texture2D
@export var crocante: Texture2D
@export var acido: Texture2D
@export var picante: Texture2D
@export var suave: Texture2D

@onready var control: ColorRect = $"../../ColorRect"
@onready var prato: ColorRect = $"../../prato"
@onready var hand_node = $".." # Referência ao nó 'hand'

@onready var nome: Label = $nome
@onready var desc: RichTextLabel = $desc
@onready var custo: Label = $custo
@onready var sprite: Sprite2D = $Bg
@onready var tags: Label = $tags

@onready var processavel: TextureRect = $processavel

@onready var tag1: Sprite2D = $Tag1
@onready var tag2: Sprite2D = $Tag2
@onready var tag3: Sprite2D = $Tag3
var lista_tags: Array[Sprite2D]

var original_position: Vector2
var original_size: Vector2
var drag_offset: Vector2

var is_dragging: bool = false
var is_in_hand: bool = true
var is_playable: bool = true
var is_played: bool = false

var is_waiting = false

var original_scale
@export var scale_factor = 2

func _ready() -> void:
	lista_tags = [tag1,tag2,tag3]
	nome.text = nome_t
	desc.text = desc_t
	custo.text = custo_t
	original_scale = scale
	# Definir mouse_filter para Pass para que o pai (hand) processe os eventos
	mouse_filter = MOUSE_FILTER_PASS

func set_card(carta: CartaData) -> void:
	lista_tags[0].texture = null
	lista_tags[1].texture = null
	lista_tags[2].texture = null
	nome.text = carta.nome
	desc.text = carta.desc
	custo.text = carta.custo
	nome_t = carta.nome
	desc_t = carta.desc
	custo_t = carta.custo
	ingrediente_t = carta.ingrediente
	card_data = carta
	if carta.on_faca or carta.on_fogo or carta.on_martelo:
		processavel.visible = true
	else:
		processavel.visible = false
	if carta.sprite:
		nome.visible = false
		sprite.texture = carta.sprite
	else:
		nome.visible = true
		sprite.texture = card_vazia
	var texto_tags = ''
	var c = 0
	if carta.is_processo:
		lista_tags[c].texture = processo
		lista_tags[0].visible = true
	for t in carta.tags:
		texto_tags = texto_tags + t + ' '
		match t:
			"Acido": lista_tags[c].texture = acido
			"Crocante": lista_tags[c].texture = crocante
			"Picante": lista_tags[c].texture = picante
			"Refrescante": lista_tags[c].texture = refrescante
			"Suave": lista_tags[c].texture = suave
			"Umami": lista_tags[c].texture = umami
		lista_tags[c].visible = true
		c += 1
	tags.text = texto_tags
	if is_played:
		efeito_on_board()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_in_hand and is_playable:
			# Atualiza a flag global de drag no hand_node
			hand_node.is_dragging_global = true
			start_drag(event, true)
		elif event.pressed and is_played:
			hand_node.is_dragging_global = true
			start_drag(event, false)
		elif not event.pressed and is_dragging:
			end_drag()
			# Atualiza a flag global de drag no hand_node
			hand_node.is_dragging_global = false
			# Simula um evento de mouse motion no hand_node para reavaliar o hover
			# Isso garante que o hand_node atualize o hover imediatamente após o drag
			hand_node._input(InputEventMouseMotion.new())

func _on_mouse_entered():
	if not card_data.upgrade:
		if hand_node.is_dragging_global:
			print("entrei com hover")
			is_waiting = true
		if not is_in_hand and not hand_node.is_dragging_global and not is_waiting:
			z_index = 10
			scale = original_scale * scale_factor
	else:
		z_index = 10
		scale = original_scale * scale_factor

func _on_mouse_exited():
	if not card_data.upgrade:
		print("sai" + nome_t)
		is_waiting = false
		if not is_in_hand and not hand_node.is_dragging_global:
			z_index = 0
			scale = original_scale
	else:
		z_index = 0
		scale = original_scale

func start_drag(event: InputEventMouseButton, from_hand: bool):
	if card_data.upgrade:
		print("test")
		card_data.upgrade = false
		get_node("..").select_card(card_data)
	else:
		sfx_select_card.play()
		is_dragging = true
		drag_offset = position - get_global_mouse_position()
		
		# Efeitos visuais
		# z_index e scale agora são controlados pelo hand_node quando a carta não está em drag
		# Quando a carta está sendo arrastada, ela deve estar acima de tudo
		z_index = 100 # Um Z-index bem alto para garantir que a carta arrastada esteja no topo
		scale = Vector2(1.2, 1.2)
		self.rotation = 0
		if from_hand:
			get_node("..").update_cards()

func end_drag():
	sfx_throw_card.play()
	if is_played:
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
	
	# Restaura z_index e scale para que o hand_node possa controlá-los novamente
	z_index = 0
	scale = original_scale

func get_drop_area(from_hand: bool) -> Control:
	var mouse_pos = get_global_mouse_position()
	
	var play_areas = get_tree().get_nodes_in_group("area_final")
	if from_hand:
		play_areas = get_tree().get_nodes_in_group("area")
	for area in play_areas:
		if area.get_global_rect().has_point(mouse_pos):
			return area
	return null

func play_card(play_area: Control):
	is_in_hand = false
	is_playable = false
	play_area.drop_card(self)
	
	emit_signal("card_played", self)

func return_to_hand():
	get_node("..").update_cards()

func _process(delta):
	if is_dragging:
		position = get_global_mouse_position() + drag_offset

func efeito_on_board():
	for efeito in card_data.efeitos_on_board:
		if efeito.has("funcao") && is_played && has_method(efeito["funcao"]):
			var funcao_nome = efeito["funcao"]
			var parametro = efeito.get("parametro")
			if parametro is Array:
				match parametro.size():
					1:
						call(funcao_nome, parametro[0])
					2:
						call(funcao_nome, parametro[0], parametro[1])
					3:
						call(funcao_nome, parametro[0], parametro[1], parametro[2])
			elif parametro:
				call(funcao_nome, parametro)
			else:
				call(funcao_nome)
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", card_data.nome, "'.")

func on_efeito_carta_on_board():
	for efeito in card_data.efeitos_on_board:
		if efeito.has("funcao") && is_played && has_method(efeito["funcao"]):
			var funcao_nome = efeito["funcao"]
			var parametro = efeito.get("parametro")
			if parametro is Array:
				match parametro.size():
					1:
						call(funcao_nome, parametro[0])
					2:
						call(funcao_nome, parametro[0], parametro[1])
					3:
						call(funcao_nome, parametro[0], parametro[1], parametro[2])
			elif parametro:
				call(funcao_nome, parametro)
			else:
				call(funcao_nome)
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", card_data.nome, "'.")

func bota_na_mao(carta: String):
	$"../../..".bota_na_mao(carta)

func add_mao_por_turno(carta: String):
	$"../../..".add_mao_por_turno(carta)
