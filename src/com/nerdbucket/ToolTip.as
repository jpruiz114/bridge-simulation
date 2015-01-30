package com.nerdbucket
{

    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    public class ToolTip
    {
    	private static var gstrNombreClase:String = "com.nerdbucket.ToolTip";
    	
    	// Options for customizing display
        private static var display_options:Object;

        // Stage object for reattaching container (to keep it above other
        // objects, since addChildAt doesn't work for higher numbers)
        private static var stage:Stage;

        // Stage dimensions for keeping labels onstage
        private static var stage_width: Number, stage_height: Number;

        // actual textfield object to hold our final string
        private static var label: TextField;

        // text that stores the string we're using
        private static var _text: String;

        // movieclips for this tooltip - container that holds everything together,
        // background for behind-tooltext-color, and clip for drop-shadow effect
        private static var _cont: MovieClip;
        private static var bg: Shape;
        private static var shadow: Shape;

        // Can the user see the tip?
        private static var _visible: Boolean;

        // Timer object for handling delayed hovers
        private static var timer: Timer;

        // Hash of hover objects' data
        public static var hover_objects:Dictionary;


    /******************************
          Accessors
    *******************************/
        // Text we're showing
        public static function set text(t:String):void
        {
          _text = t;
          label.htmlText = '<p align="' + display_options.text_align + '">' +
              '<font face="Verdana" size="10">' + _text + '</font></p>';
          reset_bg();
        }
        public static function get text():String {return _text;}
        // Is tooltip active?
        public static function get active():Boolean {return _cont.visible;}

    /******************************
    *     "Regular" code
    *******************************/

        // Starts the clock for showing a tooltip, sets our text attribute
        public static function start_show_timer(hover_object:Object):void
        {
            var delay_ms = hover_objects[hover_object].tip_delay;
            var tip_text = hover_objects[hover_object].tip_text;

            timer.delay = delay_ms;
            timer.repeatCount = 1;
            timer.start();
            ToolTip.text = tip_text;
        }

        public static function show_tip(e: Event):void
        {
            // Make sure container is top-level object
            stage.addChild(_cont);
            _cont.visible = true;
        }

        public static function hide():void
        {
            _cont.visible = false;
            timer.stop();
        }

        // Build the dynamic movie clips, set up defaults, hide the tooltip object
        public static function init(st, opt):void
        {
            hover_objects = new Dictionary();

            // Store the stage for reattaching _cont
            stage = st;

            // store the stage's dimensions - for this to be accurate we
            // can't have objects offstage when this call is made because
            // FOR SOME UNGODLY REASON, Flash devs thought it wise to make the
            // stage auto-size.
            stage_width   = st.stageWidth;
            stage_height  = st.stageHeight;

            // Set up default options and/or grab parameter options
            display_options = opt;
            display_options.opacity ||= 1;
            // Be lenient and allow integer values of opacity - translate them
            // here
            if (display_options.opacity > 1) {display_options.opacity /= 100.0;}
            display_options.text_align ||= 'left';
            display_options.default_delay ||= 500;

            // Build movie clips
            _cont   = new MovieClip();
            shadow  = new Shape();
            bg      = new Shape();

            // Built the label
            label = new TextField();
            label.x = 5;
            label.y = 0;
            label.width = 5;
            label.height = 5;
            label.autoSize = 'left';
            label.antiAliasType = flash.text.AntiAliasType.ADVANCED;
            label.selectable = false;
            label.multiline = true;

            // Now attach them as necessary - _cont to stage, others to _cont
            st.addChild(_cont);
            _cont.addChild(shadow);
            _cont.addChild(bg);
            _cont.addChild(label);

            // Set up, but don't start, the timer object (for future use)
            timer = new Timer(0, 0);
            timer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, show_tip);

            hide();
        }

        private static function set_tooltip_to_mouse(e:MouseEvent):void
        {
        	var lstrNombreFuncion:String = "set_tooltip_to_mouse";
			trace(gstrNombreClase + "." + lstrNombreFuncion);
			
            var w:Number = label.textWidth;
            var h:Number = label.textHeight;
            
            _cont.x = e.stageX - (w / 2);
            _cont.y = e.stageY - h - 15;
            
            e.updateAfterEvent();
        }// Fin de la función set_tooltip_to_mouse.
        
        // Reset the background and shadow to the size of the text label
        private static function reset_bg():void
        {
        	var lstrNombreFuncion:String = "reset_bg";
			trace(gstrNombreClase + "." + lstrNombreFuncion);
			
            var l:Number = label.x;
            var t:Number = label.y;
            var w:Number = label.textWidth + 12;
            var h:Number = label.textHeight + 4;

            bg.graphics.clear();
            bg.graphics.lineStyle(0, 0x333333, display_options.opacity);
            bg.graphics.beginFill(0xFFFFCC, display_options.opacity);
            bg.graphics.drawRect(l, t, w, h);
            bg.graphics.endFill();

            shadow.graphics.clear();
            shadow.graphics.beginFill(0x000000, display_options.opacity / 2);
            shadow.graphics.drawRect(l + 3, t + 3, w, h);
            shadow.graphics.endFill();
        }// Fin de la función reset_bg.
        
        import eDpLib.events.ProxyEvent;
        
        // Given a stage object, adds event handling to it and makes it respond
        // to the awesomeness of hover tips
        public static function attach
        (
        	iobjHoverObject:Object,
        	tip_text: String,
        	delay_ms:Number = undefined
        ):void
        {
			hover_objects[iobjHoverObject]=
			{
				tip_text:         tip_text,
				tip_delay:        delay_ms ? delay_ms : display_options.default_delay
            }
            
            iobjHoverObject.addEventListener
            (
            	flash.events.MouseEvent.MOUSE_OVER,
            	function(e:ProxyEvent):void
            	{
                	ToolTip.start_show_timer(iobjHoverObject);
            	}
            );
            
            iobjHoverObject.addEventListener
            (
            	flash.events.MouseEvent.MOUSE_OUT,
            	function(e:ProxyEvent):void
            	{
					ToolTip.hide();
				}
			);
			
            iobjHoverObject.addEventListener
            (
            	flash.events.MouseEvent.MOUSE_MOVE,
            	function(e:ProxyEvent):void
            	{
					ToolTip.set_tooltip_to_mouse(MouseEvent(e.targetEvent));
				}
			);
        }// Fin de la función attach.
    }
}
