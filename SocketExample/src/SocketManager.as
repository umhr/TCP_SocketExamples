package  
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	/**
	 * ...
	 * @author umhr
	 */
	public class SocketManager extends Socket 
	{
		private static var _instance:SocketManager;
		public function SocketManager(blocker:Blocker) {
			super();
			init();
			
		}
		public static function getInstance():SocketManager{
			if ( _instance == null ) {_instance = new SocketManager(new Blocker());};
			return _instance;
		}
		
		private function init():void
		{
			UICanvas.getInstance().addEventListener("bind", onBind);
			
		}
		
		private function onBind(e:Event):void 
		{
			UICanvas.getInstance().removeEventListener("bind", onBind);
			setConnect(UICanvas.getInstance().address, UICanvas.getInstance().port);
			UICanvas.getInstance().addEventListener("send", onSend);
		}
		private function onSend(e:Event):void 
		{
			sendRequest(UICanvas.getInstance().getInputText());
		}
		
		private var response:String;

		public function setConnect(host:String = null, port:uint = 0):void {
			trace(host, port);
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
		}

		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		private function writeln(str:String):void {
			str += "\n";
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		public function sendRequest(message:String = "test"):void {
			UICanvas.getInstance().addMessage("Sending: " + message);
			response = "";
			writeln(message);
			flush();
		}

		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			response += str;
			
			UICanvas.getInstance().addMessage("Received: "+str);
		}

		private function closeHandler(event:Event):void {
			UICanvas.getInstance().addMessage("closeHandler: " + event);
		}

		private function connectHandler(event:Event):void {
			UICanvas.getInstance().addMessage("connectHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			UICanvas.getInstance().addMessage("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			UICanvas.getInstance().addMessage("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			readResponse();
		}		
	}
	
}
class Blocker { };