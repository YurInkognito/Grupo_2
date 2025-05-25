# Control.gd
extends Control

@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3
@onready var button_tutorial: Button = $Tutorial/Button

@onready var mana_label: Label = $mana_label
@onready var turno_label: Label = $turno_label
@onready var deck_label: Label = $deck/Label

@export var caminho_pasta_cartas: String = "res://Cartas/"

@export var lista_de_cartas: Array[CartaData]
@export var deck = []
@export var n_compras = 5

@onready var hand_node: Control = $hand # Garanta que o nome do seu nó 'hand' esteja correto e seja do tipo 'hand'
@onready var deck_node: Node2D = $deck # Crie um Position2D chamado 'DeckPosition' na sua cena para marcar a origem da animação

@export var principal: String = ""
@export var principal_pontos: int = 0
@export var mana: int = 0
@export var max_mana: int = 3
@export var turno: int = 1
@export var max_turno: int = 5

#pontuação
@export var tipo_prato: String = "Prato"
@export var sabor: int = 0
@export var sabor_continuo: int = 0
@export var mult: int = 1
@export var sal: float = 1
@export var queijos: Array[int]
@export var tags_prato: Array[String]

#efeitos
@export var prox_double: Array[String] = []
@export var prox_zero: Array[String] = []
@export var sabor_Suave: int = 0
@export var sabor_Picante: int = 0
@export var sabor_Umami: int = 0
@export var sabor_Sopa: int = 0
@export var sabor_Sanduiche: int = 0
@export var sabor_Salada: int = 0

#cena da config
const CONFIG = preload("res://scenes/config.tscn")

func _ready() -> void:
	button.pressed.connect(on_end_turn_pressed)
	button_2.pressed.connect(reset_game)
	button_3.pressed.connect(end_game)
	button_tutorial.pressed.connect(close_tutorial)
	mana = max_mana
	
	# gerenciamento de cartas
	#carregar_todas_as_cartas()
	var novo_deck = gerar_deck()
	print("Deck gerado com cartas carregadas da pasta:")
	for carta in novo_deck:
		print("- " + carta.nome)
	on_draw_button_pressed()

func _process(delta: float) -> void:
	mana_label.text = str(mana) + '/' + str(max_mana)
	turno_label.text = 'Turno ' + str(turno) + '/' + str(max_turno)
	deck_label.text = str(deck.size())

func close_tutorial():
	$Tutorial.visible = false

func on_draw_button_pressed(inicial: bool = true):
	var card_data = null
	var quant = 1
	var new_card_instance
	if inicial:
		quant = n_compras
	for i in range(quant):
		if not deck.is_empty():
			card_data = deck.pop_front()
			var new_card_scene = preload("res://scenes/card.tscn")
			new_card_instance = new_card_scene.instantiate()
			hand_node.add_child(new_card_instance) # Adiciona a carta na 'hand' imediatamente

			# Define os dados da carta
			new_card_instance.set_card(card_data)

			# Define a posição inicial da animação (a posição do deck)
			new_card_instance.global_position = deck_node.global_position
			new_card_instance.scale = Vector2(0.5, 0.5) # Começa menor

			# Calcula a posição final da carta na mão (agora a responsabilidade está na 'hand')
			var target_position = hand_node.get_card_position(hand_node.get_child_count() - 1)

			# Cria um Tween para a animação de movimento
			var move_tween = create_tween()
			move_tween.tween_property(new_card_instance, "global_position", target_position, 0.3)\
				.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

			# Cria um Tween para a animação de escala
			var scale_tween = create_tween()
			scale_tween.tween_property(new_card_instance, "scale", Vector2(1.0, 1.0), 0.3)\
				.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

			await get_tree().create_timer(0.1).timeout # Pequeno delay entre as compras

			# A 'hand' cuidará de posicionar as cartas após a animação
			hand_node.update_cards()
		else:
			print("O deck está vazio!")
			break
	if (!inicial):
		return new_card_instance

func on_discard_button_pressed():
	hand_node.discard()

func gastar_mana(custo: int):
	mana = mana - custo

func start_turn():
	turno = turno + 1
	mana = max_mana
	on_draw_button_pressed()

