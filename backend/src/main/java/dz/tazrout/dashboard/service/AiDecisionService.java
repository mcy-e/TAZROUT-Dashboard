/*
 * FILE: AiDecisionService.java
 * PURPOSE: Receives and stores AI irrigation decisions published by the
 *          AI Engine (a separate co-located service). The AI Engine
 *          subscribes to sensor topics, runs its trained model, and
 *          publishes decisions on tazrout/ai/decisions.
 *
 *          This service does NOT run the AI model — it only:
 *            - Persists incoming AI decisions to the ai_decisions table
 *            - Provides paginated query access for the dashboard
 *            - Relays the latest decision to Flutter via WebSocket bridge
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber):
 *     tazrout/ai/decisions              ← all AI decisions
 *     tazrout/ai/decisions/latest       ← latest decision (retained)
 *     tazrout/ai/alerts                 ← critical AI alerts
 * DATABASE: ai_decisions (read/write)
 * DEPENDENCIES: AiDecisionRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
