# Control.gd
extends Control

@onready var button = $Button
@onready var button_2 = $Button2
@onready var button_3 = $Button3
@onready var button_4 = $Button4
@onready var button_5 = $Button5
@onready var button_abrir_cliente = $button_abrir_cliente
@onready var button_tutorial = $Tutorial/Button
@onready var button_tutorial2 = $Tutorial2/Button
@onready var button_tutorial3 = $Tutorial3/Button
@onready var button_cliente = $Cliente/Button
@onready var cooldown_timer = $Button/Timer

@export var numero_flutuante: PackedScene

@onready var dia: Label = $Dia
@onready var mana_label: Label = $mana_label
@onready var max_mana_label: Label = $max_mana_label
@onready var turno_label: Label = $turno_label
@onready var deck_label: Label = $deck/Label
@onready var cliente_label: RichTextLabel = $Cliente/Panel/Label5
@onready var cliente_foto: TextureRect = $Cliente/TextureRect

@export var caminho_pasta_cartas: String = "res://Cartas/"

@export var lista_de_cartas: Array[CartaData]
@export var lista_de_cartas_tutorial: Array[CartaData]
@export var deck = []
@export var n_compras = 6
var em_cooldown: bool = false

@export var foto_1: Texture2D
@export var foto_2: Texture2D
@export var foto_3: Texture2D
@export var foto_4: Texture2D
@export var foto_5: Texture2D
@export var foto_6: Texture2D

@onready var hand_node: Control = $hand # Garanta que o nome do seu nó 'hand' esteja correto e seja do tipo 'hand'
@onready var deck_node: Node2D = $deck # Crie um Position2D chamado 'DeckPosition' na sua cena para marcar a origem da animação

@export var principal: String = "nada"
@export var principal_pontos: int = 0
@export var mana: int = 0
@export var max_mana: int = 3
@export var turno: int = 1
@export var max_turno: int = 5
@export var cool_down_end_turn = 1

#pontuação
@export var tipo_prato: String = "Prato"
@export var sabor: int = 0
@export var sabor_continuo: int = 0
@export var mult: int = 1
@export var tags_prato: Array[String]
@export var ingredientes_prato: Array[String]

#efeitos
@export var sal: float = 1
@export var queijos: Array[int]
@export var prox_double: Array[String] = []
@export var prox_zero: Array[String] = []
@export var sabor_Suave: int = 0
@export var sabor_Picante: int = 0
@export var sabor_Umami: int = 0
@export var sabor_Unico: int = 0
@export var sabor_Comum: int = 0
@export var sabor_descarte: int = 0
@export var sabor_Sopa: int = 0
@export var sabor_Sanduiche: int = 0
@export var sabor_Salada: int = 0
@export var sabor_por_ingrediente: int = 0
@export var adiciona_inicio: Array[String] = []

@export var guarda: bool = false
@export var descarte_turno = false
@export var descarte_totais = 0
@export var mult_prato = 1
@export var tomate = 0
@export var picles = 0

#efeitos reliquias
@export var mult_extra = 0
@export var faca_encantada = false
@export var fogo_encantado = false
@export var martelo_encantado = false
@export var sushi_ativo = false
@export var super_salada = false
@export var super_sanduiche = false
@export var super_sopa = false
@export var miseEnPlace = false
@export var mana_extra = false

#cena da config
const CONFIG = preload("res://scenes/config.tscn")
#sons
@onready var sfx_new_hand: AudioStreamPlayer2D = $SFXNewHand
@onready var sfx_new_hand_alternate: AudioStreamPlayer2D = $SFXNewHandAlternate
@onready var sfx_bell: AudioStreamPlayer2D = $SFXBell

