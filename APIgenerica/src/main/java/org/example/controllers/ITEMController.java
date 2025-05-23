package org.example.controllers;

import org.example.constant.Constant;
import org.example.models.ITEM;
import org.example.services.ITEMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin(origins = "*")
public class ITEMController {

    @Autowired
    private ITEMService itemService;

    @PostMapping(Constant.API_ITEM)
    public ResponseEntity<ITEM> createItem(@RequestBody ITEM item) {
        ITEM savedItem = itemService.save(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedItem);
    }

    @PutMapping(Constant.API_ITEM+ "/{id}")
    public ResponseEntity<ITEM> update(@PathVariable String id, @RequestBody ITEM item) {
        item.setId(id);
        ITEM updatedItem = itemService.save(item);
        return ResponseEntity.ok(updatedItem);
    }

    @DeleteMapping(Constant.API_ITEM + "/{id}")
    public ResponseEntity<Void> deleteById(@PathVariable("id") String id) {
        itemService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping(Constant.API_ITEM)
    public ResponseEntity<List<ITEM>> findAll() {
        return ResponseEntity.ok(itemService.findAll());
    }

    @GetMapping(Constant.API_ITEM + "/{id}")
    public ResponseEntity<Optional<ITEM>> findById(@PathVariable("id") String id) {
        return ResponseEntity.ok(itemService.findById(id));
    }
}
