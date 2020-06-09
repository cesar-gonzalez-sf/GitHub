<------- Logica de Servicio para Convenio ---------------->

<-------- Ejemplo  no es nada concreto ------>
  <--------- Pensado para la APP ---------->


- REQUEST
 1- Cupon
 2- Producto / Monto 
 	Codigo cupon
 	$ xxx.xxx.xxx

- SERVICE 	
 1- Validacion del Cupon
  - Vigencia  
  - Utilizado
  - Esta en uso 
 2- Dejar el cupon en uso 
 3- Saber que tipo de descuesto es: %,$

/-- Si es por monto $ --/
 A) $1.000 | $3.000 = Pierde $2.000 del cupon y paga 1 peso no hay transacciones por 0
 B) $4.000 | $3.000 = Utiliza el cupon y paga diferencia $1.000
 C) $3.000 | $3.000 = Utiliza el cupon y paga 1 peso no hay transacciones por 0

/-- Si es por porcentaje --/ 
 A) $1.000 | 100% = Utiliza el cupon y paga 1 peso no hay transacciones por 0
 B) $1.000 | 200% = No puede exceder el total el porcentaje que es de 100%
 C) $1.000 | 1%   = Calculo el monto y se envia total a pagar 

- RESPONSE
 1- Cupon
 2- Monto anterior 
 3- Monto a pagar 
 4- Valor del cupon 
 5- Tipo de descuento



 En la pantalla del mantenedor el campo de nombre del convenio sera digitado recibir en la procedimiento 
