//? Repository for handling system-level actions.
//? Manages Reboot, Shutdown, and Emergency Stop logic.
//? Currently prints to terminal until MQTT backend is ready.

//& Imports
import '../core/utils/app_logger.dart';

//& SystemRepository
class SystemRepository {
  //* Perform a full system reboot
  //* Reboots the whole system including microcontrollers and the server.
  Future<void> rebootSystem() async {
    try {
      //* Send reboot command to server
      // TODO :: Replace with MQTT topic: tazrout/system/reboot
      
      //* Signal microcontrollers to reset
      // TODO :: Replace with MQTT topic: tazrout/mcu/all/reset

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
      // TODO :: Replace with MQTT topic: tazrout/system/status/check
      
      //* Gracefully close active processes/connections
      // TODO :: Replace with MQTT topic: tazrout/system/process/close

      //* Send final shutdown command to PC
      // TODO :: Replace with MQTT topic: tazrout/system/shutdown

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
      // TODO :: Replace with MQTT topic: tazrout/emergency/stop
      
      //* Kill all active server tasks
      // TODO :: Replace with MQTT topic: tazrout/system/emergency/kill

      AppLogger.critical('EMERGENCY', 'Emergency stop performed successfully: All operations halted instantly.');
    } catch (e, stackTrace) {
      AppLogger.critical('EMERGENCY', 'Failed to execute emergency stop', e, stackTrace);
      rethrow;
    }
  }
}
