package dz.tazrout.dashboard.repository;

import dz.tazrout.dashboard.model.SensorReading;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SensorReadingRepository extends JpaRepository<SensorReading, String> {
    List<SensorReading> findTop50ByZoneIdOrderByTimestampDesc(String zoneId);
    List<SensorReading> findTop500ByOrderByTimestampDesc();
    List<SensorReading> findByTimestampGreaterThanEqual(String timestamp);
}
