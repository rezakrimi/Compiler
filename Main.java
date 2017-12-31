
import java.io.*;
import java.lang.reflect.Executable;

public class Main {

    public static void main(String[] args) {
        Writer writer =null;
        try {
            FileReader rd = new FileReader("./src/source.clike");
            Lexer lex = new Lexer(rd);
            String id = lex.yylex();
            try {
                 writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("/Users/reza/Desktop/output.txt"), "utf-8"));
            }catch (Exception e ){
                System.out.println(e.getMessage());
            }
            while(!id.equals("EOF"))
            {
                try{
                    System.out.println(id);
                    writer.write(id + "\n");
                    id = lex.yylex();
                }
                catch (Exception e){
                    System.out.println(e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                writer.close();
            }
            catch (Exception e){
                System.out.println(e.getMessage());
            }
        }
    }
}
