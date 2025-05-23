package org.example.repositories;

import org.example.models.ITENS;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ITENSRepository extends MongoRepository<ITENS, String> {
}
