package dz.tazrout.dashboard.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "sensor_readings")
public class SensorReading {
    @Id
    private String readingId;
    private String zoneId;
    private String timestamp;
    private Double temperature;
    private Double moisture;
    @Column(name = "water_output")
    private Double waterOutput;
    private Double humidity;

    public String getReadingId() { return readingId; }
    public void setReadingId(String readingId) { this.readingId = readingId; }
    public String getZoneId() { return zoneId; }
    public void setZoneId(String zoneId) { this.zoneId = zoneId; }
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
    public Double getTemperature() { return temperature; }
    public void setTemperature(Double temperature) { this.temperature = temperature; }
    public Double getMoisture() { return moisture; }
    public void setMoisture(Double moisture) { this.moisture = moisture; }
    public Double getWaterOutput() { return waterOutput; }
    public void setWaterOutput(Double waterOutput) { this.waterOutput = waterOutput; }
    public Double getHumidity() { return humidity; }
    public void setHumidity(Double humidity) { this.humidity = humidity; }
}
