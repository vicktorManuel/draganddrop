package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import com.greensock.*;
import com.greensock.easing.*;
	

	public class Main extends MovieClip
	{
		
		var xPos:int;
		var yPos:int;
		var puntosVar:int=0;
		var terminado:int=0;
		var arregloDeObjetos:Array;
		var fl_SecondsToCountDown:Number = 60;
		var fl_CountDownTimerInstance:Timer= new Timer(1000, fl_SecondsToCountDown);;
		var vidas = 3;
		var vidasMovieClip:Vidas;
		var botonOk:BotonOk;
		var sonidoFondo:Sound;
		var sonidoError:Sound;
		var sonidoAcierto:Sound;
		
		
		public function Main():void
		{
			
			initComponentes();
			addListeners(arregloDeObjetos);
			initPuntos();
			
		}
		
		
      	
		public function reiniciaNivel(e:MouseEvent):void{
			trace("Reinicia Nivel");
			puntosVar=0;
			puntos.text=puntosVar.toString();
			fl_SecondsToCountDown=60;
			intenta.visible=false;
			
			fl_CountDownTimerInstance.addEventListener(TimerEvent.TIMER, fl_CountDownTimerHandler);
            fl_CountDownTimerInstance.start();
			removeChild(botonOk);			
		}
		
		private function initComponentes():void{
			sonidoAcierto=new AcertasteSound();
			sonidoError= new errorSound();
			sonidoFondo= new FondoSound();
			sonidoFondo.play(1300,3000);
			puntos.text=puntosVar.toString();
			intenta.visible=false;
			creacionDeVidas(vidas);
			arregloDeObjetos = new Array (circulo,pentagono,triangulo, cuadrado);
			fl_CountDownTimerInstance = new Timer(1000, fl_SecondsToCountDown);
			fl_CountDownTimerInstance.addEventListener(TimerEvent.TIMER, fl_CountDownTimerHandler);
            fl_CountDownTimerInstance.start();
		}
		private function initPuntos():void{
			//puntosVar=1;
		}
		
		private function creacionDeVidas(v:int):void{
			
			var posicion:int=220;
			
			for(var i:int=1;i<=v; i++){
				vidasMovieClip=new Vidas();
				vidasMovieClip.x=posicion;
				vidasMovieClip.y=580;
				posicion+=50;
				vidasMovieClip.name="vidas"+i.toString();
			    addChild(vidasMovieClip);
			}
			
		}

		private function getPosition(target:Object):void
		{
			xPos = target.x;
			yPos = target.y;
		}

		private function dragObject(e:MouseEvent):void
		{
			getPosition(e.target);

			e.target.startDrag(true);
		}

		private function stopDragObject(e:MouseEvent):void
		{
			
			if (e.target.hitTestObject(getChildByName(e.target.name + "Target")))
			{
				sonidoAcierto.play();
				e.target.x = getChildByName(e.target.name + "Target").x;
				e.target.y = getChildByName(e.target.name + "Target").y;
				puntosVar+=1;
				trace("puntos var:: "+puntosVar);
				terminado++;
				puntos.text = puntosVar.toString();
				trace("puntos var actuales:: "+puntosVar);
				gameOver(false);
			}
			else
			{
				sonidoError.play();
				trace("puntos var"+puntosVar);
				TweenLite.to(e.target, 0.5, {y:yPos,x:xPos, ease:Linear.easeNone});
				
				
				if(puntosVar<=0){
					puntosVar=0;
				}else{
				 puntosVar-=1;
					}
				puntos.text = puntosVar.toString();
				trace("puntos var actuales"+puntosVar);
				
			}

			e.target.stopDrag();
		}
		function remover():void{
		
			for(var i:int=0;i<=3;i++){
				if(this.getChildByName("vidas"+i)!=null){
					removeChild(this.getChildByName("vidas"+i));
				}
			}
				
			    fl_CountDownTimerInstance.removeEventListener(TimerEvent.TIMER, fl_CountDownTimerHandler);
			    fl_CountDownTimerInstance.stop();
			
		}
		function gameOver(perdiste:Boolean):void{
			
			if(perdiste)
			{
				
				if (vidas<=1){
						remover();
						gotoAndStop(3);
					}
					else{
						intenta.visible=true;
						creacionDeBotonIntentar();
						removeChild(this.getChildByName("vidas"+vidas));
						vidas--;
					}
			}
			else
				{
				if ( terminado >= arregloDeObjetos.length) 
				{
					gotoAndStop(2);
					remover();
				}
			}
		}
		private function creacionDeBotonIntentar():void{
			        botonOk=new BotonOk();
					botonOk.x=800;
					botonOk.y=700;
					botonOk.addEventListener(MouseEvent.CLICK,reiniciaNivel);
					addChild(botonOk);
		}
		private function addListeners(objects:Array):void
		{
            			
			
			for (var i:int = 0; i < objects.length; i++)
			{
				objects[i].addEventListener(MouseEvent.MOUSE_DOWN, dragObject);
				objects[i].addEventListener(MouseEvent.MOUSE_UP, stopDragObject);
			}
		}
		
		/* Tiempo */
	
      private function fl_CountDownTimerHandler(event:TimerEvent):void
		{
		 if(null != fl_CountDownTimerInstance){
		  fl_SecondsToCountDown--;
		  tiempo.text=fl_SecondsToCountDown.toString();
		  if( fl_SecondsToCountDown <= 0) {
			 gameOver(true); 
		  }
	        
	  }
		  
		}

		/*Fin de tiempo*/
	
	}
}