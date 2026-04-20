/*
 * FILE: AiDecisionDto.java
 * PURPOSE: Data transfer object for AI decision data sent to Flutter.
 *          Serialized as JSON matching the payload in docs/MQTT_TOPICS.md
 *          for topics: tazrout/ai/latest-decision, tazrout/ai/decisions
 *
 *          JSON shape:
 *            { "decision_id", "decision_date", "decision_type",
 *              "affected_zones", "description", "notes", "farmer_advice" }
 *
 * MQTT TOPICS: tazrout/ai/latest-decision, tazrout/ai/decisions
 * DATABASE: N/A (maps from AiDecision entity)
 * DEPENDENCIES: AiDecision entity (source mapping)
 * IMPLEMENTED BY: Mr. Fehis
 */
