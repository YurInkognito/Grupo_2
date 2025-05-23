extends Panel

@export var Acido_t: String = '0'
@export var Crocante_t: String = '0'
@export var Picante_t: String = '0'
@export var Refrescante_t: String = '0'
@export var Suave_t: String = '0'
@export var Umami_t: String = '0'

@onready var Acido: Label = $Acido
@onready var Crocante: Label = $Crocante
@onready var Picante: Label = $Picante
@onready var Refrescante: Label = $Refrescante
@onready var Suave: Label = $Suave
@onready var Umami: Label = $Umami

@onready var control: Control = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Acido.text = 'Acido = 0'
	Crocante.text = 'Crocante = 0'
	Picante.text = 'Picante = 0'
	Refrescante.text = 'Refrescante = 0'
	Suave.text = 'Suave = 0'
	Umami.text = 'Umami = 0'

func atualiza_tag():
	var tags = control.tags_prato
	Acido_t = str(tags.count('Acido'))
	Crocante_t = str(tags.count('Crocante'))
	Picante_t = str(tags.count('Picante'))
	Refrescante_t = str(tags.count('Refrescante'))
	Suave_t = str(tags.count('Suave'))
	Umami_t = str(tags.count('Umami'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	atualiza_tag()
	Acido.text = 'Acido = ' + Acido_t
	Crocante.text = 'Crocante = ' + Crocante_t
	Picante.text = 'Picante = ' + Picante_t
	Refrescante.text = 'Refrescante = ' + Refrescante_t
	Suave.text = 'Suave = ' + Suave_t
	Umami.text = 'Umami = ' + Umami_t
