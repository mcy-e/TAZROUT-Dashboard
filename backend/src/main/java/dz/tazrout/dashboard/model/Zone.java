package dz.tazrout.dashboard.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "zones")
public class Zone {
    @Id
    private String zoneId;
    private String zoneName;
    private String deviceState;
    private String valveState;
    private Double temperature;
    private Double moisture;
    private Double waterLevel;

    public String getZoneId() { return zoneId; }
    public void setZoneId(String zoneId) { this.zoneId = zoneId; }
    public String getZoneName() { return zoneName; }
    public void setZoneName(String zoneName) { this.zoneName = zoneName; }
    public String getDeviceState() { return deviceState; }
    public void setDeviceState(String deviceState) { this.deviceState = deviceState; }
    public String getValveState() { return valveState; }
    public void setValveState(String valveState) { this.valveState = valveState; }
    public Double getTemperature() { return temperature; }
    public void setTemperature(Double temperature) { this.temperature = temperature; }
    public Double getMoisture() { return moisture; }
    public void setMoisture(Double moisture) { this.moisture = moisture; }
    public Double getWaterLevel() { return waterLevel; }
    public void setWaterLevel(Double waterLevel) { this.waterLevel = waterLevel; }
}