func end_game():
	get_tree().change_scene_to_file("res://scenes/tela_resultado.tscn")

func on_end_turn_pressed():
	if turno >= max_turno:
		end_game()
	else:
		on_discard_button_pressed()
		await get_tree().create_timer(1).timeout 
		start_turn()

func reset_game():
	#resetando todos os valores do jogo
	on_discard_button_pressed()
	mana = max_mana
	turno = 1
	principal = ''
	principal_pontos = 0
	tipo_prato =  "Prato"
	sabor = 0
	sabor_continuo = 0
	sal = 1
	queijos = []
	tags_prato = []
	prox_double = []
	prox_zero = []
	sabor_Suave = 0
	sabor_Picante = 0
	sabor_Umami = 0
	var prato_temp = $prato
	$Info.set_pontos(0)
	for i in range(prato_temp.get_child_count() - 1, -1, -1):
		var child = prato_temp.get_child(i)
		prato_temp.remove_child(child)
		child.queue_free()
	await get_tree().create_timer(1).timeout 
	#carregar_todas_as_cartas()
	var novo_deck = gerar_deck()
	print("Deck gerado com cartas carregadas da pasta:")
	for carta in novo_deck:
		print("- " + carta.nome)
	on_draw_button_pressed()

func gerar_deck():
	deck.clear() # Limpa o deck anterior, se houver
	var cartas_para_adicionar = []

	# Adiciona as cópias de cada carta à lista temporária
	for carta in lista_de_cartas:
		for _i in range(2): # numero de cartas repetidas por deck
			cartas_para_adicionar.append(carta)

	randomize()
	for i in range(cartas_para_adicionar.size() - 1, 0, -1):
		var j = randi_range(0, i)
		var temp = cartas_para_adicionar[i]
		cartas_para_adicionar[i] = cartas_para_adicionar[j]
		cartas_para_adicionar[j] = temp

	# O deck final é a lista randomizada
	deck = cartas_para_adicionar
	return deck

func encontrar_carta_data_por_nome(nome: String) -> CartaData:
	for carta_data in lista_de_cartas:
		if carta_data.nome == nome:
			return carta_data
	printerr("CartaData com o nome '", nome, "' não encontrado.")
	return null

func encontrar_mais_frequente(array: Array) -> Variant:
	if array.is_empty():
		return null

	var frequencias = {}
	for elemento in array:
		if frequencias.has(elemento):
			frequencias[elemento] += 1
		else:
			frequencias[elemento] = 1

	var elemento_mais_frequente
	var frequencia_maxima = -1

	for elemento in frequencias.keys():
		if frequencias[elemento] > frequencia_maxima:
			frequencia_maxima = frequencias[elemento]
			elemento_mais_frequente = elemento

	return elemento_mais_frequente

func gerar_nome():
	var vibe = encontrar_mais_frequente(tags_prato)
	var nome = ''
	if vibe:
		nome = tipo_prato + ' ' + vibe + ' de ' + principal
	return nome

func compara_principal(pontos, nome):
	if pontos > principal_pontos:
		principal_pontos = pontos
		principal = nome

func reseta_prox_zero():
	prox_zero = []

func aplicar_efeitos_carta(carta: CartaData):
	var sabor_aux = sabor
	for efeito in carta.efeitos_ao_jogar:
		if efeito.has("funcao") && has_method(efeito["funcao"]):
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
			if ((sabor - sabor_aux) >= principal_pontos):
				principal_pontos = sabor - sabor_aux
				principal = carta.nome
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", carta.nome, "'.")
	if tags_prato.count("Refrescante") >= 4 && tipo_prato == "Prato":
		tipo_prato = "Salada"
	pontuação_continua()
	calculo_mult()
	$Info.set_pontos(sabor + sabor_continuo)
	$"/root/GlobalData".set_sabor(sabor + sabor_continuo)
	$"/root/GlobalData".set_mult(mult)
	$"/root/GlobalData".set_tags(tags_prato)
	$"/root/GlobalData".set_cliente(1)
	print(sabor)

