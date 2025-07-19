extends CanvasLayer

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

var target_scene_path: String = ""

# Função chamada quando a cena está pronta,
# garantindo que a tela já comece transparente se não houver um fade inicial
func _ready():
	color_rect.modulate = Color(0, 0, 0, 0) # Totalmente transparente no início

func change_scene(path: String):
	target_scene_path = path
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade_out") # Inicia o fade para preto
	await animation_player.animation_finished # Espera o fade_out terminar
	get_tree().change_scene_to_file(target_scene_path) # Muda a cena
	animation_player.play("fade_in") # Inicia o fade para transparente na nova cena
	await animation_player.animation_finished
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
