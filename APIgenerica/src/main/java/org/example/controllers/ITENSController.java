package org.example.controllers;

import org.example.constant.Constant;
import org.example.models.ITEM;
import org.example.models.ITENS;
import org.example.services.ITEMService;
import org.example.services.ITENSService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin(origins = "http://localhost:3000", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE})
public class ITENSController {

    @Autowired
    private ITENSService itensService;

    @Autowired
    private ITEMService itemService;

    @PostMapping(Constant.API_ITENS)
    public ResponseEntity<ITENS> createCustomer(@RequestBody ITENS itens) {
        ITEM item = itemService.save(itens.getItem());
        itens.setItem(item);
        ITENS savedCustomer = itensService.save(itens);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedCustomer);
    }

    @PutMapping(Constant.API_ITENS)
    public ResponseEntity<ITENS>  update(@RequestBody ITENS itens){
        ITENS savedCustomer = itensService.save(itens);
        return ResponseEntity.ok(savedCustomer);

    }
    @DeleteMapping(Constant.API_ITENS + "/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable("id") String id){
        itensService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping(Constant.API_ITENS)
    public ResponseEntity<List<ITENS>> findAll(){
        return ResponseEntity.ok(itensService.findAll());
    }
    @GetMapping(Constant.API_ITENS + "/{id}")
    public ResponseEntity<Optional<ITENS>> findById(@PathVariable("id") String id){
        return ResponseEntity.ok(itensService.findById(id));
    }
}
