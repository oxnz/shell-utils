package com.errpro.utils;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.Socket;
public class FileSender {
    private static int PORT = 8982;
    private static String SERVER = "10.23.229.148";
    private static String FILE = "C:\\Users\\zhangpan05\\Downloads\\x.tgz";
    private static int BUFSIZ = 1024*1024;
     
    public static void main(String[] args) {
        try {
            File file = new File(FILE);
            FileInputStream fis = new FileInputStream(file);
            BufferedInputStream bis = new BufferedInputStream(fis);
            Socket socket = new Socket(SERVER, PORT);
            System.out.println("connected");
            OutputStream os = socket.getOutputStream();
            byte[] buffer = new byte[BUFSIZ];
            for (int size = 0; size != -1; size = bis.read(buffer)) {
                os.write(buffer, 0, size);
                System.out.print(".");
            }
            os.flush();
            bis.close();
            fis.close();
            os.close();
            socket.close();
            System.out.println("done");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
