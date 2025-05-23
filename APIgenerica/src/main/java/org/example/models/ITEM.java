package org.example.models;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@Setter
public class ITEM {
    @Id
    private String id;
    private int codigo;
    private String nome;
    private String marca;
    private double preco;
    private int cep;
}
