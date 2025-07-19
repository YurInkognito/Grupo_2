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
"objetivos": [],
"dificuldade": 1
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
	gera_cliente()
	Transição.change_scene("res://scenes/semana.tscn")

func gera_cliente():
	var cliente: Dictionary = {
	"nome": "",
	"objetivos": [["setup","nada"]],
	"dificuldade": 1
}
	if fase > 7:
		cliente.dificuldade = 2
	var nomes = ["Fogaço", "Erick Jacão", "Hyena Rizo", "Claude Trollgros", "Bela Gill"]
	var rng = RandomNumberGenerator.new()
	var obj_n = []
	var obj_1 = rng.randi_range(0, 5)
	var obj_2 = rng.randi_range(0, 4)
	if obj_2 == obj_1:
		obj_2 = 5
	obj_n.append(obj_1)
	obj_n.append(obj_2)
	cliente.nome = nomes[rng.randi_range(0, nomes.size() - 1)]
	#for i in range(cliente.dificuldade):
	for i in range(2):
		match obj_n[i]:
			0: 
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					match rng.randi_range(0, 5):
						0: obj_temp = ["+tag", "Acido"]
						1: obj_temp = ["+tag", "Crocante"]
						2: obj_temp = ["+tag", "Picante"]
						3: obj_temp = ["+tag", "Suave"]
						4: obj_temp = ["+tag", "Refrescante"]
						5: obj_temp = ["+tag", "Umami"]
				cliente.objetivos.append(obj_temp)
			1:
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					match rng.randi_range(0, 5):
						0: obj_temp = ["-tag", "Acido"]
						1: obj_temp = ["-tag", "Crocante"]
						2: obj_temp = ["-tag", "Picante"]
						3: obj_temp = ["-tag", "Suave"]
						4: obj_temp = ["-tag", "Refrescante"]
						5: obj_temp = ["-tag", "Umami"]
				cliente.objetivos.append(obj_temp)
			2:
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					obj_temp = ["+ingrediente", lista_ingredientes[rng.randi_range(0, lista_ingredientes.size() - 1)].nome]
				cliente.objetivos.append(obj_temp)
			3:
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					obj_temp = ["-ingrediente", lista_ingredientes[rng.randi_range(0, lista_ingredientes.size() - 1)].nome]
				cliente.objetivos.append(obj_temp)
			4:
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					match rng.randi_range(0, 2):
						0: obj_temp = ["+prato", "Sanduiche"]
						1: obj_temp = ["+prato", "Salada"]
						2: obj_temp = ["+prato", "Sopa"]
				cliente.objetivos.append(obj_temp)
			5:
				var obj_temp = cliente.objetivos[cliente.objetivos.size() - 1]
				while obj_temp[1] == cliente.objetivos[cliente.objetivos.size() - 1][1]:
					match rng.randi_range(0, 2):
						0: obj_temp = ["-prato", "Sanduiche"]
						1: obj_temp = ["-prato", "Salada"]
						2: obj_temp = ["-prato", "Sopa"]
				cliente.objetivos.append(obj_temp)
	cliente.objetivos.pop_front()
	print("cliente: " + str(cliente))
	cliente_temp = cliente

func gera_fala(fase, nota):
	print(cliente_final, nota)
	match fase:
		1:
			match cliente_final:
				0: 
					return "Eu achei que tinha deixado claro que tipo de prato eu queria..."
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
	for i in cliente.objetivos:
		match i[0]:
			"+tag":
				var tag = tags_final.count(i[1])
				print(tags_final.count(i[1]))
				if tag >= 3:
					pontos += 1
			"+ingrediente":
				if ingredientes_final.count(i[1]):
					pontos += 1
			"+prato":
				if nome_final.contains(i[1]):
					pontos += 1
			"-tag":
				var tag = tags_final.count(i[1])
				print(tags_final.count(i[1]))
				if tag < 3:
					pontos += 1
			"-ingrediente":
				if ingredientes_final.count(i[1]) == 0:
					pontos += 1
			"-prato":
				if not nome_final.contains(i[1]):
					pontos += 1
	return pontos
