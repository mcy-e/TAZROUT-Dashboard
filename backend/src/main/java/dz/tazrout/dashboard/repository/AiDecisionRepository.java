package dz.tazrout.dashboard.repository;

import dz.tazrout.dashboard.model.AiDecision;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AiDecisionRepository extends JpaRepository<AiDecision, String> {
    List<AiDecision> findTop100ByOrderByDecisionDateDesc();
}
