package dz.tazrout.dashboard.repository;

import dz.tazrout.dashboard.model.Zone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ZoneRepository extends JpaRepository<Zone, String> {
}
