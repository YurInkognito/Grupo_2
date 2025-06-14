extends Node

@export var sabor_final: int = 0
@export var mult_final: int = 0
@export var cliente_final: int = 0
@export var tags_final: Array[String] =[]
@export var nome_final: String = ""

func set_sabor(pontos: int):
	sabor_final = pontos

func set_nome(nome: String):
	nome_final = nome
	
func set_mult(pontos: int):
	mult_final = pontos

func set_cliente(fase: int):
	match fase:
		1: cliente_final = critico_1_nota()

func set_tags(tags):
	tags_final = tags

func gera_fala(fase, nota):
	print(cliente_final, nota)
	match fase:
		1:
			match cliente_final:
				0: 
					match nota:
						0: return "Horrivel... Horrivel, Horrivel!"
						1: return "Você tinha um trabalho anão..."
						2: return "Melhor do que eu esperava, mas eu não esperava muito."
						3: return "Devo admitir que é um bom prato, fraco, mas um bom prato"
				1:
					match nota:
						0: return "Jogar um pouco de pimenta em terra não torna ela um prato picante..."
						1: return "Bom, com certeza já comi pratos piores. Já comi melhores, também."
						2: return "A picancia está agradavel, infelizmente."
						3: return "Bom trabalho. Talvez um pouco mais de pimenta na próxima."
				2:
					match nota:
						0: return "Da póxima vez me traga só a garrafa de pimenta no prato."
						1: return "A pimenta está no ponto, me ajudou a engolir."
						2: return "Flamejante! Ufa. Do jeitinho que eu gosto mesmo. Belo trabalho."
						3: return "Já consigo imaginar a capa da próxima Elf's Digest! Tanta picancia tanto sabor! Anão... digo Jeff, a comida de minha mãe jamais chegou neste nivel. Foi um prazer que espero sentir novamente. Até."
				3:
					match nota:
						0: return "Horrivel... Horrivel, Horrivel!"
						1: return "Você tinha um trabalho anão..."
						2: return "Melhor do que eu esperava, mas eu não esperava muito."
						3: return "O que foi isso? Estava bom? Eu... Eu gostei? (cutscene do secret ending)"


#"Já consigo imaginar a capa da próxima Elf's Digest! Tanta picancia tanto sabor! Anão... digo Jeff, a comida de minha mãe jamais chegou neste nivel. Foi um prazer que espero sentir novamente. Até."
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
