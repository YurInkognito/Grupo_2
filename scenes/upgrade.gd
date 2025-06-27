extends Panel
@export var pool_1: Array[String] = ["Algas Infinitas", "Noz Prismática", "Queijo de Tauren", "Amendoranha", "Carne de Minotauro"]
@export var pool_2: Array[String] = ["Cubo de Maionese", "Escama de Boitata", "Caneca de Undine", "Mandragora Real", "Broto de Névoa-Limão"]
@export var pool_3: Array[String] = ["Menta Esfoladoura", "Ovos de Ambrosia", "Sal", "Tomate Vampírico", "Picles de Beholder"]

@export var lista_cartas: Array[CartaData]
@export var lista_cartas_upgrade: Array[CartaData]

@onready var upgrade_1: card = $card
@onready var upgrade_2: card = $card2

@onready var pular: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lista_cartas = $"/root/GlobalData".lista_cartas
	pular.pressed.connect(skip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func skip():
	$"/root/GlobalData".proxima_fase()

func select_card(card_data):
	$"/root/GlobalData".lista_cartas.append(card_data)
	$"..".visible = false
	$"/root/GlobalData".proxima_fase()

func encontrar_carta_data_por_nome(nome: String) -> CartaData:
	for carta_data in lista_cartas_upgrade:
		if carta_data.nome == nome:
			print(carta_data.nome)
			var data_alterada = carta_data
			data_alterada.upgrade = true
			return data_alterada
	printerr("CartaData com o nome '", nome, "' não encontrado.")
	return null

func recompensar(estrelas):
	var rng = RandomNumberGenerator.new()
	var r1 = ''
	var r2 = ''
	match estrelas:
		0: pass
		1:
			var index_1 = rng.randi_range(0, pool_1.size() - 1)
			var index_2 = rng.randi_range(0, pool_1.size() - 1)
			while index_2 == index_1:
				index_2 = rng.randi_range(0, pool_1.size() - 1)
			r1 = pool_1[index_1]
			r2 = pool_1[index_2]
		2:
			var pool = pool_1 + pool_2
			var index_1 = rng.randi_range(0, pool.size() - 1)
			var index_2 = rng.randi_range(0, pool.size() - 1)
			while index_2 == index_1:
				index_2 = rng.randi_range(0, pool.size() - 1)
			r1 = pool[index_1]
			r2 = pool[index_2]
		3:
			var pool = pool_1 + pool_2 + pool_3
			var index_1 = rng.randi_range(0, pool.size() - 1)
			var index_2 = rng.randi_range(0, pool.size() - 1)
			while index_2 == index_1:
				index_2 = rng.randi_range(0, pool.size() - 1)
			r1 = pool[index_1]
			r2 = pool[index_2]
	upgrade_1.set_card(encontrar_carta_data_por_nome(r1))
	upgrade_2.set_card(encontrar_carta_data_por_nome(r2))
