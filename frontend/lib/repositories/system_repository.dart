//? Repository for handling system-level actions.
//? Manages Reboot, Shutdown, and Emergency Stop logic.
//? Publishes commands via WebSocketService to be relayed to MQTT.

//& Imports
import '../core/constants/mqtt_topics.dart';
import '../core/utils/app_logger.dart';
import '../services/web_socket_service.dart';

//& SystemRepository
class SystemRepository {
  final WebSocketService _wsService;

  SystemRepository(this._wsService);

  //* Perform a full system reboot
  //* Reboots the whole system including microcontrollers and the server.
  Future<void> rebootSystem() async {
    try {
      //* Send reboot command to server
      _wsService.publish(MqttTopics.systemControl, {'command': 'REBOOT'});
      
      //* Signal microcontrollers to reset
      _wsService.publish('tazrout/mcu/all/reset', {'command': 'RESET'});

      AppLogger.info('SYSTEM', 'Reboot performed successfully: All systems and microcontrollers restarting.');
    } catch (e, stackTrace) {
      AppLogger.error('SYSTEM', 'Failed to reboot system', e, stackTrace);
      rethrow;
    }
  }

  //* Perform a graceful system shutdown
  //* Checks and reads everything before shutting down, closing one at a time.
  Future<void> shutdownSystem() async {
    try {
      //* Check device statuses before closing
      _wsService.publish('tazrout/system/status/check', {'command': 'CHECK_STATUS'});
      
      //* Gracefully close active processes/connections
      _wsService.publish('tazrout/system/process/close', {'command': 'CLOSE_PROCESSES'});

      //* Send final shutdown command to PC
      _wsService.publish(MqttTopics.systemControl, {'command': 'SHUTDOWN'});

      AppLogger.info('SYSTEM', 'Shutdown performed successfully: Graceful closure of all components completed.');
    } catch (e, stackTrace) {
      AppLogger.error('SYSTEM', 'Failed to shutdown system', e, stackTrace);
      rethrow;
    }
  }

  //* Perform an instant emergency stop
  //* Stops everything immediately without waiting for status checks.
  Future<void> emergencyStop() async {
    try {
      //* Fire instant stop signal to all hardware
      _wsService.publish(MqttTopics.systemEmergencyStop, {'command': 'EMERGENCY_STOP'});
      
      //* Kill all active server tasks
      _wsService.publish('tazrout/system/emergency/kill', {'command': 'KILL_TASKS'});

      AppLogger.critical('EMERGENCY', 'Emergency stop performed successfully: All operations halted instantly.');
    } catch (e, stackTrace) {
      AppLogger.critical('EMERGENCY', 'Failed to execute emergency stop', e, stackTrace);
      rethrow;
    }
  }
}

