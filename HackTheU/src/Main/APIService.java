package Main;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class APIService implements HttpHandler {
	@Override
	public void handle(HttpExchange t) {
		Runnable r = new GenomeAuthenticationThread(t);
		new Thread(r).start();
	}
}

class GenomeAuthenticationThread implements Runnable {
	//TODO: PLACE BASE URI HERE
	private final String _baseURI = "/facePay";
	private HttpExchange t;
	private String requestString;
	private JsonObject jsonRequest;
	private String response;
	private StringBuilder responseBuffer;
	private int httpResponseCode;
	
	public GenomeAuthenticationThread(HttpExchange parameter) {
		t = parameter;
	}

	public void run() {
		InputStream is; // used for reading in the request data
		OutputStream os; // used for writing out the response data
		requestString = "";
		jsonRequest = new JsonObject();
		response = "";

		// put the response text in this buffer to be sent out at the end
		responseBuffer = new StringBuilder(); 
		// This is where the HTTP response code to send back to the client should go
		httpResponseCode = 404;

		String uri = t.getRequestURI().getPath();
		String requestMethod = t.getRequestMethod();
		String requestQuery = t.getRequestURI().getQuery();

		// We parse the GET parameters through a Filter object that is registered in ServerBootstrap
		// It is possible to parse POST parameters like this too, but I don't want to
		Map<String, String> getParams = new HashMap<String, String>();
		
		
		// GET Requests won't have any data in the body
		if(requestMethod.equalsIgnoreCase("GET")){
			getParams = ServerUtils.parseQuery(requestQuery);
			System.out.println(new Date().toString() + ": " + requestQuery);
		} 		
		else if (requestMethod.equalsIgnoreCase("POST")) {
			try {
				StringBuilder requestBuffer = new StringBuilder();
				is = t.getRequestBody();
				int rByte;
				while ((rByte = is.read()) != -1) {
					requestBuffer.append((char) rByte);
				}
				is.close();

				if (requestBuffer.length() > 0) {
					requestString = URLDecoder.decode(requestBuffer.toString(), "UTF-8");
				} else {
					requestString = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		/*
		 * code to respond to each type of request goes here THIS IS WHERE THE MAGIC HAPPENS
		 * 
		 * requestString is a String that hold JSON (or not) data to be parsed
		 * and acted upon uri is a String that holds the request path
		 * (disregards http://hostname:port as well as any GET parameters)
		 * responseBuffer is a StringBuilder that you write your return data to
		 * in JSON format httpResponseCode is an int that holds what response
		 * code you want to return
		 */
		System.out.println(new Date().toString() + ": " + requestString);
		try {
			//TODO: DETERMINE IF POST OR GET... THEN CALL METHOD BASED ON PATH.
			if (requestMethod.equalsIgnoreCase("POST")) {
				if (uri.equals(_baseURI+"/login") || uri.equals(_baseURI+"/login/")) {
					loginUser();
				}
			} else if (requestMethod.equalsIgnoreCase("GET")){
				if (uri.equals(_baseURI+"/getUserInfo") || uri.equals(_baseURI+"/getUserInfo/")) {
					getUserInfo(getParams);
				}
				//put get requests here
			}
		} catch (Exception e){
			responseBuffer.append("Failed");
			httpResponseCode = 400;
		}

		// this section sends back the return data
		try {
			response = responseBuffer.toString();

			Headers h = t.getResponseHeaders();
			h.add("Content-Type", "application/json; charset=UTF-8");
			h.add("Access-Control-Allow-Origin", "*");
			h.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
			h.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");

			t.sendResponseHeaders(httpResponseCode, response.getBytes("UTF-8").length);
			os = t.getResponseBody();
			os.write(response.getBytes("UTF-8"), 0, response.getBytes("UTF-8").length);
			os.flush();
			os.close();
			t.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	

	
	public void loginUser(){
		
		//This gets params from post request
		JsonParser parser = new JsonParser();
		jsonRequest = parser.parse(requestString).getAsJsonObject();
		String email = jsonRequest.get("UserEmail").getAsString();
		String pword = jsonRequest.get("UserPassword").getAsString();

		//CHECKS IF VALID AND PUT TOKEN AS A JSON OBJECT INTO RESPONSE BUFFER AND UPDATES RESPONSE CODE.
		if (email != null && pword != null) {
			JsonObject jsonResponse = new JsonObject();
			String token = generateTokenString();
			jsonResponse.addProperty("UserToken", token);
			responseBuffer.append(jsonResponse.toString());
			httpResponseCode = 200;
		}  else {
			responseBuffer.append("Invalid UserEmail or UserPassword");
			httpResponseCode = 400;
		}
	}
	
	public void getUserInfo(Map<String, String> params){
		//TODO: GET PARAMS
		String userToken = params.get("UserToken");
		String appToken = params.get("AppToken");
		String[] scopes = params.get("Scopes").split(",");

		if (userToken != null && appToken != null) {
			//TODO MAKE JSON FOR GET REQUEST
			JsonObject jsonResponse = new JsonObject();
			jsonResponse.addProperty("Name", "paywithyoFACE");
			responseBuffer.append(jsonResponse.toString());
			httpResponseCode = 200;
		} else {
			responseBuffer.append("Invalid UserToken");
			httpResponseCode = 400;
		}
		
	}
	
	
	//THIS JUST GENERATES A RANDOM TOKEN... WE DONT NEED TO USE IT.
	public String generateTokenString() {
		Random rng = new Random();
		int length = 45;
		String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890._-~";
	    String text = "";
	    for (int i = 0; i < length; i++)
	    {
	        text += characters.charAt(rng.nextInt(characters.length()));
	    }
	    return text;
	}
	
}

