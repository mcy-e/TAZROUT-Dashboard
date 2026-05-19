/*
 * FILE: AiDecision.java
 * PURPOSE: JPA entity mapping to the ai_decisions PostgreSQL table.
 *          Stores each irrigation decision from the AI Engine.
 *          Field names match the schema.sql DDL exactly.
 *
 *          Schema columns:
 *            decision_id    VARCHAR(36)   PK
 *            decision_date  TIMESTAMP
 *            decision_type  VARCHAR(15)   — IRRIGATION | ALERT | ADVICE | CRITICAL
 *            affected_zones TEXT          — comma-separated zone IDs
 *            description    TEXT
 *            notes          TEXT
 *            farmer_advice  TEXT
 *
 * DATABASE: ai_decisions
 * DEPENDENCIES: Jakarta Persistence
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ai_decisions")
public class AiDecision {
    @Id
    @Column(name = "decision_id", length = 36)
    private String decisionId;

    @Column(name = "decision_date")
    private String decisionDate;

    @Column(name = "decision_type", length = 15)
    private String decisionType;

    @Column(name = "affected_zones", columnDefinition = "TEXT")
    private String affectedZones;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "farmer_advice", columnDefinition = "TEXT")
    private String farmerAdvice;

    public String getDecisionId() { return decisionId; }
    public void setDecisionId(String decisionId) { this.decisionId = decisionId; }
    public String getDecisionDate() { return decisionDate; }
    public void setDecisionDate(String decisionDate) { this.decisionDate = decisionDate; }
    public String getDecisionType() { return decisionType; }
    public void setDecisionType(String decisionType) { this.decisionType = decisionType; }
    public String getAffectedZones() { return affectedZones; }
    public void setAffectedZones(String affectedZones) { this.affectedZones = affectedZones; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public String getFarmerAdvice() { return farmerAdvice; }
    public void setFarmerAdvice(String farmerAdvice) { this.farmerAdvice = farmerAdvice; }
}
