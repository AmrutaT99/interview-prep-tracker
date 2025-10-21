package com.amruta.interviewtracker.repository;

import com.amruta.interviewtracker.model.JobApplication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {
    Page<JobApplication> findByCompanyContainingIgnoreCaseOrRoleTitleContainingIgnoreCase(String company, String roleTitle, Pageable pageable);
}
