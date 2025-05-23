package org.example.services;

import org.example.models.ITENS;
import org.example.repositories.ITENSRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ITENSService {
    @Autowired
    private ITENSRepository itensRepository;
    public ITENS save(ITENS itens){
        itensRepository.save(itens);
        return itens;
    }
    public List<ITENS> findAll(){
        return itensRepository.findAll();
    }
    public Optional<ITENS> findById(String id){
        return itensRepository.findById(id);
    }
    public void deleteById(String id){
        itensRepository.deleteById(id);
    }
}
