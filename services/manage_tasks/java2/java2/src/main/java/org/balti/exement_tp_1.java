package org.balti;


import java.io.BufferedReader;//write on document:
import java.io.InputStreamReader;

public static void utisier_fichier(String str) throws IOException {
    FileWriter fw = new FileWriter("destination.txt", true);
    fw.write(str + "\n");
    fw.flush();
}

BufferedReader in = new BufferedReader(
        new InputStreamReader()
)





import java.util.ArrayList;

public class exement_tp_1 {
    public static void main(String[] args) {
        Groupes groupes = new Groupes();
        groupes.start();
    }
}



class Joueur extends Thread{
    double score = 0;
    public void run(){
        score = Math.random();
    }


}

class Groupes extends Thread{
    public void run(){
        double max_score = 0;
        String max_groupe = "groupe x";
        for(int i=0; i<3; i++){
            Joueur j1 = new Joueur();
            Joueur j2 = new Joueur();
            Joueur j3 = new Joueur();
            j1.start();
            j2.start();
            j3.start();

            try {
                j1.join(); // Wait for j1 to finish
                j2.join(); // Wait for j2 to finish
                j3.join(); // Wait for j3 to finish
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            double total = j1.score+j2.score+j3.score;

            if (total > max_score){
                max_score = total;
                max_groupe = "groupe "+String.valueOf(i+1);
            }

            System.out.println("score de groupe "+(i+1)+" est "+total+" : "+ j1.score+" "+j2.score+" "+j3.score);
        }

        System.out.println(max_groupe+" win");
    }
}
