package com.amruta.interviewtracker.controller;

import com.amruta.interviewtracker.model.JobApplication;
import com.amruta.interviewtracker.repository.JobApplicationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/applications")
@CrossOrigin(origins = "*")
public class ApplicationController {

    @Autowired
    private JobApplicationRepository repository;

    @GetMapping
    public Page<JobApplication> list(@RequestParam(value = "q", required = false) String q, Pageable pageable) {
        if (q == null || q.isBlank()) {
            return repository.findAll(pageable);
        }
        return repository.findByCompanyContainingIgnoreCaseOrRoleTitleContainingIgnoreCase(q, q, pageable);
    }

    @GetMapping("/{id}")
    public Optional<JobApplication> get(@PathVariable Long id) {
        return repository.findById(id);
    }

    @PostMapping
    public JobApplication create(@RequestBody JobApplication app) {
        return repository.save(app);
    }

    @PutMapping("/{id}")
    public JobApplication update(@PathVariable Long id, @RequestBody JobApplication app) {
        app.setId(id);
        return repository.save(app);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repository.deleteById(id);
    }

}
