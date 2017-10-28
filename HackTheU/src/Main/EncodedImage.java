package Main;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.xml.bind.DatatypeConverter;

public class EncodedImage {
	BufferedImage image;

	public EncodedImage(String path)
	{
		 try {
			image = ImageIO.read(new File(path));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String getEncodedImage()
	{
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		try {
			ImageIO.write(image, "png", output);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return DatatypeConverter.printBase64Binary(output.toByteArray());		
	}
}
