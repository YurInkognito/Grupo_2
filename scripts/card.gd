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

@export var mana0: Texture2D
@export var mana1: Texture2D
@export var mana2: Texture2D
@export var mana3: Texture2D

@onready var hover_layer: Panel = $"../../Hover"
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
var is_hover: bool = false
var tem_mana: bool = false
@export var is_played: bool = false

var visual = false

var is_waiting = false

var original_scale
@export var scale_factor = 2
var hover_element

@export var float_amplitude_y: float = 5.0
@export var float_duration: float = 1.5
@export var float_amplitude_x: float = 3.0

func _ready() -> void:
	print("teste")
	lista_tags = [tag1,tag2,tag3]
	nome.text = nome_t
	desc.text = desc_t
	custo.text = custo_t
	match int(custo_t):
		0: $Mana_custo.texture = mana0
		1: $Mana_custo.texture = mana1
		2: $Mana_custo.texture = mana2
		3: $Mana_custo.texture = mana3
	original_scale = scale

func substituir_palavras_por_tags(texto_original: String) -> String:
	var substituicoes: Dictionary = {
		"Acido": "[img width=40 height=40]res://sprites/TAGS/TAG5.png[/img]",
		"Crocante": "[img width=40 height=40]res://sprites/TAGS/TAG4.png[/img]",
		"Picante": "[img width=40 height=40]res://sprites/TAGS/TAG6.png[/img]",
		"Refrescante": "[img width=40 height=40]res://sprites/TAGS/TAG3.png[/img]",
		"Suave": "[img width=40 height=40]res://sprites/TAGS/TAG7.png[/img]",
		"Umami": "[img width=40 height=40]res://sprites/TAGS/TAG2.png[/img]",
		
		# Versões em minúsculo
		"acido": "[img width=40 height=40]res://sprites/TAGS/TAG5.png[/img]",
		"crocante": "[img width=40 height=40]res://sprites/TAGS/TAG4.png[/img]",
		"picante": "[img width=40 height=40]res://sprites/TAGS/TAG6.png[/img]",
		"refrescante": "[img width=40 height=40]res://sprites/TAGS/TAG3.png[/img]",
		"suave": "[img width=40 height=40]res://sprites/TAGS/TAG7.png[/img]",
		"umami": "[img width=40 height=40]res://sprites/TAGS/TAG2.png[/img]"
	}

	var texto_modificado = texto_original
	for palavra in substituicoes:
		# A função 'replace' substitui todas as ocorrências da palavra.
		texto_modificado = texto_modificado.replace(palavra, substituicoes[palavra])
		
	return texto_modificado
	
func set_card(carta: CartaData, zerado = false) -> void:
	lista_tags[0].texture = null
	lista_tags[1].texture = null
	lista_tags[2].texture = null
	nome.text = carta.nome
	desc.text = substituir_palavras_por_tags(carta.desc)
	custo.text = carta.custo
	match int(carta.custo):
		0: $Mana_custo.texture = mana0
		1: $Mana_custo.texture = mana1
		2: $Mana_custo.texture = mana2
		3: $Mana_custo.texture = mana3
	nome_t = carta.nome
	desc_t = substituir_palavras_por_tags(carta.desc)
	custo_t = carta.custo
	ingrediente_t = carta.ingrediente
	if zerado:
		custo.text = "0"
		custo_t = "0"
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
	if carta.upgrade:
		is_in_hand = false
		is_played = true

func _gui_input(event: InputEvent):
	if not visual:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_in_hand and is_playable:
				hand_node.is_dragging_global = true
				start_drag(event, true)
			elif event.pressed and is_played:
				hand_node.is_dragging_global = true
				start_drag(event, false)
			elif not event.pressed and is_dragging:
				end_drag()
				hand_node.is_dragging_global = false
				mouse_filter = Control.MOUSE_FILTER_IGNORE
				mouse_filter = Control.MOUSE_FILTER_PASS

