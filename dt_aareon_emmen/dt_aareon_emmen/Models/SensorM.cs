using dt_aareon_emmen.Controllers;
using Microsoft.VisualBasic;

namespace dt_aareon_emmen.Models
{
	public class SensorM
	{
		private Database db;
		private readonly IConfiguration _configuration;

		public SensorM(IConfiguration _configuration)
		{
			this._configuration = _configuration;
			this.db = new Database(
								   this._configuration.GetValue<string>("DatabaseDetails:Username"),
								   this._configuration.GetValue<string>("DatabaseDetails:Host"),
								   this._configuration.GetValue<string>("DatabaseDetails:Password"),
								   this._configuration.GetValue<string>("DatabaseDetails:Database"),
								   this._configuration.GetValue<string>("DatabaseDetails:Port")
								   );
		}

		public List<Dictionary<string, string>> GetSensor(string friendlyname)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"SELECT dt_emmen.room.name as room_name, dt_emmen.sensor.room_number as room_number,  dt_emmen.sensor.friendlyname, dt_emmen.sensor.serial_number, dt_emmen.sensor_type.name as type_name
                                                                   FROM dt_emmen.sensor
                                                                   INNER JOIN dt_emmen.room ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																																	 AND dt_emmen.sensor.building_id = dt_emmen.room.building_id
                                                                   INNER JOIN dt_emmen.sensor_type ON dt_emmen.sensor.type_id = dt_emmen.sensor_type.id
                                                                   WHERE dt_emmen.sensor.friendlyname = @friendlyname;",
																	   new List<string> {
																	   "room_name",
																	   "room_number",
																	   "friendlyname",
																	   "serial_number",
																	   "type_name"
																	   },
																	   new Dictionary<string, string>()
																	   {
																		   ["friendlyname"] = friendlyname.ToString()
																	   });
			return result;
		}

		public List<Dictionary<string, string>> GetSensors(int buildingId)
		{
			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"SELECT dt_emmen.room.name as room_name, dt_emmen.sensor.room_number as room_number,  dt_emmen.sensor.friendlyname, dt_emmen.sensor.serial_number, dt_emmen.sensor_type.name as type_name
                                                                   FROM dt_emmen.sensor
                                                                   INNER JOIN dt_emmen.room ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																																	 AND dt_emmen.room.building_id = dt_emmen.sensor.building_id
                                                                   INNER JOIN dt_emmen.sensor_type ON dt_emmen.sensor.type_id = dt_emmen.sensor_type.id
                                                                   WHERE dt_emmen.room.building_id = CAST (@id AS INTEGER);",
																	   new List<string> {
																	   "room_name",
																	   "room_number",
																	   "friendlyname",
																	   "serial_number",
																	   "type_name"
																	   },
																	   new Dictionary<string, string>()
																	   {
																		   ["id"] = buildingId.ToString()
																	   });
			return result;
		}

		public void RemoveSensor(string friendlyname)
		{
			db.ExecuteQuery(@"
						DELETE FROM dt_emmen.sensor_motion_data_zigbee 
						WHERE dt_emmen.sensor_motion_data_zigbee.friendlyname IN (
							SELECT dt_emmen.sensor.friendlyname
							FROM dt_emmen.sensor 
							WHERE dt_emmen.sensor.friendlyname = CAST (@friendlyname AS VARCHAR)
						)",
						new Dictionary<string, string>()
						{
							["friendlyname"] = friendlyname.ToString()
						});
			db.ExecuteQuery(@"
						DELETE FROM dt_emmen.sensor_co2_data_zigbee 
						WHERE dt_emmen.sensor_co2_data_zigbee.friendlyname IN (
							SELECT dt_emmen.sensor.friendlyname
							FROM dt_emmen.sensor 
							WHERE dt_emmen.sensor.friendlyname = CAST (@friendlyname AS VARCHAR)
						)",
						new Dictionary<string, string>()
						{
							["friendlyname"] = friendlyname.ToString()
						});
			db.ExecuteQuery(@"
						DELETE FROM dt_emmen.sensor 
						WHERE dt_emmen.sensor.friendlyname = CAST (@friendlyname AS VARCHAR)
						",
						new Dictionary<string, string>()
						{
							["friendlyname"] = friendlyname.ToString()
						});
		}

		public bool EditSensor(string friendlyname, string room_nr, string serial, int type_id)
		{
			return db.ExecuteQuery(@"UPDATE dt_emmen.sensor
								 SET room_number = @room_nr,
								 serial_number = @serial, 
								 type_id = CAST(@type_id AS INTEGER)
								 WHERE friendlyname = @friendlyname;",
								 new Dictionary<string, string>()
								 {
									 ["friendlyname"] = friendlyname,
									 ["room_nr"] = room_nr,
									 ["serial"] = serial,
									 ["type_id"] = type_id.ToString()
								 });

		}
		
		// Function that inserts a sensor into the database
		public void AddSensor(string roomNumber, string friendlyName, string serialNumber, int typeId, int buildingId)
		{
			this.db.ExecuteQuery(@"
								INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id, building_id) 
								VALUES (@room_number, @friendlyname, @serial_number, CAST (@type_id AS INTEGER), CAST (@building_id AS INTEGER))",
								new Dictionary<string, string>()
								{
									["room_number"] = roomNumber,
									["friendlyname"] = friendlyName,
									["serial_number"] = serialNumber,
									["type_id"] = typeId.ToString(),
									["building_id"] = buildingId.ToString(),
								});
		}

		// Function that gets all the rooms from a building
        public List<Dictionary<string, string>> GetRooms(int buildingId)
        {
            List<Dictionary<string, string>> data = this.db.SelectQueryPs(@"
                                                                        SELECT building_id, room_number 
																		FROM dt_emmen.room
																		WHERE building_id = CAST (@id AS INTEGER)", 
                                                                        new List<string>{ 
                                                                            "building_id", 
                                                                            "room_number" },
                                                                        new Dictionary<string, string>()
																		{
																			["id"] = buildingId.ToString(),
																		});
            return data;
        } 

		public List<Dictionary<string, string>> FindRoom(string roomNum)
		{
			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
                                                                     SELECT room.room_number, room.building_id, room.name
                                                                     FROM dt_emmen.room
                                                                     WHERE dt_emmen.room.room_number = @room_number
                                                                    ",
																	 new List<string> {
																		 "room_number",
																		 "building_id",
																		 "name"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["room_number"] = roomNum
																	 });

			return data;
		}

		/** getRoomsByBuildingId()
		* 
		* @param id - building Id
		*
		* return all rooms that are associated with a specific building
		**/
		public List<Dictionary<string, string>> GetRoomsByBuildingId(int id)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
				SELECT room_number
				FROM dt_emmen.room
				WHERE building_id = CAST (@id AS INTEGER)
				",
				new List<string>
				{
					"room_number",
				},
				new Dictionary<string, string>()
				{
					["id"] = id.ToString()
				});

			return result;
		}

		// Function that gets all the sensortypes
		public List<Dictionary<string, string>> GetSensorTypes()
		{
			List<Dictionary<string, string>> result = db.SelectQuery(@"SELECT id, name FROM dt_emmen.sensor_type;",
																	   new List<string> {
																	   "id",
																	   "name"
																	   });
			return result;
		}

		// function that gets the facilitor_id
		public List<Dictionary<string, string>> GetFacilitorKey(int facilitor_id)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
																	SELECT facilitor_id
																	FROM dt_emmen.sensor_facilitor
																	WHERE facilitor_id = CAST (@facilitor_id AS INTEGER)",
																	new List<string> {
																		"facilitor_id",
																	},
																	new Dictionary<string, string>() 
																	{ 
																		["facilitor_id"] = facilitor_id.ToString() 
																	});
            return result;
		}

		public List<Dictionary<string, string>> GetFacilitorKeyWithFriendlyName(string name)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
																	SELECT facilitor_id as id
																	FROM dt_emmen.sensor_facilitor
																	WHERE sensor_id = @name",
																	new List<string> {
																		"name",
																	},
																	new Dictionary<string, string>()
																	{
																		["name"] = name
																	});
			return result;
		}

		// function that checks if facilitor id already exists
		public bool CheckIfFacilitorKeyExists(int id)
		{
			List<Dictionary<string, string>> sensors = GetFacilitorKey(id);
            return sensors.Count > 0;
		}

		//Function that adds a facilitor key to a sensor
		public void AddFacilitorKeyToSensor(string friendlyName, int facilitorId, int dataTypeId)
		{
			this.db.ExecuteQuery(@"
				INSERT INTO dt_emmen.sensor_facilitor(sensor_id, facilitor_id, data_type_id)
				VALUES (@sensor_id, CAST (@facilitor_id AS INTEGER), CAST (@data_type_id AS INTEGER));",
				new Dictionary<string, string>()
				{
					["sensor_id"] = friendlyName,
					["facilitor_id"] = facilitorId.ToString(),
					["data_type_id"] = dataTypeId.ToString(),
				});
        }

		
		// Function that gets a facilitor key
		public List<Dictionary<string, string>> GetDataTypesFacilitor()
		{
			List<Dictionary<string, string>> result = db.SelectQuery(@"SELECT id, type
																		FROM dt_emmen.data_type;",
																		new List<string> {
																		"id",
																		"type"
																		});
			return result; 
		}


		// Function that gets the building id
		public List<Dictionary<string, string>> GetBuildingId(int id)
		{
			List<Dictionary<string, string>> building = db.SelectQueryPs(@"
																		SELECT id
																		FROM dt_emmen.building
																		WHERE id = CAST(@id AS INTEGER)",
																			new List<string> { "id" },
																			new Dictionary<string, string> { ["id"] = id.ToString() });

			return building;
		}

		public List<Dictionary<string, string>> GetBuildingName(int id)
		{

			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
																		SELECT name
																		FROM dt_emmen.building
																		WHERE id = CAST (@id AS INTEGER)",
																	new List<string>
																	{
																		"name"
																	},
																	new Dictionary<string, string>()
																	{
																		["id"] = id.ToString()
																	});

			return result;
		}

		// Function that checks if the building id exists
		public bool BuildingIdExists(int id)
		{
			List<Dictionary<string, string>> building = GetBuildingId(id);
			return (building.Count > 0);
		}

	}
}
