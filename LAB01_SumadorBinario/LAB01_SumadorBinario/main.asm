;***************************************************************
; Universidad del Valle de Guatemala
; IE2025: Programaci?n de Microcontroladores
;
; Author: Juan Rodr?guez
; Proyecto: Prelab I
; Hardware: ATmega328P
; Creado: 06/02/2025
; Modificado: 06/02/2025
; Descripci?n: Este programa consiste en un contador binario de 4 bits. 
;***************************************************************
.include "M328PDEF.inc"

.cseg
.org 0x0000

//Configuraci?n de pila //0x08FF
LDI		R16, LOW(RAMEND)	// Cargar 0xFF a R16
OUT		SPL, R16			// Cargar 0xFF a SPL
LDI		R16, HIGH(RAMEND)	
OUT		SPH, R16			// Cargar 0x08 a SPH


// Configuraci?n de MCU
SETUP:
	// DDRx, PORTx y PINx
	// Configurar Puerto D como entrada de pull-ups habilitados
	LDI R16, 0x00
	OUT DDRD,R16		// Seteamos todo el puerto D como entrada
	LDI R16, 0xFF		
	OUT PORTD, R16		//Habilitamos los pull-ups

	// Configurar Puerto B como salida y que conduzca cero l?gico
	LDI R16, 0xFF
	OUT DDRB, R16		// Seteamos todo el puerto B como salida
	LDI R16, 0x00
	OUT PORTB, R16		//El puerto B conduce cero l?gico.

	// Guardar estado actual de los botones en R17 y el valor de la salida
	LDI	R17, 0xFF		// 0b11111111
	LDI R18, 0x00
	

// LOOP
LOOP:
	IN		R16,PIND	//Leer PUERTO D
	CP		R17,R16		//Comparar el estado anterior de los botones con el estado actual.
	BREQ	LOOP		//Si son iguales regresa al inicio.
	//Agregar el delay
	CALL	DELAY
	//Volver a leer para ver si fue botonazo.
	IN		R16, PIND	// Releer PUERTO D. para detectar si fue botonazo.
	CP		R17, R16	//Comparar el estado anterior con el actual.
	BREQ	LOOP
	//Actualizar el estado
	MOV		R17, R16
	//Salta si es 0
	SBRS	R16,2		//Revisando si el bit 2 no "esta apachado" = 1 l?gico.
	CALL	incrementar	//El bit 2 esta apachado Boton Azul
	SBRS	R16,3		//Revisando si el bit 3 no esta "apachado" = 1 l?gico.
	CALL	decrementar	//El bit 3 esta apachado Boton Verde
	RJMP	LOOP

incrementar:
	INC		R18			//Incrementar valor
	CPI		R18, 0x10	//Comparar para ver si ocurre un acarreo.
	BREQ	Reinicio1	//Reiniciar si hay overflow
	OUT		PORTB, R18  //Actualizar salida
	RJMP	LOOP
Reinicio1:
	LDI		R18, 0x00	//Reiniciar conteo
	OUT		PORTB, R18	//Actualizar salida
	RJMP	LOOP


decrementar: 
	CPI		R18, 0x00	//Comparar para ver si ocurre un acarreo.
	BREQ	Reinicio2	//Reiniciar si hay overflow
	DEC		R18			//Decrementar valor
	OUT		PORTB, R18	//Actualizar salida
	RJMP	LOOP
Reinicio2:
	LDI		R18, 0x0F	//Reiniciar conteo
	OUT		PORTB, R18	//Actualizar salida.
	RJMP	LOOP



DELAY:
	LDI		R19, 0
	LDI		R20, 0
	LDI		R21, 0
	LDI		R22, 0
SUBDELAY1:
	INC		R19
	CPI		R19,0
	BRNE	SUBDELAY1
SUBDELAY2:
	INC		R20
	CPI		R20,0
	BRNE	SUBDELAY2
SUBDELAY3:
	INC		R21
	CPI		R21,0
	BRNE	SUBDELAY3
SUBDELAY4:
	INC		R22
	CPI		R22,0
	BRNE	SUBDELAY4
	RET