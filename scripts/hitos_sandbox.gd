class_name HitosSandbox
extends RefCounted

static func obtener_hitos() -> Array[Dictionary]:
	return [
		{
			"id": 1,
			"clave": "PRIMEROS_PASOS",
			"titulo": "1. Fase 1: Abastecedor (Tablero 3x3)",
			"descripcion": "Estás mirando al Sur hacia la Caja de Suministros. Toma una tuerca con [Tomar Pieza], da media vuelta hacia el Norte y deposítala en la Mesa Inicial con [Depositar].",
			"meta_texto": "Toma la tuerca de la Caja de Suministros y deposítala en la Mesa Inicial",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2, # Mirando al Sur hacia la caja en (-1, 1)
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "DEPOSITAR_INSUMO",
			"recompensa_creditos": 20,
			"mensaje_ada": "¡Excelente maniobra! Has entregado la primera materia prima en la Mesa de Fabricación Inicial.",
			"pista": "Usa [Tomar Pieza] frente a la caja de suministros, da media vuelta hacia el Norte y pulsa [Depositar] en la mesa inicial.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 2,
			"clave": "FRICCION_Y_REPETICION",
			"titulo": "2. Fabricación Base: Segunda Entrega (3x3)",
			"descripcion": "La Mesa Inicial necesita 2 insumos para terminar de manufacturar la Pieza Base. Realiza un segundo viaje para depositar la segunda tuerca.",
			"meta_texto": "Lleva la 2ª tuerca a la Mesa Inicial para fabricar la Pieza Base",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "FABRICAR_PATAS",
			"recompensa_creditos": 25,
			"mensaje_ada": "¡Pieza base fabricada! Pero repetir viajes manualmente agota bloques. En MEJORAS adquiere el [BLOQUE BUCLE] recién desbloqueado.",
			"pista": "Programa el viaje de retorno a la caja de suministros y vuelve a la mesa con la segunda tuerca.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 3,
			"clave": "BUCLE_FARMEO",
			"titulo": "3. Automatización Continua: El Bucle (3x3)",
			"descripcion": "Adquiere el 'Bloque Bucle' (20 tuercas) en MEJORAS. Envuelve tu algoritmo para que Astro 1 mantenga la Mesa Inicial abastecida de forma 100% autónoma y continua.",
			"meta_texto": "Usa el Bloque Bucle y acumula stock en la Mesa Inicial",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 1,
			"tamano_sector": 3,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"mostrar_mesa": false,
			"mostrar_baliza": false,
			"mostrar_meson_patas": true,
			"tipo_meta": "ACTIVAR_BUCLE",
			"recompensa_creditos": 35,
			"mensaje_ada": "¡Producción continua activa! Ahora expande la bahía a 5x5 casillas e instala la Máquina de Cinta con Astro 2 en MEJORAS.",
			"pista": "Compra el bloque Bucle en MEJORAS y envuelve tu secuencia para automatizar a Astro 1.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 4,
			"clave": "OPERADOR_CINTA_5X5",
			"titulo": "4. Fase 2: Operador de Cinta Automática (5x5)",
			"descripcion": "Expande a 5x5 casillas, instala la Máquina de Cinta y activa a Astro 2 en MEJORAS. Programa a Astro 2 para tomar la pieza de la Mesa Inicial, ingresarla en la entrada de la cinta y retirar el componente terminado por la salida.",
			"meta_texto": "Mete la pieza en la Cinta Automática y retira el componente procesado",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 2,
			"tamano_sector": 5,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "PROCESAR_CINTA",
			"recompensa_creditos": 60,
			"mensaje_ada": "¡Flujo de procesamiento industrial completado! Los componentes procesados están listos para el montaje robótico.",
			"pista": "Astro 2 retira la pieza de la Mesa Inicial, la deposita en la entrada de la cinta y recoge el componente terminado en la salida.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 5,
			"clave": "ENSAMBLADOR_FINAL_7X7",
			"titulo": "5. Fase 3: Ensamblador Final en Spido (7x7)",
			"descripcion": "Expande a 7x7 casillas, instala la Mesa de Ensamble Final y despierta a Astro 3 en MEJORAS. Programa a Astro 3 para trasladar 6 piezas y completar el montaje de Spido.",
			"meta_texto": "Monta las 6 piezas en la Mesa de Ensamble de Spido",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR"],
			"cantidad_astronautas": 3,
			"tamano_sector": 7,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"pos_astronauta_3": Vector2i(2, 1),
			"ori_astronauta_3": 2,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "ENSAMBLAR",
			"piezas_requeridas": 6,
			"recompensa_creditos": 80,
			"mensaje_ada": "¡Spido completamente ensamblado con sus 6 componentes! Ahora instala la Compuerta de Entrega para activar el despacho continuo de producción.",
			"pista": "Astro 3 toma componentes procesados y los acopla en la Mesa Final de Spido al Sur hasta completar las 6 piezas.",
			"piezas": [
				{"tipo": "TUERCA", "celda": Vector2i(-1, 1)}
			]
		},
		{
			"id": 6,
			"clave": "DESPACHO_CONTINUO_COMPUERTA",
			"titulo": "6. Despacho y Ganancia Continua por Compuerta",
			"descripcion": "Instala la Compuerta de Entrega en MEJORAS. Despacha al robot Spido completo hacia el espacio exterior para ganar Créditos de Producción inmediatos en un bucle infinito.",
			"meta_texto": "Despacha a Spido a través de la Compuerta de Entrega",
			"bloques_disponibles": ["AVANZAR", "GIRAR_IZQ", "GIRAR_DER", "TOMAR_PIEZA", "ENSAMBLAR", "DIAGNOSTICO"],
			"cantidad_astronautas": 3,
			"tamano_sector": 7,
			"pos_astronauta": Vector2i(-1, 0),
			"ori_astronauta": 2,
			"pos_astronauta_2": Vector2i(0, -1),
			"ori_astronauta_2": 0,
			"pos_astronauta_3": Vector2i(2, 1),
			"ori_astronauta_3": 2,
			"mostrar_mesa": false,
			"pos_mesa": Vector2i(2, 2),
			"mostrar_meson_patas": true,
			"tipo_meta": "DESPACHO_COMPUERTA",
			"recompensa_creditos": 100,
			"mensaje_ada": "¡Línea de producción espacial continua completada con éxito! Cada robot despachado genera créditos automáticos.",
			"pista": "Con Spido completado, interactúa frente a la compuerta de entrega para despacharlo al espacio exterior.",
			"piezas": []
		}
	]
