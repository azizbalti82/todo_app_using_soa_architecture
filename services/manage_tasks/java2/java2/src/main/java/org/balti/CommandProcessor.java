package org.balti;

public class CommandProcessor implements Runnable {
    private String productName;
    private int iterations;
    public CommandProcessor(String productName, int iterations) {
        this.productName = productName;
        this.iterations = iterations;
    }
    @Override
    public void run() {
        long startTime = System.currentTimeMillis();
        for (int i = 1; i <= iterations; i++) {
// Simuler le traitement d'une commande en attendant un certain temps
            try {
                Thread.sleep(100); // Simule le temps de traitement
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        long endTime = System.currentTimeMillis();
        long elapsedTime = endTime - startTime;
        System.out.println("Thread " + Thread.currentThread().getName() + " (Product " + productName + ") took " + elapsedTime + " milliseconds to process " +
        iterations + " orders.");
    }
    public static void main(String[] args) {
// Créez deux instances de CommandProcessor avec différentes priorités et nombres d'itérations
        CommandProcessor processorA = new CommandProcessor("Product A", 100);
        CommandProcessor processorB = new CommandProcessor("Product B", 150);
// Créez deux threads avec des noms et des priorités différents
        Thread threadA = new Thread(processorA, "Thread Product A");
        Thread threadB = new Thread(processorB, "Thread Product B");
// Définissez les priorités
        threadA.setPriority(Thread.MAX_PRIORITY);
        threadB.setPriority(Thread.MIN_PRIORITY);
// Démarrez les threads
        threadA.start();
        threadB.start();
    }
}