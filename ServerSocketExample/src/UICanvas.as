package  
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author umhr
	 */
	public class UICanvas extends Sprite
	{
		private static var _instance:UICanvas;
		public function UICanvas(blocker:Blocker){init();}
		public static function getInstance():UICanvas{
			if ( _instance == null ) {_instance = new UICanvas(new Blocker());};
			return _instance;
		}
		
		private var _addressText:Text;
		private var _portText:Text;
		private var _textArea:TextArea;
		private var _inputText:Text;
		private var _isEcho:Boolean;
		private var _sendButton:PushButton;
		private var _shield:Sprite = new Sprite();
		private function init():void
		{
			setUI();
		}
		
		private function setUI():void 
		{
			Style.embedFonts = false;
			Style.fontName = "PF Ronda Seven";
			Style.fontSize = 10;
			
			_inputText = new Text(this, 8, 38);
			_inputText.width = 350;
			_inputText.height = 20;
			
			_sendButton = new PushButton(this, 360, 38, "send", onSend);
			
			_textArea = new TextArea(this, 8, 62, "init");
			_textArea.width = 350;
			_textArea.height = 200;
			
			// bind前はクリックさせないように
			_shield.graphics.beginFill(0xFFFFFF, 0.5);
			_shield.graphics.drawRect(0, 0, 465, 300);
			_shield.graphics.endFill();
			addChild(_shield);
			
			new Label(this, 8, 8, "Address");
			_addressText = new Text(this, 48, 8);
			_addressText.width = 120;
			_addressText.height = 20;
			_addressText.text = "127.0.0.1";
			
			new Label(this, 186, 8, "Port");
			_portText = new Text(this, 226, 8);
			_portText.width = 120;
			_portText.height = 20;
			_portText.text = "8087";
			
			new PushButton(this, 360, 8, "Bind", onBind);
		}
		
		/**
		 * 127.0.0.1
		 */
		public function get address():String {
			return _addressText.text;
		}
		/**
		 * 8087
		 */
		public function get port():int {
			return int(_portText.text);
		}
		
		/**
		 * Echoボタンの表示をするかを設定します。
		 * @param	enabled
		 */
		public function setEchoButton(enabled:Boolean = false):void {
			var echoButton:PushButton = new PushButton(this, 360, 210, "set Echo", onEchoToggle);
			addChildAt(echoButton, 0);
			echoButton.toggle = true;
			echoButton.selected = !enabled;
			isEcho = !enabled;
		}
		
		private function onBind(event:Event):void 
		{
			PushButton(event.target).enabled = false;
			dispatchEvent(new Event("bind"));
			removeChild(_shield);
		}
		
		private function onEchoToggle(event:Event):void 
		{
			isEcho = (event.target as PushButton).selected;
		}
		
		/**
		 * echoが有効か否かを返します。
		 */
		public function get isEcho():Boolean 
		{
			return _isEcho;
		}
		public function set isEcho(value:Boolean):void 
		{
			_inputText.enabled = !value;
			_sendButton.enabled = !value;
			_isEcho = value;
		}
		
		private function onSend(event:Event):void 
		{
			dispatchEvent(new Event("send"));
		}
		
		/**
		 * メッセージ表示エリアにメッセージを追加します。
		 * @param	message
		 */
		public function addMessage(message:String):void {
			
			var text:String = message +"\n" + _textArea.text;
			
			_textArea.text = text;
		}
		
		/**
		 * 入力エリアのテキストを返します。
		 * 返す際にテキストは削除されます。
		 * @return
		 */
		public function getInputText():String {
			var text:String = _inputText.text;
			_inputText.text = "";
			return text;
		}
		
	}
	
}
class Blocker { };