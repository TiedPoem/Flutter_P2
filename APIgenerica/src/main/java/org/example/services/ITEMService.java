package org.example.services;

import org.example.models.ITEM;
import org.example.repositories.ITEMRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.Optional;

@Service
public class ITEMService {
    @Autowired
    private ITEMRepository itemRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    public ITEM save(ITEM item){
        if (item.getId() == null) {
            // Somente gera novo código se for criação
            item.setCodigo(getNextCodigo());
        }
        return itemRepository.save(item);
    }
    public List<ITEM> findAll(){
        return itemRepository.findAll();
    }
    public Optional<ITEM> findById(String id){
        return itemRepository.findById(id);
    }
    public void deleteById(String id){
        itemRepository.deleteById(id);
    }

    private int getNextCodigo() {
        Query query = new Query().with(Sort.by(Sort.Direction.DESC, "codigo")).limit(1);
        ITEM last = mongoTemplate.findOne(query, ITEM.class);
        return (last != null) ? last.getCodigo() + 1 : 1;
    }
}
