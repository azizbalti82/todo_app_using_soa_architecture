package org.balti;


import java.io.*;
public class process {
    public static void executerCommande(String commande) {
        try {
// Créez un processus en utilisant la classe Runtime
            Process process = Runtime.getRuntime().exec(commande);
// Attendre que le processus se termine
            process.waitFor();
// Affichez le code de sortie du processus
            System.out.println("Code de sortie : " + process.exitValue());
// Fermez le flux de sortie
// reader.close();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        try {
// Demandez à l'utilisateur de saisir une commande
            BufferedReader br = new BufferedReader(new
                    InputStreamReader(System.in));
            System.out.print("Veuillez entrer une commande système : ");
            String commande = br.readLine();
// Exécutez la commande
            executerCommande(commande);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}