package org.balti;
import java.util.concurrent.atomic.AtomicInteger;
public class ConcurrencyMain3 {
    public static AtomicInteger count = new AtomicInteger(0);
    public static void main(String[] args) throws InterruptedException {
        Thread th1 = new Thread(new Concurrency3());
        Thread th2 = new Thread(new Concurrency3());
        th1.start();
        th2.start();
        th1.join();
//th2.join();
        System.out.println("count = "+count);
    }
}

class Concurrency3 implements Runnable{
    @Override
    public void run() {
// TODO Auto-generated method stub
        for (int i = 0; i < 10000; i++) {
            ConcurrencyMain3.count.incrementAndGet();
        }
    }
}