func _ready() -> void:
	checa_perde_carta_por_turno()
	checa_perde_um_turno()
	$Button/AnimationPlayer.play("idle")
	print($"/root/GlobalData".fase)
	#if $"/root/GlobalData".fase != 1 and $"/root/GlobalData".fase != 5:
	if $"/root/GlobalData".fase != 1:
		$Cliente.visible = true
	var cliente = $"/root/GlobalData".cliente_temp
	var texto_temp = cliente.nome
	match texto_temp:
		"Fogaço": 
			cliente_foto.texture = foto_1
			button_abrir_cliente.icon = foto_1
		"Erick Jacão": 
			cliente_foto.texture = foto_2
			button_abrir_cliente.icon = foto_2
		"Hyena Rizo": 
			cliente_foto.texture = foto_3
			button_abrir_cliente.icon = foto_3
		"Ana Maria Praga": 
			cliente_foto.texture = foto_4
			button_abrir_cliente.icon = foto_4
		"Ghork'Ohn Ahm'sey": 
			cliente_foto.texture = foto_5
			button_abrir_cliente.icon = foto_5
	#texto_temp = texto_temp + ": Hoje adoraria "
	if $"/root/GlobalData".fase == 1:
		cliente_foto.texture = foto_6
		button_abrir_cliente.icon = foto_6
	var c = 0
	for obj in cliente.objetivos:
		match c:
			0: texto_temp = texto_temp + ": "
			1: texto_temp = texto_temp + "e "
			2: texto_temp = texto_temp + ""
		match obj[0]:
			"+tag":
				texto_temp = texto_temp + "Adoro um prato bem " + obj[1] + " "
			"+prato":
				if obj[1] == "Sanduiche": 
					texto_temp = texto_temp + "Hoje queria comer um " + obj[1] + " "
				else:
					texto_temp = texto_temp + "Hoje queria comer uma " + obj[1] + " "
			"+ingrediente":
				texto_temp = texto_temp + obj[1] + " é meu ingrediente favorito, quero pelo menos um no prato "
			"-tag":
				texto_temp = texto_temp + "Não gosto de comida " + obj[1] + ", se colocar bote bem pouco "
			"-prato":
				if obj[1] == "Sanduiche": 
					texto_temp = texto_temp + "Não gosto de " + obj[1] + "s, preferia outra coisa "
				else:
					texto_temp = texto_temp + "Não gosto de " + obj[1] + "s, preferia outra coisa "
			"-ingrediente":
				texto_temp = texto_temp + "Sou alérgico à " + obj[1] + ", não bote no prato por favor "
		c += 1
	if $"/root/GlobalData".fase == 1:
		texto_temp = "Aliane Butolane: Acho que ja te falei o bastante."
	cliente_label.text = substituir_palavras_por_tags(texto_temp)
	lista_de_cartas = $"/root/GlobalData".lista_cartas
	
	if $"/root/GlobalData".fase == 1:
		$Tutorial.visible = true
	button.pressed.connect(on_end_turn_pressed)
	button_2.pressed.connect(abrir_glossario)
	button_3.pressed.connect(end_game)
	button_4.pressed.connect(reset_game)
	button_5.pressed.connect(start_tutorial)
	button_abrir_cliente.pressed.connect(abrir_cliente)
	button_tutorial.pressed.connect(close_tutorial)
	button_tutorial2.pressed.connect(close_tutorial2)
	button_tutorial3.pressed.connect(close_tutorial3)
	button_cliente.pressed.connect(close_cliente)
	cooldown_timer.timeout.connect(_on_timer_timeout)
	$Reliquias.efeitos()
	if super_sanduiche:
		bota_na_mao("Pão Tostado", true)
	for i in adiciona_inicio:
		bota_na_mao(i)
	mana = max_mana
	play_draw_sound()
	# gerenciamento de cartas
	#carregar_todas_as_cartas()
	var novo_deck = gerar_deck()
	print("Deck gerado com cartas carregadas da pasta:")
	for carta in novo_deck:
		print("- " + carta.nome)
	on_draw_button_pressed()
	if mana_extra:
		mana+= 2
	if miseEnPlace:
		compra()
		compra()
	$Glossario.set_deck()

