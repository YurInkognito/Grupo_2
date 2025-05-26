extends Panel

@export var Acido_t: int = 0
@export var Crocante_t: int = 0
@export var Picante_t: int = 0
@export var Refrescante_t: int = 0
@export var Suave_t: int = 0
@export var Umami_t: int = 0

@export var Acido_texture: Texture2D
@export var Crocante_texture: Texture2D
@export var Picante_texture: Texture2D
@export var Refrescante_texture: Texture2D
@export var Suave_texture: Texture2D
@export var Umami_texture: Texture2D

@onready var pos_list: Array[float] =[0,0,0,0,0,0]

@onready var control: Control = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func atualiza_tag():
	var tags = control.tags_prato
	Acido_t = (tags.count('Acido'))
	Crocante_t = (tags.count('Crocante'))
	Picante_t = (tags.count('Picante'))
	Refrescante_t = (tags.count('Refrescante'))
	Suave_t = (tags.count('Suave'))
	Umami_t = (tags.count('Umami'))
	
	posiciona_tags()

func reset_tags():
	for child in get_children():
		child.queue_free()

func posiciona_tags():
	var tag_list = [Acido_t, Crocante_t, Picante_t, Refrescante_t, Suave_t, Umami_t]
	var tag_texture_list = [Acido_texture, Crocante_texture, Picante_texture, Refrescante_texture, Suave_texture, Umami_texture]
	var c = 0
	var t = 0
	for tag in tag_list:
		for i in range(tag):
			var novo_sprite = Sprite2D.new()
			novo_sprite.position = Vector2(18.5 + c * 12, 18.5 + t * 30)
			novo_sprite.texture = tag_texture_list[t]
			add_child(novo_sprite)
			print(novo_sprite)
			c += 1
		c = 0
		t += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
