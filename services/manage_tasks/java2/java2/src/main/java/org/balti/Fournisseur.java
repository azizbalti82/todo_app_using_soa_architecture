package org.balti;

import java.util.ArrayList;

public class Fournisseur<T> {
    String nom;
    String id;
    ArrayList<T> produits = new ArrayList<>();


}


class Produit<T> {
    String nom;
    String id;
    double prix;


}
