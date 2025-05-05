# Control.gd
extends Control

@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var mana_label: Label = $mana_label

@export var caminho_pasta_cartas: String = "res://Cartas/"

var todas_as_cartas = [] # Preencha com seus Resources de CartaData
@export var deck = []
@export var n_compras = 5

@onready var hand_node: Control = $hand # Garanta que o nome do seu nó 'hand' esteja correto e seja do tipo 'hand'
@onready var deck_node: Node2D = $deck # Crie um Position2D chamado 'DeckPosition' na sua cena para marcar a origem da animação

@export var principal: String = ""
@export var principal_pontos: int = 0
@export var mana: int = 0
@export var max_mana: int = 3

#pontuação
@export var tipo_prato: String = "Prato"
@export var sabor: int = 0
@export var sal: float = 1
@export var queijo: int = 0
@export var tags_prato: Array[String]

@export var prox_double: String = ""

func _ready() -> void:
	button.pressed.connect(on_end_turn_pressed)
	button_2.pressed.connect(reset_game)
	mana = max_mana
	
	# gerenciamento de cartas
	carregar_todas_as_cartas()
	var novo_deck = gerar_deck()
	print("Deck gerado com cartas carregadas da pasta:")
	for carta in novo_deck:
		print("- " + carta.nome)
	on_draw_button_pressed()

func _process(delta: float) -> void:
	mana_label.text = str(mana)

func on_draw_button_pressed(inicial: bool = true):
	var card_data = null
	var quant = 1
	if inicial:
		quant = n_compras
	for i in range(quant):
		if not deck.is_empty():
			card_data = deck.pop_front()
			var new_card_scene = preload("res://scenes/card.tscn")
			var new_card_instance = new_card_scene.instantiate()
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

func on_discard_button_pressed():
	hand_node.discard()

func gastar_mana(custo: int):
	mana = mana - custo

func start_turn():
	mana = max_mana
	on_draw_button_pressed()

func on_end_turn_pressed():
	on_discard_button_pressed()
	await get_tree().create_timer(1).timeout 
	start_turn()

func reset_game():
	on_discard_button_pressed()
	await get_tree().create_timer(1).timeout 
	carregar_todas_as_cartas()
	var novo_deck = gerar_deck()
	print("Deck gerado com cartas carregadas da pasta:")
	for carta in novo_deck:
		print("- " + carta.nome)
	on_draw_button_pressed()

func carregar_todas_as_cartas():
	todas_as_cartas.clear()
	var dir_access = DirAccess.open(caminho_pasta_cartas)
	if dir_access:
		dir_access.list_dir_begin()
		var arquivo_nome = dir_access.get_next()
		while arquivo_nome != "":
			if arquivo_nome.get_extension().to_lower() == "tres":
				var caminho_completo = caminho_pasta_cartas + "/" + arquivo_nome # Use o operador "/" para combinar caminhos
				var carta_resource = load(caminho_completo)
				if carta_resource is CartaData: # Verifique se o Resource carregado é do tipo CartaData
					todas_as_cartas.append(carta_resource)
				elif carta_resource != null:
					printerr("Aviso: Arquivo não é um CartaData Resource: ", caminho_completo)
			arquivo_nome = dir_access.get_next()
		dir_access.list_dir_end()
		print("Cartas carregadas automaticamente: ", todas_as_cartas.size())
	else:
		printerr("Erro ao acessar a pasta: ", caminho_pasta_cartas)

func gerar_deck():
	deck.clear() # Limpa o deck anterior, se houver
	var cartas_para_adicionar = []

	# Adiciona as cópias de cada carta à lista temporária
	for carta in todas_as_cartas:
		for _i in range(2): # numero de cartas repetidas por deck
			cartas_para_adicionar.append(carta)

	# Randomiza a ordem da lista (Fisher-Yates Shuffle)
	randomize()
	for i in range(cartas_para_adicionar.size() - 1, 0, -1):
		var j = randi_range(0, i)
		var temp = cartas_para_adicionar[i]
		cartas_para_adicionar[i] = cartas_para_adicionar[j]
		cartas_para_adicionar[j] = temp

	# O deck final é a lista randomizada
	deck = cartas_para_adicionar
	return deck

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
	$Info.set_pontos(sabor)
	print(sabor)

func jogar_carta(carta: CartaData):
	print("Carta jogada:", carta.nome)
	tags_prato.append_array(carta.tags)
	aplicar_efeitos_carta(carta)
	if (carta.tags.count(prox_double) > 0):
		prox_double = ""
		aplicar_efeitos_carta(carta)

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
	
func set_salada():
	tipo_prato = "Salada"
	
func set_massa():
	tipo_prato = "Massa"

func compra():
	on_draw_button_pressed(false)

func add_sabor_queijo(pontos: String):
	queijo = queijo + 1
	sabor = sabor + queijo * int(pontos)

func add_sabor_tag(pontos: String, tag: String):
	sabor = sabor + int(pontos) * tags_prato.count(tag)

func prox_ingrediente_double(tag: String):
	prox_double = tag
