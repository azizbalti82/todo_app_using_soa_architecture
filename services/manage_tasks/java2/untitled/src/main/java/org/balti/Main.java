package org.balti;

class robot {
    public synchronized void utiliserRobot (String cuisinier,String action,int duree,String msg,String msg_sortie) {
        System.out.println(msg);
        //duree est en second
        if(action.equals("batteur")) {
            try {
                Thread.sleep(duree*1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            //System.out.println("fin de batteur");
        }else if(action.equals("melangeur")) {
            //System.out.println("debut de melangeur pour le cuisinier "+cuisinier+" avec une durer de "+duree+"s");
            try {
                Thread.sleep(duree*1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            //System.out.println("fin de melangeur");
        }
        System.out.println(msg_sortie);
    }
}



class cuisinier implements Runnable {
    @Override
    public void run() {
        String cuisinier_name = Thread.currentThread().getName();
        if(cuisinier_name.equals("cuisinier1")){
            //fondre le chocolat
            System.out.println("cuisinier 1 : fondre la chocolat  ; durer = "+3+"s");
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            System.out.println("cuisinier 1 : fin de fondre la chocolat");
            //battre les oeufs
            //System.out.println("cuisinier 1 : battre les oeufs  ; durer = "+2+"s");
            Main.robot.utiliserRobot("cuisinier1","batteur",2,"cuisinier 1 : battre les oeufs  ; durer = "+2+"s","cuisinier 1 : fin de battre les oeufs");
            //System.out.println("cuisinier 1 : fin de battre les oeufs");
            //melanger les ingredients
            //System.out.println("cuisinier 1 : melanger les ingredients  ; durer = "+4+"s");
            Main.robot.utiliserRobot("cuisinier1","melangeur",4,"cuisinier 1 : melanger les ingredients  ; durer = "+4+"s","cuisinier 1 : fin de melanger les ingredients");
            //System.out.println("cuisinier 1 : fin de melanger les ingredients");
        }else if(cuisinier_name.equals("cuisinier2")){
            //melanger la pate
            //System.out.println("cuisinier 2 : melanger la patte ; durer = 4s");
            Main.robot.utiliserRobot("cuisinier2","melangeur",4,"cuisinier 2 : melanger la patte ; durer = 4s","cuisinier 2 : fin de melanger la patte");
            //System.out.println("cuisinier 2 : fin de melanger la patte");
            //ajouter les pepites de chocolat
            try {
                System.out.println("cuisinier 2 : ajouter les pepites de chocolat ; durer = 3s");
                Thread.sleep(3000);
                System.out.println("cuisinier 2 : fin de ajouter les pepites de chocolat");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}


class Main{
    public static robot robot;
    public static void main(String[] args) {
        robot = new robot();
        Thread cuisinier1 = new Thread(new cuisinier(), "cuisinier1");
        Thread cuisinier2 = new Thread(new cuisinier(), "cuisinier2");

        cuisinier1.start();
        cuisinier2.start();

        try{
            cuisinier1.join();
            cuisinier2.join();
        }catch (Exception e){
            e.printStackTrace();
        }

        System.out.println("les deux cuisiniers ont terminer leurs recettes");


    }
}