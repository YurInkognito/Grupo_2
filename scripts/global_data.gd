extends Node

@export var sabor_final: int = 0
@export var mult_final: int = 0
@export var cliente_final: int = 0
@export var tags_final: Array[String] =[]


func set_sabor(pontos: int):
	sabor_final = pontos

func set_mult(pontos: int):
	mult_final = pontos

func set_cliente(fase: int):
	match fase:
		1: cliente_final = critico_1_nota()

func set_tags(tags):
	tags_final = tags

func gera_fala(fase, nota):
	match fase:
		1:
			match nota:
				0: return "Era... Era pra eu ter sentido alguma coisa?"
				1: return "Bom, com certeza já comi pratos piores. Já comi melhores, também."
				2: return "Flamejante! Ufa. Do jeitinho que eu gosto mesmo. Belo trabalho."
				3: return "Já consigo imaginar a capa da próxima Elf's Digest! Tanta picancia tanto sabor! Anão... digo Jeff, a comida de minha mãe jamais chegou neste nivel. Foi um prazer que espero sentir novamente. Até."

func critico_1_nota():
	var suave = tags_final.count("Suave")
	var picante = tags_final.count("Picante")
	
	if suave > picante + 3:
		return 3
	if picante < 4:
		return 0
	if picante < 6:
		return 1
	return 2

func jogar():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
