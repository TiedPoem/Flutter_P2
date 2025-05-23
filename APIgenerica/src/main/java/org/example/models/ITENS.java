package org.example.models;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;

@Document
@Getter
@Setter
@Data
public class ITENS {
    @Id
    private String id;
    private ITEM item;
    private String dataCadastro;
}