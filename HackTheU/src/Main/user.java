
package Main;

public class user {

	
	String userName;
	String prn; 
	String password;
	
	public user(String userName,String prn,String password)
	{
		this.userName=userName;
		this.prn=prn;
		this.password=password;
	}
	
	@Override
	 public String toString()
	 {
		 return userName +" "+ prn + " "+password;
	 }
}
