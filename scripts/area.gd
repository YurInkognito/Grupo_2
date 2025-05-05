extends ColorRect

@export var current_card: Control = null
@onready var prato: ColorRect = $"../../prato"
@onready var hand: ColorRect = $"../../hand"

@onready var dentro: Button = $Button
@onready var lixo: Button = $Button2

func _ready() -> void:
	dentro.pressed.connect(on_dentro_pressed)
	lixo.pressed.connect(on_lixo_pressed)


func can_accept_card() -> bool:
	print("recebi")
	if current_card != null:
		return false
	return true

func drop_card(card: Control):
	print("recebi 2")
	if can_accept_card() and int(card.custo_t) <= $"../..".mana:
		print(int(card.custo_t))
		$"../..".gastar_mana(int(card.custo_t))
		current_card = card
		card.get_parent().remove_child(card)
		add_child(card)
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

func drop_processo(card: Control) -> bool:
	print("processando")
	print(card.card_data.nome)
	if current_card:
		if current_card.card_data.on_faca and card.card_data.nome == "faca":
			print("cortado")
			current_card.set_card(current_card.card_data.on_faca)
			hand.update_cards()
			return true
		if current_card.card_data.on_fogo and card.card_data.nome == "fogo":
			print("queimado")
			current_card.set_card(current_card.card_data.on_fogo)
			hand.update_cards()
			return true
		if current_card.card_data.on_martelo and card.card_data.nome == "martelo":
			print("amassado")
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
		remove_child(current_card)
		current_card.queue_free()