func _process(delta: float) -> void:
	dia.text = "Dia " + str($"/root/GlobalData".fase)
	mana_label.text = str(mana)
	max_mana_label.text = str(max_mana)
	turno_label.text = 'Turno ' + str(turno) + '/' + str(max_turno)
	deck_label.text = str(deck.size())

func substituir_palavras_por_tags(texto_original: String) -> String:
	var substituicoes: Dictionary = {
		"Acido": "Acido [img width=40 height=40]res://sprites/TAGS/TAG5.png[/img]",
		"Crocante": "Crocante [img width=40 height=40]res://sprites/TAGS/TAG4.png[/img]",
		"Picante": "Picante [img width=40 height=40]res://sprites/TAGS/TAG6.png[/img]",
		"Refrescante": "Refrescante [img width=40 height=40]res://sprites/TAGS/TAG3.png[/img]",
		"Suave": "Suave [img width=40 height=40]res://sprites/TAGS/TAG7.png[/img]",
		"Umami": "Suculento [img width=40 height=40]res://sprites/TAGS/TAG2.png[/img]",
		
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

func abrir_glossario():
	$Glossario.visible = true

func start_tutorial():
	$Tutorial.visible = true

func close_tutorial():
	$Tutorial.visible = false
	#$Tutorial2.visible = true

func close_tutorial2():
	$Tutorial2.visible = false
	$Tutorial3.visible = true

func close_tutorial3():
	$Tutorial3.visible = false

func abrir_cliente():
	$Cliente.visible = true

func close_cliente():
	$Cliente.visible = false

func sem_mana():
	if mana == 0:
		$Button/AnimatedSprite2D.visible = true
		$Button/AnimatedSprite2D.play("default")
		$AnimatedSprite2D.play("default")
		$Button/AnimationPlayer.play("pisca")

func on_draw_button_pressed(inicial: bool = true):
	var card_data = null
	var quant = 1
	var new_card_instance
	if inicial:
		quant = n_compras
	for i in range(quant):
		if not deck.is_empty():
			card_data = deck.pop_front()
			card_data.upgrade = false
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
	if custo > 0:
		for i in range(picles):
			compra()
	mana = mana - custo
	sem_mana()

func start_turn():
	descarte_turno = false
	$Button/AnimatedSprite2D.visible = false
	$Button/AnimationPlayer.play("idle")
	for i in adiciona_inicio:
		bota_na_mao(i)
	play_draw_sound()
	turno = turno + 1
	mana = max_mana
	on_draw_button_pressed()

func end_game():
	sfx_bell.play()
	await $prato.send_cards()
	#$"/root/GlobalData".set_sabor(999999)
	$"/root/GlobalData".set_cliente()
	get_tree().change_scene_to_file("res://scenes/tela_resultado.tscn")

func _on_timer_timeout() -> void:
	em_cooldown = false


func on_end_turn_pressed():
	if not em_cooldown:
		em_cooldown = true
		cooldown_timer.start()
		if turno >= max_turno:
			end_game()
		else:
			if !guarda:
				on_discard_button_pressed()
				while hand_node.get_child_count() > 0:
					await get_tree().create_timer(0.1).timeout 
				await get_tree().create_timer(0.2).timeout 
			guarda = false
			start_turn()

func reset_game():
	#resetando todos os valores do jogo
	on_discard_button_pressed()
	mana = max_mana
	turno = 1
	principal = 'nada'
	principal_pontos = 0
	tipo_prato =  "Prato"
	ingredientes_prato = []
	sabor = 0
	sabor_continuo = 0
	sal = 1
	#queijos = []
	tags_prato = []
	prox_double = []
	prox_zero = []
	adiciona_inicio = []
	sabor_Suave = 0
	sabor_Picante = 0
	sabor_Umami = 0
	sabor_Comum = 0
	sabor_Unico = 0
	var prato_temp = $prato
	descarte_totais = 0
	descarte_turno = false
	tomate = 0
	picles = 0
	$Info/Info_tags.reset_tags()
	$Info.set_pontos(0)
	$"Area de areas/Area2".on_lixo_pressed()
	$"Area de areas/Area".on_lixo_pressed()
	$"Area de areas/Area3".on_lixo_pressed()
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
		print(carta_data.nome)
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
	if vibe == "Umami": vibe = "Suculento"
	var nome = ''
	if vibe:
		nome = tipo_prato + ' ' + vibe + ' de ' + principal
	else:
		nome = tipo_prato + ' ' + 'vazio' + ' de ' + principal
	$"/root/GlobalData".set_nome(nome)
	return nome

func compara_principal(pontos, nome):
	if pontos > principal_pontos:
		principal_pontos = pontos
		principal = nome

func conta_cartas(tag):
	var r = 0
	var cartas = hand_node.get_children()
	for c in cartas:
		if c.card_data.tags.count(tag) > 0:
			r += 1
	return r

func descartado():
	descarte_turno = true
	descarte_totais += 1
	for i in range(tomate):
		compra()

func reseta_prox_zero():
	prox_zero = []

func mostrar_numero_flutuante(valor: int, pos_inicial: Vector2, pos_final: Vector2, cor: Color = Color.WHITE):
	if not is_instance_valid(numero_flutuante):
		printerr("Cena do número flutuante não está configurada!")
		return

	var numero_instanciado = numero_flutuante.instantiate() as Label
	if numero_instanciado:
		numero_instanciado.configurar(valor, pos_inicial, pos_final)
		numero_instanciado.cor_texto = cor # Define a cor do texto
		add_child(numero_instanciado)
		numero_instanciado.iniciar_animacao()
	else:
		printerr("Falha ao instanciar o número flutuante.")

func aplicar_efeitos_carta(carta: CartaData):
	var sabor_aux = sabor + sabor_continuo
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
			if ((sabor + sabor_continuo - sabor_aux) >= principal_pontos):
				principal_pontos = sabor + sabor_continuo - sabor_aux
				principal = carta.nome
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", carta.nome, "'.")
	if tags_prato.count("Refrescante") >= 4 && tipo_prato == "Prato":
		tipo_prato = "Salada"
	pontuação_continua()
	calculo_mult()
	$Info/Info_tags.atualiza_tag()
	print(mult)
	if sabor + sabor_continuo - sabor_aux > 0 : mostrar_numero_flutuante(sabor + sabor_continuo - sabor_aux, Vector2(612,66), Vector2(59,340))
	await get_tree().create_timer(0.6).timeout
	$Info.set_pontos(sabor + sabor_continuo)
	$"/root/GlobalData".set_sabor(sabor + sabor_continuo)
	$"/root/GlobalData".set_mult(mult)
	$"/root/GlobalData".set_tags(tags_prato)
	$"/root/GlobalData".set_ingredientes(ingredientes_prato)
	$"/root/GlobalData".set_cliente()
	print(sabor)

func pontuação_continua():
	var unicas = []
	var frequencias = {}
	for t in tags_prato:
		if unicas.count(t) == 0:
			unicas.append(t)
		frequencias[t] = frequencias.get(t, 0) + 1
	sabor_continuo = 0
	print(encontrar_mais_frequente(tags_prato))
	print(tags_prato.count(encontrar_mais_frequente(tags_prato)))
	print(sabor_Comum)
	print("sabor_suave = " + str(sabor_Suave))
	#sabor de tags
	sabor_continuo = sabor_continuo + sabor_Suave * tags_prato.count('Suave')
	sabor_continuo = sabor_continuo + sabor_Picante * tags_prato.count('Picante')
	sabor_continuo = sabor_continuo + sabor_Umami * tags_prato.count('Umami')
	sabor_continuo = sabor_continuo + sabor_Unico * unicas.size()
	sabor_continuo = sabor_continuo + sabor_descarte * descarte_totais
	sabor_continuo = sabor_continuo + sabor_Comum * tags_prato.count(encontrar_mais_frequente(tags_prato))
	sabor_continuo = sabor_continuo + sabor_por_ingrediente * ingredientes_prato.size()
	
	#sabor de prato
	match tipo_prato:
		"Sopa": sabor_continuo = sabor_continuo + sabor_Sopa
		"Sanduiche": sabor_continuo = sabor_continuo + sabor_Sanduiche
		"Salada": sabor_continuo = sabor_continuo + sabor_Salada
	
	#queijos
	print("queijos: ")
	print(queijos)
	for q in queijos:
		sabor_continuo = sabor_continuo + (q * queijos.size())

func calculo_mult():
	var primario = encontrar_mais_frequente(tags_prato)
	var unicas = []
	var frequencias = {}
	var contagem_frequencias = {}
	var maior_repeticao = 0
	var menor_valor = 100
	
	for t in tags_prato:
		if unicas.count(t) == 0:
			unicas.append(t)
		frequencias[t] = frequencias.get(t, 0) + 1
	
	for valor in frequencias.values():
		if valor < menor_valor:
			menor_valor = valor
	
	for freq in frequencias.values():
		contagem_frequencias[freq] = contagem_frequencias.get(freq, 0) + 1
		if contagem_frequencias[freq] > maior_repeticao:
			maior_repeticao = contagem_frequencias[freq]
	
	match tipo_prato:
		'Prato': $Info.set_mult(mult_prato + mult_extra); mult = mult_prato + mult_extra
		'Sopa': 
			if super_sopa:
				$Info.set_mult(tags_prato.count(primario) * 2 + mult_extra); mult = tags_prato.count(primario) * 2 + mult_extra
			else:
				$Info.set_mult(tags_prato.count(primario) + mult_extra); mult = tags_prato.count(primario) + mult_extra
		'Sanduiche': 
			$Info.set_mult(unicas.size() * menor_valor + mult_extra); mult = unicas.size() * menor_valor + mult_extra
		'Salada': 
			if super_salada:
				$Info.set_mult(3 * maior_repeticao + mult_extra); mult = 3 * maior_repeticao + mult_extra
			else:
				$Info.set_mult(2 * maior_repeticao + mult_extra); mult = 2 * maior_repeticao + mult_extra

func jogar_carta(carta: CartaData):
	print("Carta jogada:", carta.nome)
	tags_prato.append_array(carta.tags)
	ingredientes_prato.append(carta.nome)
	aplicar_efeitos_carta(carta)
	for i in prox_double:
		if (carta.tags.count(i) > 0):
			prox_double.erase(i)
			aplicar_efeitos_carta(carta)
			return null

func _on_config_button_pressed() -> void:
	var config_instance = CONFIG.instantiate()
	config_instance.position = Vector2(0,-50)
	add_child(config_instance)

func play_draw_sound():
	var n = randi_range(1,2)
	if n == 1:
		sfx_new_hand.play()
	else:
		sfx_new_hand_alternate.play()

#lista de acoes executaveis pelas cartas: -----------------------------------------------------------------------------------------------

func mostrar_mensagem(mensagem: String):
	print("Mensagem da Carta:", mensagem)

func add_sabor(pontos: String):
	sabor = sabor + int(pontos) * sal

func sal_mult(mult: String):
	sal = sal + float(mult)

func set_sanduiche():
	if tipo_prato == "Prato":
		tipo_prato = "Sanduiche"
	
func set_sopa():
	if tipo_prato == "Prato":
		tipo_prato = "Sopa"

func compra():
	on_draw_button_pressed(false)

func add_sabor_queijo(pontos: String):
	print("queijei: " + str(int(pontos) * sal))
	queijos.append(int(int(pontos) * sal))
	print(queijos)

func add_sabor_tag(pontos: String, tag: String):
	print("add_sabor_tag" + tag)
	match tag:
		"Suave": sabor_Suave = sabor_Suave + int(pontos) * sal
		"Picante": sabor_Picante = sabor_Picante + int(pontos) * sal
		"Umami": sabor_Umami = sabor_Umami + int(pontos) * sal
		"Unica": sabor_Unico = sabor_Unico + int(pontos) * sal
		"Comum": 
			sabor_Comum = sabor_Comum + int(pontos) * sal
			print("batatado")

func add_sabor_prato(pontos: String, prato: String):
	match prato:
		"Sopa": sabor_Sopa += int(pontos) * sal
		"Sanduiche": sabor_Sanduiche += int(pontos) * sal
		"Salada": sabor_Salada += int(pontos) * sal

func prox_ingrediente_double(tag: String):
	prox_double.append(tag)

func bota_na_mao(carta: String, zerado = false):
	var new_card_scene = preload("res://scenes/card.tscn")
	var new_card_instance = new_card_scene.instantiate()
	hand_node.add_child(new_card_instance) # Adiciona a carta na 'hand' imediatamente

	# Define os dados da carta
	new_card_instance.set_card(encontrar_carta_data_por_nome(carta), zerado)
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

func gera_mana(pontos: String):
	mana = mana + int(pontos)

func guarda_mao():
	guarda = true

func troca_mao():
	on_discard_button_pressed()
	await get_tree().create_timer(1).timeout 
	on_draw_button_pressed()

func add_por_mao(pontos: String, tag: String):
	var p
	match tag:
		"todas": add_sabor(str(int(pontos) * hand_node.get_child_count()))
		"Refrescante": add_sabor(str(int(pontos) * conta_cartas("Refrescante")))

func add_sabor_descarte(pontos: String):
	if descarte_turno:
		add_sabor(pontos)

func set_mult_prato(pontos: String):
	mult_prato = int(pontos)

func descarte_compra():
	tomate += 1

func descarte_ponto(pontos: String):
	sabor_descarte = sabor_descarte + int(pontos) * sal

func descarta_direita():
	hand_node.get_child(0).queue_free()
	descartado()

func gasta_compra():
	picles += 1

func add_por_prato(pontos: String):
	sabor_por_ingrediente = sabor_por_ingrediente + int(pontos) * sal

func add_mais_presente(pontos: String):
	print(encontrar_mais_frequente(tags_prato))
	if encontrar_mais_frequente(tags_prato) == "Acido":
		add_sabor('200')

func add_mao_por_turno(carta: String):
	adiciona_inicio.append(carta)

func reset_sabor():
	sabor = 0
	sabor_continuo = 0
	sabor_Suave = 0
	sabor_Picante = 0
	sabor_Umami = 0
	sabor_Comum = 0
	sabor_Unico = 0


# efeitos de reliquias ###############################################################################

func mais_mana_turno():
	max_mana += 1

func mais_draw_turno():
	n_compras += 1

func mais_mana_primeiro():
	mana_extra = true

func mais_draw_primeiro():
	miseEnPlace = true

func mais_turno():
	max_turno += 1
	n_compras -= 1

func add_mult_extra():
	mult_extra += 1

func add_faca_encantada():
	adiciona_inicio.append("Cutelo")

func add_fogo_encantado():
	adiciona_inicio.append("Espirito de Fogo")
	
func add_martelo_encantado():
	adiciona_inicio.append("Martelo")

func add_sushi_ativo():
	sushi_ativo = true

func add_super_salada():
	super_salada = true

func add_super_sanduiche():
	super_sanduiche = true

func add_super_sopa():
	super_sopa = true

func add_tag_rand():
	var tags_possiveis: Array[String] = ["Acido", "Crocante", "Picante", "Refrescante", "Suave", "Umami"] 
	var rand_tags = []
	for i in 3:
		var escolhida = tags_possiveis.pick_random()
		rand_tags.append(escolhida)
	tags_prato.append_array(rand_tags)

func checa_perde_um_turno():
	if GlobalData.perde_um_turno:
		turno = 2
		GlobalData.perde_um_turno = false;

func checa_perde_carta_por_turno():
	print("testando")
	print("check de debug:", GlobalData._perde_compra)
	if GlobalData._perde_compra:
		print("ANNTES da modificacao de compras::",n_compras)
		n_compras = n_compras-1
		GlobalData._perde_compra = false
		print("Numero de compras::",n_compras)
	print("fim de teste")
