package Main;

import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpServer;

public class Server {
	
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(60000), 0);
        
        //PUBLIC SERVICES
        //TODO: PLACE OUR BASE PATH HERE
        server.createContext("/facePay", new APIService());
        
        server.start();

    }
    
    
}