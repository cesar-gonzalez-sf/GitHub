public class Promedio{
	public static void main(String[] args) {
		
		int matematicas = 14;
		int quimica		= 5;
		int fisica		= 5;
		int promedio 	= 0;

		promedio = (matematicas + quimica + fisica) / 3;

		if (promedio >= 6){
			System.out.println("El alumno aprobo"  + promedio);
		}else{
			System.out.println("EL alumno reprobo" + promedio);
		}
	}
}