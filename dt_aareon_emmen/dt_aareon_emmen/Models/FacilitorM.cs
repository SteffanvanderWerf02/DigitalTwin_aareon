using dt_aareon_emmen.Controllers;
using Microsoft.VisualBasic;

namespace dt_aareon_emmen.Models
{
	public class FacilitorM
	{
        private Database db;
		private readonly IConfiguration _configuration;

        public FacilitorM(IConfiguration _configuration)
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

		//function that gets all the sensors friendlyname
        public List<Dictionary<string, string>> GetSensors(int buildingId)
		{
			List<Dictionary<string, string>> result = this.db.SelectQuery(@"SELECT friendlyname
                                                                            FROM dt_emmen.sensor;",
                                                                            new List<string> {
                                                                            "friendlyname"
                                                                            });
			return result;
		}


		//Get all the sensors with a Facilitor key
		public List<Dictionary<string, string>> GetSensorsWithFacilitorKey()
		{
			List<Dictionary<string, string>> result = this.db.SelectQuery(@"SELECT *
																			FROM dt_emmen.sensor_facilitor sf
																			JOIN dt_emmen.data_type dt ON sf.data_type_id = dt.id;",
                                                                            new List<string> {
                                                                            "id",
																			"sensor_id",
																			"facilitor_id",
																			"data_type_id",
																			"type"
                                                                            });
			return result;
		}

		// Get the current sensor id
		public string GetSensorId(int facilitor_id)
		{
			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"SELECT sensor_id
																			FROM dt_emmen.sensor_facilitor
																			WHERE facilitor_id = CAST(@facilitor_id AS INTEGER)",
																			new List<string> { "sensor_id" },
																			new Dictionary<string, string>()
																			{
																				["facilitor_id"] = facilitor_id.ToString()
																			});

			
			return result[0]["sensor_id"];
		}

		// Get the current datatype
		public string GetDataType(int facilitor_id)
		{
			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"SELECT data_type_id
																			FROM dt_emmen.sensor_facilitor
																			WHERE facilitor_id = CAST(@facilitor_id AS INTEGER)",
																			new List<string> { "data_type_id" },
																			new Dictionary<string, string>()
																			{
																				["facilitor_id"] = facilitor_id.ToString()
																			});
																			
			return result[0]["data_type_id"];
		}

        // Function that gets all the datatypes from Facilitor
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

		

		//Function that gets datatype by name
		public string GetDataTypeName(int facilitor_id)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"SELECT dt.type
																		FROM dt_emmen.sensor_facilitor sf
																		JOIN dt_emmen.data_type dt ON sf.data_type_id = dt.id
																		WHERE sf.facilitor_id = CAST(@facilitor_id AS INTEGER);",
																		new List<string> {
																		"type"
																		},
																		new Dictionary<string, string>()
																		{
																			["facilitor_id"] = facilitor_id.ToString()
																		});

			return  result[0]["type"];		
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

		//Deletes facilitor key
		public void RemoveFacilitorKey(int facilitor_id)
		{
			db.ExecuteQuery(@"
							DELETE FROM dt_emmen.sensor_facilitor
							WHERE facilitor_id = CAST (@facilitor_id AS INTEGER)
							",
							new Dictionary<string, string>()
							{
								["facilitor_id"] = facilitor_id.ToString()
							});
		}

		//function that updates the data in the database
		public void EditFacilitorKey(string sensor_id, int facilitor_id, int new_facilitor_id, int data_type_id)
		{
				this.db.ExecuteQuery(@"UPDATE dt_emmen.sensor_facilitor
										SET sensor_id=@sensor_id, 
										facilitor_id= CAST (@new_facilitor_id AS INTEGER), 
										data_type_id= CAST (@data_type_id AS INTEGER)
										WHERE facilitor_id = CAST (@facilitor_id AS INTEGER);",
										new Dictionary<string, string>()
										{
											["sensor_id"] = sensor_id,
											["new_facilitor_id"] = new_facilitor_id.ToString(),
											["data_type_id"] = data_type_id.ToString(),
											["facilitor_id"] = facilitor_id.ToString()
										});	
		}
    }
}
