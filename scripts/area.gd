extends ColorRect

@export var current_card: Control = null
@onready var prato: ColorRect = $"../../prato"
@onready var hand: ColorRect = $"../../hand"
@onready var control: Control = $"../.."
@onready var som_fogo = $fogo
@onready var som_martelo= $martelo
@onready var som_faca = $faca
@onready var anim = $AnimatedSprite2D

@onready var dentro: Button = $Button
@onready var lixo: Button = $Button2

@export var prato_check = false
@export var lixo_check = false

signal processado()

func _ready() -> void:
	anim.play("idle")
	dentro.pressed.connect(on_dentro_pressed)
	lixo.pressed.connect(on_lixo_pressed)

func conectar_carta(card):
	processado.connect(card.on_efeito_carta_on_board)

func can_accept_card(card: Control) -> bool:
	if current_card != null:
		return false
	return true

func drop_card(card: Control, move = false):
	if move:
		if can_accept_card(card):
			current_card = card
			#card.get_parent().remove_child(card)
			add_child(card)
			$"../Area".conectar_carta(card)
			$"../Area2".conectar_carta(card)
			$"../Area3".conectar_carta(card)
			# Centraliza a carta na área
			card.position = Vector2.ZERO
			card.rotation = 0
			card.size = size * 0.9
			hand.update_cards()

			# Conecta sinais se necessário
			if card.has_signal("card_played"):
				card.card_played.connect(_on_card_played)
			
			return true
		return false
	else:
		var mana_cheat = false
		print(control.prox_zero)
		for i in control.prox_zero:
			print(card.card_data.tags)
			if (card.card_data.tags.count(i) > 0):
				mana_cheat = true
		if can_accept_card(card) and ((int(card.custo_t) <= control.mana) or mana_cheat):
			print(int(card.custo_t))
			if mana_cheat:
				control.reseta_prox_zero()
			else:
				control.gastar_mana(int(card.custo_t))
			current_card = card
			card.get_parent().remove_child(card)
			add_child(card)
			$"../Area".conectar_carta(card)
			$"../Area2".conectar_carta(card)
			$"../Area3".conectar_carta(card)
			# Centraliza a carta na área
			card.position = Vector2.ZERO
			card.rotation = 0
			card.size = size * 0.9
			hand.update_cards()

			# Conecta sinais se necessário
			if card.has_signal("card_played"):
				card.card_played.connect(_on_card_played)
			
			return true
		return false

func on_processar_carta(carta: CartaData, processo: String):
	for efeito in carta.efeitos_ao_processar:
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
		else:
			printerr("Aviso: Função '", efeito.get("funcao", "desconhecida"), "' não encontrada ou nome inválido na carta '", carta.nome, "'.")
	
func drop_processo(card: Control) -> bool:
	print("processando")
	print(card.card_data.nome)
	if current_card and (int(card.custo_t) <= control.mana):
		if current_card.card_data.on_faca and card.card_data.nome == "Cutelo":
			print("cortado")
			som_faca.play()
			anim.play("faca")
			control.gastar_mana(int(card.custo_t))
			emit_signal("processado")
			on_processar_carta(current_card.card_data, "Cutelo")
			current_card.set_card(current_card.card_data.on_faca)
			hand.update_cards()
			return true
		if current_card.card_data.on_fogo and card.card_data.nome == "Espirito de Fogo":
			print("queimado")
			som_fogo.play()
			anim.play("fogo")
			control.gastar_mana(int(card.custo_t))
			emit_signal("processado")
			on_processar_carta(current_card.card_data, "Espirito de Fogo")
			current_card.set_card(current_card.card_data.on_fogo)
			hand.update_cards()
			return true
		if current_card.card_data.on_martelo and card.card_data.nome == "Martelo":
			print("amassado")
			som_martelo.play()
			anim.play("martelo")
			control.gastar_mana(int(card.custo_t))
			emit_signal("processado")
			on_processar_carta(current_card.card_data, "Martelo")
			current_card.set_card(current_card.card_data.on_martelo)
			hand.update_cards()
			return true                          
	return false

func _on_card_played(card: Control):
	print("Carta jogada na área: ", card.card_name)
	
	
#funcoes de botao, modificadas para as funcionalidades, não deletar
func on_dentro_pressed() -> void:
	if current_card:
		remove_child(current_card)
		prato.add(current_card)
		current_card = null
	
func on_lixo_pressed() -> void:
	if current_card:
		control.descartado()
		remove_child(current_card)
		$"../../Decartes/AnimationPlayer".play("abrir_boca")
		$"../../Decartes/AnimationPlayer".play("fechar_boca")
		current_card.queue_free()

func carta_movida() -> void:
	if current_card:
		remove_child(current_card)
		current_card = null

func trocar_carta(area) -> void:
	if current_card:
		var temp = current_card
		var temp_externo = area.current_card
		print(temp,temp_externo)
		remove_child(current_card)
		current_card = null
		area.remove_child(area.current_card)
		area.current_card = null
		drop_card(temp_externo, true)
		area.drop_card(temp, true)

#funcoes on processo

func bota_na_mao(carta: String):
	control.bota_na_mao(carta)
