class_name CartaData
extends Resource

@export var nome: String = ""
@export var custo: String = ""
@export var ingrediente: bool = false
@export var is_processo: bool = false
@export var desc: String = ""
@export var on_faca: CartaData
@export var on_fogo: CartaData
@export var on_martelo: CartaData
@export var efeitos_ao_jogar: Array[Dictionary] = []
@export var efeitos_ao_processar: Array[Dictionary] = []
@export var efeitos_on_board: Array[Dictionary] = []
@export var tags: Array[String]
@export var sprite: Texture2D

@export var upgrade: bool = false
