extends Node2D

@onready var button: Button = $Button

@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var prato_container: GridContainer = $ScrollContainer2/GridContainer


var deck_de_cartas: Array[CartaData] = []
var lista_pratos = []

var is_dragging_global = false

func _ready():
	button.pressed.connect(fechar_glossario)
	pass

func fechar_glossario():
	$".".visible = false

func exibir_pratos_na_grade():
	for child in prato_container.get_children():
		child.queue_free()
	lista_pratos = $"/root/GlobalData".lista_pratos
	var new_prato_instance
	for prato in lista_pratos:
		var new_prato_scene = preload("res://scenes/prato_glossario.tscn")
		new_prato_instance = new_prato_scene.instantiate()
		prato_container.add_child(new_prato_instance)
		print(prato.nome)
		print(prato.sabor)
		new_prato_instance.nome = prato.nome
		new_prato_instance.sabor = prato.sabor
		

func exibir_deck_na_grade():
	for child in grid_container.get_children():
		child.queue_free()

	var new_card_instance
	for carta_data in deck_de_cartas:
		print(carta_data.nome)
		var new_card_scene = preload("res://scenes/card.tscn")
		new_card_instance = new_card_scene.instantiate()
		grid_container.add_child(new_card_instance)
		new_card_instance.visual = true
		new_card_instance.set_card(carta_data)
	

# Exemplo de como você pode chamar isso de outro script para atualizar o deck
func set_deck():
	deck_de_cartas = $"/root/GlobalData".lista_cartas
	exibir_deck_na_grade() # Atualiza a exibição da grade
	exibir_pratos_na_grade()
