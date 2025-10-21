package com.amruta.interviewtracker.config;

import com.amruta.interviewtracker.model.JobApplication;
import com.amruta.interviewtracker.repository.JobApplicationRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;

@Component
public class DataLoader implements CommandLineRunner {
    private final JobApplicationRepository repository;

    public DataLoader(JobApplicationRepository repository) {
        this.repository = repository;
    }

    @Override
    public void run(String... args) throws Exception {
        if (repository.count() > 0) {
            return; // don't reseed if already populated
        }

        List<JobApplication> seed = List.of(
            create("Acme Corp", "Backend Engineer", "applied", LocalDate.now().minusDays(12), "LinkedIn", 3, "open"),
            create("BlueWave", "Full-Stack Developer", "phone-screen", LocalDate.now().minusDays(9), "Referral", 4, "open"),
            create("Cloudify", "Java Developer", "onsite", LocalDate.now().minusDays(20), "Company site", 2, "rejected"),
            create("DataWorks", "SQL Developer", "applied", LocalDate.now().minusDays(5), "LinkedIn", 3, "open"),
            create("FinCorp", "SRE", "phone-screen", LocalDate.now().minusDays(3), "Referral", 5, "open"),
            create("GreenTech", "Backend Intern", "offer", LocalDate.now().minusDays(30), "University", 1, "accepted"),
            create("Nimbus", "Java Spring Developer", "applied", LocalDate.now().minusDays(2), "LinkedIn", 4, "open"),
            create("Orbit", "Software Engineer", "applied", LocalDate.now().minusDays(14), "Recruiter", 3, "open"),
            create("PixelSoft", "Full-Stack Engineer", "onsite", LocalDate.now().minusDays(7), "Referral", 4, "open"),
            create("Quantum", "Data Engineer", "applied", LocalDate.now().minusDays(1), "Job Board", 2, "open")
        );

        repository.saveAll(seed);
        System.out.println("Seeded " + seed.size() + " job applications.");
    }

    private JobApplication create(String company, String role, String stage, LocalDate appliedDate, String source, int priority, String status) {
        JobApplication j = new JobApplication();
        j.setCompany(company);
        j.setRoleTitle(role);
        j.setStage(stage);
        j.setAppliedDate(appliedDate);
        j.setSource(source);
        j.setPriority(priority);
        j.setStatus(status);
        return j;
    }
}
