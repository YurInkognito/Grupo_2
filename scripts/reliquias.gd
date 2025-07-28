extends Panel

@export var lista_reliquias: Array[CartaData]
@export var reliquias: Array[CartaData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reliquias = GlobalData.reliquias
	exibir_reliquias()

func exibir_reliquias():
	for elemento in reliquias:
		var texture_rect = TextureRect.new()
		texture_rect.custom_minimum_size = Vector2(40, 40)
		texture_rect.texture = elemento.sprite
		
		texture_rect.tooltip_text = elemento.desc
		
		# Opcional: Ajustar modo de escala
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE # Ou EXPAND_FIT_WIDTH, etc.
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED # Ou STRETCH_SCALE, etc.
		
		# Adiciona como filho
		$HBoxContainer.add_child(texture_rect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func efeitos():
	for r in reliquias:
		print("reliquia: "+ r.nome)
		$"..".aplicar_efeitos_carta(r)
