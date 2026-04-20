/*
 * FILE: AiDecision.java
 * PURPOSE: JPA entity representing an AI-generated irrigation decision.
 *          Maps to the "ai_decisions" PostgreSQL table.
 *
 *          Fields:
 *            decision_id    VARCHAR(20)   PK   — e.g. "DEC-2024-001"
 *            decision_date  TIMESTAMP          — ISO 8601 UTC
 *            decision_type  VARCHAR(15)        — IRRIGATION | ALERT | ADVICE | CRITICAL
 *            affected_zones TEXT               — JSON array of zone IDs
 *            description    TEXT               — Human-readable decision summary
 *            notes          TEXT               — Additional context or warnings
 *            farmer_advice  TEXT               — Actionable recommendation for farmer
 *
 * MQTT TOPICS: N/A (data layer — consumed by AiDecisionService)
 * DATABASE: ai_decisions
 * DEPENDENCIES: Jakarta Persistence
 * IMPLEMENTED BY: Mr. Fehis
 */