func pontuação_continua():
	sabor_continuo = 0
	
	#sabor de tags
	sabor_continuo = sabor_continuo + sabor_Suave * tags_prato.count('Suave')
	sabor_continuo = sabor_continuo + sabor_Picante * tags_prato.count('Picante')
	sabor_continuo = sabor_continuo + sabor_Umami * tags_prato.count('Umami')
	
	#sabor de prato
	match tipo_prato:
		"Sopa": sabor_continuo = sabor_continuo + sabor_Sopa
		"Sanduiche": sabor_continuo = sabor_continuo + sabor_Sanduiche
		"Salada": sabor_continuo = sabor_continuo + sabor_Salada
	
	#queijos
	print(queijos)
	for q in queijos:
		sabor_continuo = sabor_continuo + (q * queijos.size())
	
	#sal
	sabor_continuo = sabor_continuo * sal

func calculo_mult():
	var primario = encontrar_mais_frequente(tags_prato)
	var unicas = []
	var frequencias = {}
	var contagem_frequencias = {}
	var maior_repeticao = 0
	
	for t in tags_prato:
		if unicas.count(t) == 0:
			unicas.append(t)
		frequencias[t] = frequencias.get(t, 0) + 1
	
	for freq in frequencias.values():
		contagem_frequencias[freq] = contagem_frequencias.get(freq, 0) + 1
		if contagem_frequencias[freq] > maior_repeticao:
			maior_repeticao = contagem_frequencias[freq]
	
	match tipo_prato:
		'Prato': $Info.set_mult(1); mult = 1
		'Sopa': $Info.set_mult(tags_prato.count(primario)); mult = tags_prato.count(primario)
		'Sanduiche': $Info.set_mult(unicas.size()); mult = unicas.size()
		'Salada': $Info.set_mult(maior_repeticao); mult = maior_repeticao

func jogar_carta(carta: CartaData):
	print("Carta jogada:", carta.nome)
	tags_prato.append_array(carta.tags)
	aplicar_efeitos_carta(carta)
	for i in prox_double:
		if (carta.tags.count(i) > 0):
			prox_double.erase(i)
			aplicar_efeitos_carta(carta)
			return null

#lista de acoes executaveis pelas cartas:

func mostrar_mensagem(mensagem: String):
	print("Mensagem da Carta:", mensagem)

func add_sabor(pontos: String):
	sabor = sabor + int(pontos) * sal

func sal_mult(mult: String):
	sal = sal * float(mult)

func set_sanduiche():
	tipo_prato = "Sanduiche"
	
func set_sopa():
	tipo_prato = "Sopa"

func compra():
	on_draw_button_pressed(false)

func add_sabor_queijo(pontos: String):
	queijos.append(int(pontos))

func add_sabor_tag(pontos: String, tag: String):
	match tag:
		"Suave": sabor_Suave = sabor_Suave + int(pontos)
		"Picante": sabor_Picante = sabor_Picante + int(pontos)
		"Umami": sabor_Umami = sabor_Umami + int(pontos)

func add_sabor_prato(pontos: String, prato: String):
	match prato:
		"Sopa": sabor_Sopa += int(pontos)
		"Sanduiche": sabor_Sanduiche += int(pontos)
		"Salada": sabor_Salada += int(pontos)

func prox_ingrediente_double(tag: String):
	prox_double.append(tag)

func bota_na_mao(carta: String):
	var new_card_scene = preload("res://scenes/card.tscn")
	var new_card_instance = new_card_scene.instantiate()
	hand_node.add_child(new_card_instance) # Adiciona a carta na 'hand' imediatamente

	# Define os dados da carta
	new_card_instance.set_card(encontrar_carta_data_por_nome(carta))
	hand_node.update_cards()

func compra_custo_0():
	var card = await on_draw_button_pressed(false)
	print(card.custo_t)
	card.custo_t = '0'
	card.custo.text = '0'

func prox_ingrediente_zero(tag: String):
	print(tag)
	prox_zero.append(tag)

func mais_tag(vezes: String):
	var x = 0
	while x < int(vezes):
		tags_prato.append(encontrar_mais_frequente(tags_prato))
		x += 1

func gera_mana(tag: String):
	mana = mana + tags_prato.count(tag)


func _on_config_button_pressed() -> void:
	var config_instance = CONFIG.instantiate()
	add_child(config_instance)
