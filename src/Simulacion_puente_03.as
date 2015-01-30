package
{
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.RenderStyleType;
	import as3isolib.graphics.SolidColorFill;
	
	import com.bit101.components.Label;
	import com.oaxoa.components.FrameRater;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	public class Simulacion_puente_03 extends Sprite
	{
		private var gnmM:Number = 15;					// Número de filas.
		private var gnmN:Number = 5;					// Número de columnas.
		
		private var gaMatrizX:Array = null;				// Matriz donde se referencian z y dz/dt.
		
		private var gaMatrizPlacas:Array = null;		// Matriz donde se referenciarán las placas.
		
		private var gisEscena:IsoScene;					// Escena.
		
		private var gnmPlacaAncho:Number = 25;			// Ancho de las placas.
		private var gnmPlacaLargo:Number = 25;			// Largo de las placas.
		private var gnmPlacaAlto :Number = 5;			// Alto de las placas.
		
		private var t:Number = 0.0;
		private var tMax:Number = 600.0;
		private var h:Number = 0.05;
		
		[Embed(source="/assets/Arial.ttf", fontName="Arial", mimeType="application/x-font")]
		private var fuente_Arial:Class;
		
		private var gdFechaHora:Date;
		private var glblEtiquetaTiempo:Label;
		
		private var gnmTiempoPausaTimer:Number = 10;	// Tiempo de cada pausa del timer.
		private var myTimer:Timer;						// Temporizador.
		
		public function Simulacion_puente_03()
		{
			var lstrNombreFuncion:String = "Simulacion_puente_03";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			// Se configura el stage.
			this.stage.frameRate = 30;
			this.stage.scaleMode = StageScaleMode.SHOW_ALL;
			this.stage.align = StageAlign.TOP;
			
			// Se inicializa el medidor de frames.
			var fr:FrameRater = new FrameRater();
			fr.x = 0; fr.y = 0;
			stage.addChild(fr);
			
			gdFechaHora = new Date();
			
			// Se inicializan las etiquetas.
			glblEtiquetaTiempo = new Label(this.stage, 0, 40);
			glblEtiquetaTiempo.text = gdFechaHora.toString();
			glblEtiquetaTiempo._tf.defaultTextFormat = new TextFormat("Arial", 12, "0x000000");
			
			// Se inicializa la matriz de placas.
			fn_inicializarMatrizPlacas();
			
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion + "." + "gnmM" + " = " + gnmM);
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion + "." + "gnmN" + " = " + gnmN);
			
			gaMatrizX = fn_inicializarMatriz_01(gaMatrizX, gnmM, 2*gnmN);
			fn_imprimirMatriz(gaMatrizX);
			
			/*while(t < tMax)
			{
				var k1:Array = f(t, gaMatrizX);
				var k2:Array = f(t + h / 2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, 0.5)));
				var k3:Array = f(t + h / 2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, 0.5)));
				var k4:Array = f(t + h, fn_sumarMatrices(gaMatrizX, k3));
				
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, h / 6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, 2 * h /6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k3, 2 * h /6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k4, h / 6));
				
				//fn_imprimirMatriz(gaMatrizX);
				fn_imprimirMatrizConRedondeo(gaMatrizX, 2);
				
				t = t + h;
			}// Fin del while.*/
			
			// Se inicia el temporizador.
			myTimer = new Timer(gnmTiempoPausaTimer, 0);
            myTimer.addEventListener("timer", fn_manejadorTimer);
            myTimer.start();
		}// Fin del constructor de la clase.
		
		private function fn_inicializarMatrizPlacas():void
		{
			var lstrNombreFuncion:String = "fn_inicializarMatrizPlacas";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			// Se inicializa la matriz.
			gaMatrizPlacas = new Array(gnmM);
			
			var i:Number = undefined;
			var j:Number = undefined;
			
			for(i=0; i<gnmM; i++)
			{
				gaMatrizPlacas[i] = new Array(gnmN);
			}// Fin del for.
			
			var lstrFilaTemp:String = "";
			
			gisEscena = new IsoScene();
			gisEscena.hostContainer = this;
			
			var box:IsoBox;
			
			var lnmX:Number = undefined;
			var lnmY:Number = undefined;
			var lnmZ:Number = undefined;
			
			var lnmX_Original:Number = 450;
			var lnmY_Original:Number = -80;
			
			lnmX = lnmX_Original;
			lnmY = lnmY_Original;
			lnmZ = 0;
			
			for(i=0; i<gnmM; i++) 
			{
				for(j=0; j<gnmN; j++)
				{
					box = new IsoBox();
					box.setSize(gnmPlacaAncho, gnmPlacaLargo, gnmPlacaAlto);
					
					box.moveTo(lnmX, lnmY, lnmZ);
					box.styleType = RenderStyleType.SHADED;
					
					var alpha:Number = 1.0;
					
					var a:SolidColorFill = new SolidColorFill(0xb3b3b3, alpha); // Color en encima.
					var b:SolidColorFill = new SolidColorFill(0x7f7f7f, alpha); // Color en derecha.
					var c:SolidColorFill = new SolidColorFill(0x4d4d4d, alpha); // Color en izquierda.
					var d:SolidColorFill = new SolidColorFill(0xFFFFFF, alpha); // Color en atrás derecha.
					var e:SolidColorFill = new SolidColorFill(0xFFFFFF, alpha); // Color en atrás izquierda.
					var f:SolidColorFill = new SolidColorFill(0xFFFFFF, alpha); // Color debajo.
					
					box.styleType = RenderStyleType.SHADED;    
					box.fills = [a, b, c, d, e, f];
					
					gaMatrizPlacas[i][j] = box;
					
					gisEscena.addChild(box);
			
					lstrFilaTemp += "(" + i + ", " + j + ")" + "\t";
					
					lnmX += gnmPlacaAncho;
				}// Fin del for.
				
				trace(lstrFilaTemp);
				lstrFilaTemp = "";
				
				lnmX = lnmX_Original;
				lnmY += gnmPlacaLargo;
			}// Fin del for.
			
			// Se renderiza la escena.
			gisEscena.render();
		}// Fin de la función fn_inicializarMatrizPlacas.
		
		private function fn_inicializarMatriz_01(iaMatriz:Array, inmNumeroFilas:Number, inmNumeroColumnas:Number):Array
		{
			var lstrNombreFuncion:String = "fn_inicializarMatriz_01";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			iaMatriz = new Array(inmNumeroFilas);
			
			var i:Number = 0;
			var j:Number = 0;
			
			for(i=0; i<iaMatriz.length; i++)
			{
				iaMatriz[i] = new Array(inmNumeroColumnas);
			}// Fin del for.
			
			for(i=0; i<iaMatriz.length; i++)
			{
				for(j=0; j<iaMatriz[0].length; j++)
				{
					iaMatriz[i][j] = 0;
				}// Fin del for.
			}// Fin del for.
			
			return iaMatriz;
		}// Fin de la función fn_inicializarMatriz_01.
		
		private function fn_imprimirMatriz(iaMatriz:Array):void
		{
			var lstrNombreFuncion:String = "fn_imprimirMatriz";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			if(iaMatriz != null)
			{
				var i:Number = 0;
				var j:Number = 0;
				
				var lstrLinea:String = "";
				
				for(i=0; i<iaMatriz.length; i++)
				{
					for(j=0; j<iaMatriz[i].length; j++)
					{
						lstrLinea += iaMatriz[i][j] + "\t";
					}// Fin del for.
					
					trace(lstrLinea);
					lstrLinea = "";
				}// Fin del for.
			}// Fin del if.
		}// Fin de la función fn_imprimirMatriz.
		
		private var gaValoresAjuste:Array = [1, 10, 100, 1000, 10000];
		
		private function fn_imprimirMatrizConRedondeo(iaMatriz:Array, inmCifrasDecimales:Number):void
		{
			var lstrNombreFuncion:String = "fn_imprimirMatrizConRedondeo";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			if(inmCifrasDecimales > gaValoresAjuste.length)
			{
				return;
			}// Fin del if.
			
			var lnmValorAjuste:Number = gaValoresAjuste[inmCifrasDecimales];
			
			if(iaMatriz != null)
			{
				var i:Number = 0;
				var j:Number = 0;
				
				var lstrLinea:String = "";
				
				for(i=0; i<iaMatriz.length; i++)
				{
					for(j=0; j<iaMatriz[i].length; j++)
					{
						lstrLinea += (int(iaMatriz[i][j] * lnmValorAjuste) / lnmValorAjuste) + "\t";
					}// Fin del for.
					
					trace(lstrLinea);
					lstrLinea = "";
				}// Fin del for.
			}// Fin del if.
		}// Fin de la función fn_imprimirMatrizConRedondeo.
		
		private function fn_sumarMatrices(iarMatrizX:Array, iarMatrizY:Array):Array
		{
			var lstrNombreFuncion:String = "fn_sumarMatrices";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			var larSumaMatrices:Array = null;
			
			if(iarMatrizX != null && iarMatrizY != null)
			{
				if(iarMatrizX.length != iarMatrizY.length || iarMatrizX[0].length != iarMatrizY[0].length)
				{
					larSumaMatrices = null;
				}// Fin del if.
				else
				{
					larSumaMatrices = fn_inicializarMatriz_01(larSumaMatrices, iarMatrizX.length, iarMatrizX[0].length);
					
					var i:Number = 0;
					var j:Number = 0;
					
					for(i=0; i<larSumaMatrices.length; i++)
					{
						for(j=0; j<larSumaMatrices[0].length; j++)
						{
							larSumaMatrices[i][j] = iarMatrizX[i][j] + iarMatrizY[i][j];
						}// Fin del for.
					}// Fin del for.
				}// Fin del else.
			}// Fin del if.
			else
			{
				larSumaMatrices = null;
			}// Fin del else.
			
			return larSumaMatrices;
		}// Fin de la función fn_sumarMatrices.
		
		private function fn_multiplicarMatrizPorNumero(iaMatriz:Array, inmNumero:Number):Array
		{
			var lstrNombreFuncion:String = "fn_multiplicarMatrizPorNumero";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			var laMatrizResultado:Array = null;
			
			if(iaMatriz == null)
			{
				laMatrizResultado = null;
			}// Fin del if.
			else
			{
				var i:Number = 0;
				var j:Number = 0;
				
				laMatrizResultado = fn_inicializarMatriz_01(laMatrizResultado, iaMatriz.length, iaMatriz[0].length);
				
				for(i=0; i<iaMatriz.length; i++)
				{
					for(j=0; j<iaMatriz[0].length; j++)
					{
						laMatrizResultado[i][j] = iaMatriz[i][j] * inmNumero;
					}// Fin del for.
				}// Fin del for.
			}// Fin del else.
			
			return laMatrizResultado;
		}// Fin de la función fn_multiplicarMatrizPorNumero.
		
		private function f(inmT:Number, iaMatrizX:Array):Array
		{
			var lstrNombreFuncion:String = "f";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			var laMatrizY:Array = null;
			
			if(iaMatrizX == null)
			{
				laMatrizY = null;
			}// Fin del if.
			else
			{
				laMatrizY = fn_inicializarMatriz_01(laMatrizY, iaMatrizX.length, iaMatrizX[0].length);
				
				// Análisis de dz/dt.
				
				var i:Number = 0;
				var j:Number = 0;
				
				for(i=0; i<gnmM; i++)
				{
					for(j=0; j<gnmN; j++)
					{
						if((i == 0) || (i == gnmM - 1))
						{
							laMatrizY[i][j] = 0;
						}// Fin del if.
						else
						{
							laMatrizY[i][j] = iaMatrizX[i][j + gnmN];
						}// Fin del else.
					}// Fin del for.
				}// Fin del for.
				
				// Análisis de d2z/dt2.
				
				var d:Number = 0;
				
				var k:Number = 200.0;				// Constante elástica de los resortes.
				var dx:Number = gnmPlacaAncho;	// Separación de las placas en x.
				var dy:Number = gnmPlacaLargo;	// Separación de las placas en y.
				var Lo:Number = 0.4;			// Longitud del resorte en reposo.
				var beta:Number = 40.0;			// Coeficiente de fricción con el aire.
				var m:Number = 5.0;				// Masa de las placas.
				var g:Number = 9.8; 			// Gravedad.
				
				for(i=0; i<gnmM; i++)
				{
					for(j=0; j<gnmN; j++)
					{
						d = 0;
						
						if(i > 0)
						{
							d = d + k * (Math.sqrt(Math.pow(dy, 2) + Math.pow(iaMatrizX[i][j] - iaMatrizX[i - 1][j], 2)) - Lo) * fn_signo(iaMatrizX[i - 1][j] - iaMatrizX[i][j]);
						}// Fin del if.
						
						if(i < (gnmM - 1))
						{
							d = d + k * (Math.sqrt(Math.pow(dy, 2) + Math.pow(iaMatrizX[i][j] - iaMatrizX[i + 1][j], 2)) - Lo) * fn_signo(iaMatrizX[i + 1][j] - iaMatrizX[i][j]);
						}// Fin del if.
						
						if(j > 0)
						{
							d = d + k * (Math.sqrt(Math.pow(dx, 2) + Math.pow(iaMatrizX[i][j] - iaMatrizX[i][j - 1], 2)) - Lo) * fn_signo(iaMatrizX[i][j - 1] - iaMatrizX[i][j]);
						}// Fin del if.
						
						if(j < (gnmN - 1))
						{
							d = d + k * (Math.sqrt(Math.pow(dx, 2) + Math.pow(iaMatrizX[i][j] - iaMatrizX[i][j + 1], 2)) - Lo) * fn_signo(iaMatrizX[i][j + 1] - iaMatrizX[i][j]);
						}// Fin del if.
						
						d = d - beta * iaMatrizX[i][j + gnmN];
						
						d = d - m * g;
						
						d = d / m;
						
						if((i == 0) || (i == gnmM - 1))
						{
							laMatrizY[i][j + gnmN] = 0;
						}// Fin del if.
						else
						{
							laMatrizY[i][j + gnmN] = d;
						}// Fin del else.
					}// Fin del for.
				}// Fin del for.
			}// Fin del else.
			
			return laMatrizY;
		}// Fin de la función f.
		
		private function fn_signo(inmX:Number):Number
		{
			var lstrNombreFuncion:String = "fn_signo";
			trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			var lnmResultado:Number = undefined;
			
			if(inmX > 0)
			{
				lnmResultado = 1;
			}// Fin del if.
			else
			{
				if(inmX == 0)
				{
					lnmResultado = 0;
				}// Fin del if.
				else
				{
					if(inmX < 0)
					{
						lnmResultado = -1;
					}// Fin del if.
				}// Fin del else.
			}// Fin del else.
			
			return lnmResultado;
		}// Fin de la función fn_signo.
		
		private function fn_manejadorTimer(evento:TimerEvent):void
		{
			var lstrNombreFuncion:String = "fn_manejadorTimer";
			//trace(getQualifiedClassName(this) + "." + lstrNombreFuncion);
			
			myTimer.stop();
			
			gdFechaHora = new Date(gdFechaHora.getTime() + gnmTiempoPausaTimer);
			glblEtiquetaTiempo.text = gdFechaHora.toString();
			
			if(t < tMax)
			{
				var k1:Array = f(t, gaMatrizX);
				var k2:Array = f(t + h / 2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, h*0.5)));
				var k3:Array = f(t + h / 2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, h*0.5)));
				var k4:Array = f(t + h, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k3,h)));
				
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, h / 6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, 2 * h /6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k3, 2 * h /6));
				gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k4, h / 6));
				
				fn_imprimirMatrizConRedondeo(gaMatrizX, 2);
				
				for(var i:Number = 0; i<gaMatrizPlacas.length; i++)
				{
					for(var j:Number = 0; j<gaMatrizPlacas[0].length; j++)
					{
						IsoBox(gaMatrizPlacas[i][j]).z = gaMatrizX[i][j];
						gisEscena.render();
					}// Fin del for.
				}// Fin del for.
				
				t = t + h;
			}// Fin del if.
			else
			{
				myTimer.removeEventListener("timer", fn_manejadorTimer);
				
				return;
			}// Fin del else.
			
			myTimer.start();
		}// Fin de la función fn_manejadorTimer.
	}// Fin de la clase.
}// Fin del paquete.