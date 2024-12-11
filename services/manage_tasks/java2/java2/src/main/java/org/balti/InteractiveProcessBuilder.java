package org.balti;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class InteractiveProcessBuilder  {
    public static void main(String[] args) {
        try {
// Demande à l'utilisateur de fournir un paramètre pour la commande
            BufferedReader userInput = new BufferedReader(new
                    InputStreamReader(System.in));
            System.out.print("Entrez un paramètre pour la commande : ");
            String parameter = userInput.readLine();
// Crée une liste de commandes avec la commande système et le paramètre
            List<String> commands = new ArrayList<>();
            commands.add("ping"); // Commande "ping"
            commands.add(parameter);
            ProcessBuilder pb = new ProcessBuilder(commands);
// Démarre le processus
            Process process = pb.start();
// Crée un BufferedReader pour lire la sortie du processus
            BufferedReader stdInput = new BufferedReader(new
                    InputStreamReader(process.getInputStream()));
            String s;
            System.out.println("Sortie du processus :");
            while ((s = stdInput.readLine()) != null) {
                System.out.println(s);
            }
// Attend que le processus se termine
            int exitCode = process.waitFor();
            System.out.println("Le processus s'est terminé avec le code de sortie: " + exitCode);
        } catch (IOException e) {
            System.err.println("Erreur d'entrée/sortie : " + e.getMessage());
        } catch (InterruptedException e) {
            System.err.println("Le processus a été interrompu : " +
                    e.getMessage());
        }
    }
}