func start_floating(element_to_float) -> void:
	var original_y: float = element_to_float.position.y
	var original_x: float = element_to_float.position.x # Posição X original
	
	var float_tween = element_to_float.create_tween()
	float_tween.set_loops()
	
	float_tween.tween_property(element_to_float, "position:y", original_y - float_amplitude_y, float_duration / 2.0)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
	float_tween.tween_property(element_to_float, "position:y", original_y, float_duration / 2.0)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
	#float_tween.tween_property(element_to_float, "position:x", original_x + float_amplitude_x, float_duration / 2.0)\
		#.set_delay(float_duration / 4.0)\
		#.set_ease(Tween.EASE_IN_OUT)\
		#.set_trans(Tween.TRANS_SINE)
	#float_tween.tween_property(element_to_float, "position:x", original_x - float_amplitude_x, float_duration / 2.0)\
		#.set_ease(Tween.EASE_IN_OUT)\
		#.set_trans(Tween.TRANS_SINE)
	#float_tween.tween_property(element_to_float, "position:x", original_x, float_duration / 2.0)\
		#.set_ease(Tween.EASE_IN_OUT)\
		#.set_trans(Tween.TRANS_SINE)
	#
	float_tween.finished.connect(element_to_float.queue_free.bind())

func stop_floating(element_to_delete) -> void:
	pass
	
func _on_mouse_entered():
	print("tentando hover")
	if visual == true:
		print("consegui hover visual")
		$SFXThrowCard.play()
		hover_element = duplicate()
		if is_played:
			hover_element.is_hover = true
		get_tree().get_nodes_in_group("Hover")[0].add_child(hover_element)
		hover_element.global_position = global_position
		hover_element.scale = scale * 2
		start_floating(hover_element)
		hover_element.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif hand_node.is_dragging_global == false:
		print("consegui hover")
		$SFXThrowCard.play()
		hover_element = duplicate()
		if is_played:
			hover_element.is_hover = true
		hover_layer.add_child(hover_element)
		hover_element.global_position = global_position
		hover_element.scale = scale * 2
		start_floating(hover_element)
		hover_element.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_exited():
	if hover_element: 
		stop_floating(hover_element)
		hover_element.queue_free()

func start_drag(event: InputEventMouseButton, from_hand: bool):
	if card_data.upgrade:
		print("test")
		card_data.upgrade = false
		get_node("..").select_card(card_data)
	else:
		if tem_mana or is_played:
			if hover_element: hover_element.queue_free()
			hand_node.on_drag_started_globally(self)
			sfx_select_card.play()
			is_dragging = true
			drag_offset = position - get_global_mouse_position()
			z_index = 100 # Um Z-index bem alto para garantir que a carta arrastada esteja no topo
			scale = Vector2(1.2, 1.2)
			self.rotation = 0
			if from_hand:
				get_node("..").update_cards()
		else:
			if hover_element: hover_element.queue_free()
			hand_node.is_dragging_global = false
			_on_mouse_entered()

func end_drag():
	hand_node.on_drag_ended_globally(self)
	sfx_throw_card.play()
	if is_played:
		if get_tree().get_first_node_in_group("control").dia_finalizado:
			is_dragging = false
			position = Vector2(0.0, 0.0)
			return false
		var drop_area = get_drop_area(false)
		if drop_area:
			if drop_area.prato_check:
				is_dragging = false
				is_played = false
				get_parent().on_dentro_pressed()
			elif drop_area.lixo_check:
				get_parent().on_lixo_pressed()
			else:
				print("mover")
				if drop_area.can_accept_card(self):
					print("mover 2")
					get_parent().carta_movida()
					is_dragging = false
					play_card(drop_area, true)
				else:
					print("trocar")
					is_dragging = false
					get_parent().trocar_carta(drop_area)
		else:
			is_dragging = false
			position = Vector2(0.0, 0.0)
	else:
		if get_tree().get_first_node_in_group("control").dia_finalizado:
			is_dragging = false
			return_to_hand()
			return false
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

func play_card(play_area: Control, move = false):
	is_in_hand = false
	is_playable = false
	play_area.drop_card(self, move)
	
	emit_signal("card_played", self)

func return_to_hand():
	get_node("..").update_cards()

func _process(delta):
	if not is_hover and !visual and is_in_hand and card_data and get_node("../..") and int(custo_t) <= get_node("../..").mana:
		tem_mana = true
		$aura.visible = true
	else:
		tem_mana = false
		$aura.visible = false
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
