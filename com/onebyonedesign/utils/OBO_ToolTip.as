package com.onebyonedesign.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    public class OBO_ToolTip extends Sprite
    {
        private var _format:TextFormat;
        private var _tipText:TextField;
        private var _adv:Boolean;
        private var _ds:DropShadowFilter;
        private var _userTip:String;
        private var _root:DisplayObjectContainer;
        private var _orgY:int;
        private var _orgX:int;
        private var _tipAlpha:Number;
        private var _tipColor:uint;
        private static var OBO_TT:OBO_ToolTip;
        public static const SQUARE_TIP:String = "squareTip";
        public static const ROUND_TIP:String = "roundTip";

        public function OBO_ToolTip(param1:TipCreator, param2:DisplayObjectContainer, param3:Font, param4:uint = 16777215, param5:Number = 1, param6:String = "roundTip", param7:uint = 0, param8:int = 11, param9:Boolean = true)
        {
            if (!param1 is TipCreator)
            {
                throw new Error("OBO_ToolTip class must be instantiated with static method OBO_ToolTip.createToolTip() method.");
            }// end if
            _root = param2;
            _tipColor = param4;
            _tipAlpha = param5;
            _userTip = param6;
            _adv = param9;
            _format = new TextFormat(param3.fontName, param8, param7);
            _ds = new DropShadowFilter(3, 45, 0, 0.7, 2, 2, 1, 3);
            this.mouseEnabled = false;
            return;
        }// end function

        private function onTipMove(param1:MouseEvent) : void
        {
            this.x = Math.round(param1.stageX);
            this.y = Math.round(param1.stageY - 2);
            if (this.y - this.height < 0)
            {
                var _loc_2:int;
                _tipText.scaleY = -1;
                this.scaleY = _loc_2;
                _tipText.y = _userTip == ROUND_TIP ? (-18) : (-16);
                this.y = Math.round(param1.stageY + 5);
            }
            else
            {
                var _loc_2:int;
                _tipText.scaleY = 1;
                this.scaleY = _loc_2;
                _tipText.y = _orgY;
            }// end else if
            if (this.x - (this.width - 18) < 0)
            {
                if (_userTip == ROUND_TIP)
                {
                    var _loc_2:int;
                    _tipText.scaleX = -1;
                    this.scaleX = _loc_2;
                    _tipText.x = 5;
                }// end if
            }
            else
            {
                var _loc_2:int;
                _tipText.scaleX = 1;
                this.scaleX = _loc_2;
                _tipText.x = _orgX;
            }// end else if
            param1.updateAfterEvent();
            return;
        }// end function

        public function addTip(param1:String) : void
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:int;
            _root.addChild(this);
            _tipText = new TextField();
            _tipText.mouseEnabled = false;
            _tipText.selectable = false;
            _tipText.defaultTextFormat = _format;
            _tipText.antiAliasType = _adv ? (AntiAliasType.ADVANCED) : (AntiAliasType.NORMAL);
            _tipText.width = 1;
            _tipText.height = 1;
            _tipText.autoSize = TextFieldAutoSize.LEFT;
            _tipText.embedFonts = true;
            _tipText.multiline = true;
            _tipText.text = param1;
            _loc_2 = _tipText.textWidth;
            _loc_3 = _tipText.textHeight;
            switch(_userTip)
            {
                case ROUND_TIP:
                {
                    _loc_4 = [[0, -13.42], [0, -2], [10.52, -15.7], [13.02, -18.01, 13.02, -22.65], [13.02, -16 - _loc_3], [13.23, -25.23 - _loc_3, 3.1, -25.23 - _loc_3], [-_loc_2, -25.23 - _loc_3], [-_loc_2 - 7, -25.23 - _loc_3, -_loc_2 - 7, -16 - _loc_3], [-_loc_2 - 7, -22.65], [-_loc_2 - 7, -13.42, -_loc_2, -13.42]];
                    break;
                }// end case
                case SQUARE_TIP:
                {
                    _loc_4 = [[-(_loc_2 / 2 + 5), -16], [-(_loc_2 / 2 + 5), -(18 + _loc_3 + 4)], [_loc_2 / 2 + 5, -(18 + _loc_3 + 4)], [_loc_2 / 2 + 5, -16], [6, -16], [0, 0], [-6, -16], [-(_loc_2 / 2 + 5), -16]];
                    break;
                }// end case
                default:
                {
                    throw new Error("Undefined tool tip shape in OBO_ToolTip!");
                    break;
                }// end default
            }// end switch
            _loc_5 = _loc_4.length;
            this.graphics.beginFill(_tipColor, _tipAlpha);
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                // label
                if (_loc_6 == 0)
                {
                    this.graphics.moveTo(_loc_4[_loc_6][0], _loc_4[_loc_6][1]);
                }
                else if (_loc_4[_loc_6].length == 2)
                {
                    this.graphics.lineTo(_loc_4[_loc_6][0], _loc_4[_loc_6][1]);
                }
                else if (_loc_4[_loc_6].length == 4)
                {
                    this.graphics.curveTo(_loc_4[_loc_6][0], _loc_4[_loc_6][1], _loc_4[_loc_6][2], _loc_4[_loc_6][3]);
                }// end else if
                _loc_6++;
            }// end while
            this.graphics.endFill();
            this.x = stage.mouseX;
            this.y = stage.mouseY;
            this.filters = [_ds];
            _tipText.x = _userTip == ROUND_TIP ? (Math.round(-_loc_2)) : (Math.round(-_loc_2 / 2) - 2);
            _orgX = _tipText.x;
            _tipText.y = Math.round(-21 - _loc_3);
            _orgY = _tipText.y;
            this.addChild(_tipText);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
            return;
        }// end function

        public function removeTip() : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
            this.removeChild(_tipText);
            this.graphics.clear();
            _root.removeChild(this);
            return;
        }// end function

        public function set tipShape(param1:String) : void
        {
            if (param1 != ROUND_TIP && param1 != SQUARE_TIP)
            {
                throw new Error("Invalid tip shape \"" + param1 + "\" specified at OBO_ToolTip.tipShape.");
            }// end if
            _userTip = param1;
            return;
        }// end function

        public static function createToolTip(param1:DisplayObjectContainer, param2:Font, param3:uint = 16777215, param4:Number = 1, param5:String = "roundTip", param6:uint = 0, param7:int = 11, param8:Boolean = true) : OBO_ToolTip
        {
            if (OBO_TT == null)
            {
                OBO_TT = new OBO_ToolTip(new TipCreator(), param1, param2, param3, param4, param5, param6, param7, param8);
            }// end if
            return OBO_TT;
        }// end function

    }
}
