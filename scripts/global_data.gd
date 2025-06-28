extends Node

#pre jogo
@export var lista_cartas: Array[CartaData]
@export var lista_ingredientes: Array[CartaData] = []
@export var fase: int = 0

#durante o jogo
@export var sabor_final: int = 0
@export var mult_final: int = 0
@export var cliente_final: int = 0
@export var tags_final: Array[String] =[]
@export var ingredientes_final: Array[String] =[]
@export var nome_final: String = ""
@export var cliente_temp: Dictionary = {
"nome": "",
"objetivo_1": ['',''],
"objetivo_2": ['',''],
"dificuldade": ""
}

func set_cartas(cartas):
	lista_cartas = cartas
	lista_ingredientes = lista_ingredientes + lista_cartas
	lista_ingredientes = remover_processos(lista_ingredientes)

func set_sabor(pontos: int):
	sabor_final = pontos

func set_nome(nome: String):
	nome_final = nome
	
func set_mult(pontos: int):
	mult_final = pontos

func set_cliente(fase: int):
	match fase:
		1: cliente_final = critico_1_nota()
		#5: cliente_final = critico_2_nota()
		_: cliente_final = cliente_nota(cliente_temp)

func set_tags(tags):
	tags_final = tags

func set_ingredientes(ingredientes):
	ingredientes_final = ingredientes

func remover_processos(lista_de_cartas: Array[CartaData]) -> Array[CartaData]:
	for i in range(lista_de_cartas.size() - 1, -1, -1):
		var carta_atual: CartaData = lista_de_cartas[i]
		if carta_atual.is_processo == true:
			lista_de_cartas.remove_at(i)
	return lista_de_cartas
	
func proxima_fase():
	fase += 1
	match fase:
		1:
			get_tree().change_scene_to_file("res://scenes/cena_aliane.tscn")
		#5:
			#leva pra cutscene 2
		#	get_tree().change_scene_to_file("res://scenes/control.tscn")
		_:
			gera_cliente()
			get_tree().change_scene_to_file("res://scenes/control.tscn")

func gera_cliente():
	var cliente: Dictionary = {
	"nome": "",
	"objetivo_1": ['',''],
	"objetivo_2": ['',''],
	"dificuldade": ""
}
	var nomes = ["Fogaço", "Erick Jacão", "Hyena Rizo", "Claude Trollgros", "Bela Gill"]
	var rng = RandomNumberGenerator.new()
	var obj_1 = rng.randi_range(0, 2)
	var obj_2 = rng.randi_range(0, 1)
	cliente.nome = nomes[rng.randi_range(0, nomes.size() - 1)]
	match obj_1:
		0: 
			match rng.randi_range(0, 5):
				0: cliente.objetivo_1 = ["tag", "Acido"]
				1: cliente.objetivo_1 = ["tag", "Crocante"]
				2: cliente.objetivo_1 = ["tag", "Picante"]
				3: cliente.objetivo_1 = ["tag", "Suave"]
				4: cliente.objetivo_1 = ["tag", "Refrescante"]
				5: cliente.objetivo_1 = ["tag", "Umami"]
		1:
			cliente.objetivo_1 = ["ingrediente", lista_ingredientes[rng.randi_range(0, lista_ingredientes.size())].nome]
		2:
			match rng.randi_range(0, 2):
				0: cliente.objetivo_1 = ["prato", "Sanduiche"]
				1: cliente.objetivo_1 = ["prato", "Salada"]
				2: cliente.objetivo_1 = ["prato", "Sopa"]
	cliente.objetivo_2 = cliente.objetivo_1
	while cliente.objetivo_2 == cliente.objetivo_1:
		obj_2 = rng.randi_range(0, 1)
		match obj_2:
			0: 
				match rng.randi_range(0, 5):
					0: cliente.objetivo_2 = ["tag", "Acido"]
					1: cliente.objetivo_2 = ["tag", "Crocante"]
					2: cliente.objetivo_2 = ["tag", "Picante"]
					3: cliente.objetivo_2 = ["tag", "Suave"]
					4: cliente.objetivo_2 = ["tag", "Refrescante"]
					5: cliente.objetivo_2 = ["tag", "Umami"]
			1:
				cliente.objetivo_2 = ["ingrediente", lista_ingredientes[rng.randi_range(0, lista_ingredientes.size() - 7)].nome]
	print(cliente)
	cliente_temp = cliente
	
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
		5:
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
		_:
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

func critico_2_nota():
	var suave = tags_final.count("Suave")
	var picante = tags_final.count("Picante")
	
	if suave > picante + 3:
		return 3
	if picante < 4:
		return 0
	if picante < 6:
		return 1
	return 2

func cliente_nota(cliente):
	var pontos = 0
	print(cliente)
	match cliente.objetivo_1[0]:
		"tag":
			var tag = tags_final.count(cliente.objetivo_1[1])
			print(tags_final.count(cliente.objetivo_1[1]))
			if tag > 5:
				pontos += 2
		"ingrediente":
			if ingredientes_final.count(cliente.objetivo_1[1]):
				pontos += 2
		"prato":
			if nome_final.contains(cliente.objetivo_1[1]):
				pontos += 2
	
	match cliente.objetivo_2[0]:
		"tag":
			var tag = tags_final.count(cliente.objetivo_2[1])
			print(tags_final.count(cliente.objetivo_2[1]))
			if tag > 3:
				pontos += 1
		"ingrediente":
			print(ingredientes_final.count(cliente.objetivo_2[1]))
			if ingredientes_final.count(cliente.objetivo_2[1]):
				pontos += 1
	
	return pontos

func jogar():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
