package 
{ 
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
     
    public class ServerSocketExample extends Sprite 
    { 
        private var serverSocket:ServerSocket; 
        private var clientSockets:Array = new Array(); 
		private var socket:Socket;
 
        public function ServerSocketExample() 
        { 
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			UICanvas.getInstance().addEventListener("bind", onBind);
		}
		
		private function onBind(e:Event):void {
			
            try 
            { 
                // Create the server socket 
                serverSocket = new ServerSocket(); 
                 
                // Add the event listener 
                serverSocket.addEventListener( Event.CONNECT, connectHandler ); 
                serverSocket.addEventListener( Event.CLOSE, onClose ); 
                 
                // Bind to local port 8087 
                //serverSocket.bind( 8087, "127.0.0.1" ); 
                serverSocket.bind( UICanvas.getInstance().port, UICanvas.getInstance().address );
                 
                // Listen for connections 
                serverSocket.listen(); 
                //trace( "Listening on " + serverSocket.localPort );
				UICanvas.getInstance().addMessage("Listening on " + serverSocket.localAddress +":" + serverSocket.localPort);
				
				UICanvas.getInstance().removeEventListener("bind", onBind);
				UICanvas.getInstance().addEventListener("send", onSend);
            } 
            catch(e:SecurityError) 
            { 
                trace(e); 
            } 
        } 
		
 		private function onSend(e:Event):void 
		{
			sendMessage(UICanvas.getInstance().getInputText());
			UICanvas.getInstance().removeEventListener("send", onSend);
		}
		
		public function sendMessage(message:String):void {
            socket.writeUTFBytes( message ); 
            socket.flush();
			UICanvas.getInstance().addMessage( "Sending: " + message );
		}
		
        public function connectHandler(event:ServerSocketConnectEvent):void 
        { 
            //The socket is provided by the event object 
            socket = event.socket as Socket; 
            clientSockets.push( socket ); 
            
            socket.addEventListener( ProgressEvent.SOCKET_DATA, socketDataHandler); 
            socket.addEventListener( Event.CLOSE, onClientClose ); 
            socket.addEventListener( IOErrorEvent.IO_ERROR, onIOError ); 
            
            //Send a connect message 
            sendMessage("Connected.");
			
            UICanvas.getInstance().addMessage( "Sending connect message" ); 
        } 
         
        public function socketDataHandler(event:ProgressEvent):void 
        { 
			
            //Read the message from the socket 
            var message:String = socket.readUTFBytes( socket.bytesAvailable ); 
            UICanvas.getInstance().addMessage( "Received: " + message); 
			
			if (UICanvas.getInstance().isEcho) {
				// Echo the received message back to the sender 
				message = "Echo -- " + message; 
				sendMessage(message);
			}
        } 
         
        private function onClientClose( event:Event ):void 
        { 
            UICanvas.getInstance().addMessage( "Connection to client closed." ); 
            //Should also remove from clientSockets array... 
        } 
 
        private function onIOError( errorEvent:IOErrorEvent ):void 
        { 
            UICanvas.getInstance().addMessage( "IOError: " + errorEvent.text ); 
        } 
 
        private function onClose( event:Event ):void 
        { 
            UICanvas.getInstance().addMessage( "Server socket closed by OS." ); 
        } 
	}
}