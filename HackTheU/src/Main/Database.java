package Main;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;

public class Database {

	public static HashMap<String,user> users = new HashMap<String,user>();
	
	
	public static newUserResponse addUser(user newUser)
	{
		newUserResponse response = new newUserResponse();
		if(users.putIfAbsent(newUser.userName, newUser)!=null)
		{
			response.success=false;
			response.status=new StringBuffer("User already exists");
			System.out.println("Failure");
		}else
		{
			response.success=true;
			response.status=new StringBuffer("");
			System.out.println("New user added: "+newUser.userName);
		}
		
		try {
			save();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return response;
	}
	
	public static boolean loginUser(String username,String password)
	{
		user currentUser=users.get(username);
		
		if(currentUser!=null)
		{
			return currentUser.password.equals(password);
		}
		return false;
	}
	
	public static void save() throws IOException
	{
		System.out.println("Saving Database");
		File fout = new File("res/users.txt");
		FileOutputStream fos = new FileOutputStream(fout);
	 
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
	 
		for(user current:users.values())
		{
			bw.write(current.toString());
			bw.newLine();
		}
			
		bw.close();
	}
	
	public static void load() throws FileNotFoundException
	{
		System.out.println("Loading Database");
		 try {

	            File f = new File("res/users.txt");

	            BufferedReader b = new BufferedReader(new FileReader(f));

	            String readLine = "";	            

	            while ((readLine = b.readLine()) != null) {
	                
	            	String[] values = readLine.split(" ");
	            	
	            	users.put(values[0],new user(values[0],values[1],values[2]));
	            	
	            }

	        } catch (IOException e) {
	            e.printStackTrace();
	        }

	    }

}
