package org.example.repositories;

import org.example.models.ITEM;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ITEMRepository extends MongoRepository<ITEM, String> {
}
