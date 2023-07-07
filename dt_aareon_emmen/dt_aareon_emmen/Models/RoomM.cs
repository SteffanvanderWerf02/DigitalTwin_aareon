using dt_aareon_emmen.Controllers;
using ImageMagick;
using NuGet.Protocol.Plugins;
using System.Collections;
using System.IO;
using System.Net.Mime;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using static System.Net.Mime.MediaTypeNames;
using ImageMagick;

namespace dt_aareon_emmen.Models
{
	public class RoomM
	{
		private Database db;
		private ILogger<Room> _logger;
		private IConfiguration _configuration;

		private const string rootpath = "./wwwroot";
		
		public RoomM(ILogger<Room> _logger, IConfiguration _configuration)
		{
			this._logger = _logger;
			this._configuration = _configuration;
			this.db = new Database(
								   this._configuration.GetValue<string>("DatabaseDetails:Username"),
								   this._configuration.GetValue<string>("DatabaseDetails:Host"),
								   this._configuration.GetValue<string>("DatabaseDetails:Password"),
								   this._configuration.GetValue<string>("DatabaseDetails:Database"),
								   this._configuration.GetValue<string>("DatabaseDetails:Port")
								   );
		}

		//Gets all the rooms of a building
		public List<Dictionary<string, string>> GetRooms(int buildingId)
		{
			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"SELECT dt_emmen.room.room_number as room_number, dt_emmen.room.coordinates as coordinates, dt_emmen.room.name as room_name
																			FROM dt_emmen.room
																			WHERE dt_emmen.room.building_id = CAST (@id AS INTEGER);",
																				new List<string> {
																					"room_number",
																					"coordinates",
																					"room_name"
																				},
																				new Dictionary<string, string>()
																				{
																					["id"] = buildingId.ToString()
																				});
			return result;
		}

		//Gets the building name
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
		
		//Finds one specfic room
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

		//Gets all the information of a room
		public List<Dictionary<string, string>> GetRoomInformation(int buildingId, string roomNum)
		{
			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
                                                                     SELECT room.room_number, room.building_id, room.coordinates, room.image_path, room.name
                                                                     FROM dt_emmen.room
                                                                     WHERE dt_emmen.room.building_id = CAST (@building_id AS INTEGER) 
                                                                     AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING) 
                                                                    ",
																	 new List<string> {
																		 "room_number",
																		 "building_id",
																		 "coordinates",
																		 "image_path",
																		 "name"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["building_id"] = buildingId.ToString(),
																		 ["room_number"] = roomNum
																	 });

			return data;
		}

		//Gets all the motion sensor data and info
		public List<Dictionary<string, string>> GetRoomMotionsensors(int buildingId, string roomNum)
		{
			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
																		SELECT sensor.friendlyname, sensor_motion_data_zigbee.state AS state
																		FROM dt_emmen.room
																		INNER JOIN dt_emmen.sensor ON dt_emmen.sensor.room_number = dt_emmen.room.room_number
																		AND dt_emmen.sensor.building_id = dt_emmen.room.building_id
																		INNER JOIN dt_emmen.sensor_motion_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname
																		WHERE dt_emmen.room.building_id = CAST (@building_id AS INTEGER)
																		  AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING)
																		  AND dt_emmen.sensor_motion_data_zigbee.date = (
																				SELECT MAX(date)
																				FROM dt_emmen.sensor_motion_data_zigbee
																				WHERE dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname
																				AND dt_emmen.sensor.building_id = CAST (@building_id AS INTEGER)
																		  )
																		GROUP BY sensor.friendlyname, sensor_motion_data_zigbee.state;
                                                                     ",
																	 new List<string> {
																		 "friendlyname",
																		 "state"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["building_id"] = buildingId.ToString(),
																		 ["room_number"] = roomNum
																	 });

			return data;
		}

		// Gets all the co2 sensors info and the data 
		public List<Dictionary<string, string>> GetRoomCo2sensors(int buildingId, string roomNum)
		{

			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
																																SELECT sensor.friendlyname,sensor_co2_data_zigbee.state as state
																																FROM dt_emmen.room 
																																INNER JOIN dt_emmen.sensor ON dt_emmen.sensor.room_number = dt_emmen.room.room_number
																																AND dt_emmen.sensor.building_id = dt_emmen.room.building_id
																																INNER JOIN dt_emmen.sensor_co2_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_co2_data_zigbee.friendlyname
																																WHERE dt_emmen.room.building_id = CAST (@building_id AS INTEGER) 
																																AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING)
																																AND dt_emmen.sensor_co2_data_zigbee.date = (
																																																						SELECT MAX(date)
																																																						FROM dt_emmen.sensor_co2_data_zigbee
																																																						WHERE dt_emmen.sensor.friendlyname = dt_emmen.sensor_co2_data_zigbee.friendlyname
																																																					)
																																GROUP BY sensor.friendlyname, sensor_co2_data_zigbee.state                                                                  
																																",
																	 new List<string> {
																		 "friendlyname",
																		 "state"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["building_id"] = buildingId.ToString(),
																		 ["room_number"] = roomNum
																	 });

			return data;
		}

		// gives all the data from a room with all sensor data includes for the map
		public List<Dictionary<string, string>> GetRoomData(int buildingId, string roomNum)
		{
			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
																	SELECT
																			CASE WHEN MAX(subquery.occupied::int) > 0 THEN true ELSE false END AS occupied,
																			MAX(subquery.motion_state) AS motion_state,
																			MAX(subquery.motion_battery_percentage) AS motion_battery_percentage,
																			CASE WHEN MAX(subquery.co2_battery_low::int) > 0 THEN true ELSE false END AS co2_battery_low,
																			CASE WHEN MAX(subquery.co2_battery::int) > 0 THEN true ELSE false END AS co2_battery,
																			MAX(subquery.temperature) AS temperature,
																			MAX(subquery.huminity) AS humidity,
																			MAX(subquery.co2) AS co2,
																			MAX(subquery.co2_state) AS co2_state,
																		MAX(subquery.motion_update_date) AS motion_update_date,
																		MAX(subquery.co2_update_date) AS co2_update_date
																	FROM
																			(
																					SELECT
																							building.id AS building_id,
																							room.room_number AS room_number,
																							room.coordinates AS coordinates,
																							room.name AS name,
																							sensor_motion_data_zigbee.occupied AS occupied,
																							SUM(CASE WHEN sensor_motion_data_zigbee.state THEN 1 ELSE 0 END) AS motion_state,
																							sensor_motion_data_zigbee.battery_percentage AS motion_battery_percentage,
																							SUM(CASE WHEN scd.battery_low THEN 1 ELSE 0 END) AS co2_battery_low,
																							SUM(CASE WHEN scd.battery THEN 1 ELSE 0 END) AS co2_battery,
																							scd.temperature AS temperature,
																							scd.huminity AS huminity,
																							scd.co2 AS co2,
																							SUM(CASE WHEN scd.state THEN 1 ELSE 0 END) AS co2_state,
																							scd.date AS co2_update_date,
																							sensor_motion_data_zigbee.date AS motion_update_date
																					FROM
																							dt_emmen.building
																							INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id
																							INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																							AND dt_emmen.sensor.building_id = dt_emmen.room.building_id
																							LEFT JOIN (
																									SELECT
																											sensor_motion_data_zigbee.friendlyname,
																											MAX(sensor_motion_data_zigbee.date) AS max_date
																									FROM
																											dt_emmen.sensor_motion_data_zigbee
																									GROUP BY
																											sensor_motion_data_zigbee.friendlyname
																							) AS latest_motion_data ON dt_emmen.sensor.friendlyname = latest_motion_data.friendlyname
																							LEFT JOIN dt_emmen.sensor_motion_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname
																									AND dt_emmen.sensor_motion_data_zigbee.date = latest_motion_data.max_date
																							LEFT JOIN (
																									SELECT
																											sensor_co2_data_zigbee.friendlyname,
																											MAX(sensor_co2_data_zigbee.date) AS max_date,
																											sensor_co2_data_zigbee.temperature,
																											sensor_co2_data_zigbee.huminity,
																											sensor_co2_data_zigbee.co2
																									FROM
																											dt_emmen.sensor_co2_data_zigbee
																									GROUP BY
																											sensor_co2_data_zigbee.friendlyname,
																											sensor_co2_data_zigbee.temperature,
																											sensor_co2_data_zigbee.huminity,
																											sensor_co2_data_zigbee.co2
																							) AS latest_co2_data ON dt_emmen.sensor.friendlyname = latest_co2_data.friendlyname
																							LEFT JOIN dt_emmen.sensor_co2_data_zigbee AS scd ON dt_emmen.sensor.friendlyname = scd.friendlyname
																									AND scd.date = latest_co2_data.max_date
																					WHERE
																							dt_emmen.building.id = CAST (@building_id AS INTEGER)
																							AND room.room_number = CAST (@room_number AS CHARACTER VARYING)
																					GROUP BY
																							building.id,
																							room.room_number,
																							room.coordinates,
																							room.name,
																							sensor_motion_data_zigbee.occupied,
																							sensor_motion_data_zigbee.battery_percentage,
																				sensor_motion_data_zigbee.date,
																							scd.battery_low,
																							scd.temperature,
																							scd.huminity,
																							scd.co2,
																				scd.date
																			) AS subquery
																	GROUP BY
																			subquery.building_id,
																			subquery.room_number,
																			subquery.coordinates,
																			subquery.name

                                                                  ",
																	 new List<string>
																	 {
																		"occupied",
																		"motion_state",
																		"motion_battery_percentage",
																		"co2_battery_low",
																		"co2_battery",
																		"temperature",
																		"humidity",
																		"co2",
																		"co2_state",
																		"motion_update_date",
																		"co2_update_date"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["building_id"] = buildingId.ToString(),
																		 ["room_number"] = roomNum
																	 });

			return data;

		}


		// Gives all the sensor histroy of a room.
		public List<Dictionary<string, string>> GetHistory(int buildingId, string roomNum, DateTime date)
		{
			string day = date.ToString("yyyy-MM-dd");


			List<Dictionary<string, string>> data = db.SelectQueryPs(@"SELECT SUM(CASE WHEN sensor_motion_data_zigbee.occupied THEN 1 ELSE 0 END) as occupied, sensor_motion_data_zigbee.date 
																																	FROM dt_emmen.building 
																																	INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id 
																																	INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																																	AND dt_emmen.sensor.building_id = dt_emmen.room.building_id 
																																	INNER JOIN dt_emmen.sensor_motion_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname 
																																	WHERE dt_emmen.building.id = CAST (@id AS INTEGER) 
																																	AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING) 
																																	AND sensor_motion_data_zigbee.date::date = @day::date
																																	GROUP BY dt_emmen.sensor_motion_data_zigbee.date 
																																	ORDER BY dt_emmen.sensor_motion_data_zigbee.date ASC",
																	 new List<string> { "occupied", "date" },
																	 new Dictionary<string, string>()
																	 {
																		 ["room_number"] = roomNum,
																		 ["id"] = buildingId.ToString().ToUpper(),
																		 ["day"] = day + "%"
																	 });


			return data;
		}

		//gives you motion data between 2 dates 
		public List<Dictionary<string, string>> GetHistoryMotionInBetween(int buildingId, string roomNum, string startDate, string endDate)
		{

			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
                                                                    SELECT 
                                                                        SUM(CASE WHEN sensor_motion_data_zigbee.occupied THEN 1 ELSE 0 END) AS occupied, 
                                                                        sensor_motion_data_zigbee.date 
                                                                    FROM 
                                                                        dt_emmen.building 
                                                                        INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id 
                                                                        INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																																				AND dt_emmen.sensor.building_id = dt_emmen.room.building_id 
                                                                        INNER JOIN dt_emmen.sensor_motion_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname 
                                                                    WHERE 
                                                                        dt_emmen.building.id = CAST(:id AS INTEGER)
                                                                        AND dt_emmen.room.room_number = CAST(:room_number AS VARCHAR)
                                                                        AND dt_emmen.sensor_motion_data_zigbee.date BETWEEN :startDate::timestamp AND :endDate::timestamp
                                                                    GROUP BY 
                                                                        sensor_motion_data_zigbee.date 
                                                                    ORDER BY 
                                                                        sensor_motion_data_zigbee.date ASC
                                                                    ",
																	new List<string> { "occupied", "date" },
																	new Dictionary<string, string>()
																	{
																		["room_number"] = roomNum,
																		["id"] = buildingId.ToString(),
																		["startDate"] = startDate,
																		["endDate"] = endDate
																	});

			return data;
		}

		//Gvies all CO2 data between rooms back
		public List<Dictionary<string, string>> GetHistoryCo2InBetween(int buildingId, string roomNum, string startDate, string endDate)
		{

			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
                                                                    SELECT 
                                                                        sensor_co2_data_zigbee.date,
                                                                        sensor_co2_data_zigbee.co2,
                                                                        sensor_co2_data_zigbee.huminity,
                                                                        sensor_co2_data_zigbee.temperature 
                                                                    FROM 
                                                                        dt_emmen.building 
                                                                        INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id 
                                                                        INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																																				AND dt_emmen.sensor.building_id = dt_emmen.room.building_id 
                                                                        INNER JOIN dt_emmen.sensor_co2_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_co2_data_zigbee.friendlyname  
                                                                    WHERE 
                                                                        dt_emmen.building.id = CAST(:id AS INTEGER)
                                                                        AND dt_emmen.room.room_number = CAST(:room_number AS VARCHAR)
                                                                        AND dt_emmen.sensor_co2_data_zigbee.date BETWEEN :startDate::timestamp AND :endDate::timestamp
                                                                    GROUP BY 
                                                                        sensor_co2_data_zigbee.date,
                                                                        sensor_co2_data_zigbee.co2,
                                                                        sensor_co2_data_zigbee.huminity,
                                                                        sensor_co2_data_zigbee.temperature
                                                                    ORDER BY 
                                                                        sensor_co2_data_zigbee.date ASC
                                                                    ",
																	new List<string> { "date", "co2", "huminity", "temperature" },
																	new Dictionary<string, string>()
																	{
																		["room_number"] = roomNum,
																		["id"] = buildingId.ToString(),
																		["startDate"] = startDate,
																		["endDate"] = endDate
																	});

			return data;
		}

		//Create the room
		public bool CreateRoom(int buildingId, string roomNum, string coordinates, string name, IFormFile image)
		{
			ArrayList result = this.db.ExecuteQueryWithResult(@"
                        INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name)
						VALUES (CAST(@building_id AS integer), @room_number, @coordinates, @name)
                        RETURNING room_number;
                        ",
						new Dictionary<string, string>()
						{
							["building_id"] = buildingId.ToString(),
							["name"] = name,
							["coordinates"] = coordinates,
							["room_number"] = roomNum
						});

			if (result.Count <= 0)
			{
				return false;
			}
			//Upload room image
			string path = CheckDirectory(rootpath + "/images/rooms/" + roomNum + "/");
			string upload = UploadImage(image, path);

			if (string.IsNullOrEmpty(upload)) { return false; }
			//Update path of room image to room field
			return db.ExecuteQuery(@"
                    UPDATE dt_emmen.room 
                    SET image_path = @path 
                    WHERE dt_emmen.room.room_number = @room_number
                    ",
					new Dictionary<string, string>()
					{
						["room_number"] = roomNum,
						["path"] = path.Replace("./wwwroot", "") + upload
					}
			);
		}

		//Delete room by roomnumber
		public void RemoveRoom(string roomNumber)
		{
			db.ExecuteQuery(@"
			DELETE FROM dt_emmen.room
			WHERE dt_emmen.room.room_number = CAST (@roomNumber AS VARCHAR) 
			",
			new Dictionary<string, string>()
			{
				["roomNumber"] = roomNumber.ToString()
			});
		}

		//Check if room has sensors
		public bool checkIfRoomHasSensors(string roomNumber)
		{
			List<Dictionary<string, string>> sensors = GetSensorAmount(roomNumber);
			return sensors.Count > 0;
		}

		// Get amount of sensors that a room has
		public List<Dictionary<string, string>> GetSensorAmount(string roomNumber) 
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
															SELECT COUNT(dt_emmen.sensor.room_number) AS room_count
															FROM dt_emmen.sensor 
															WHERE dt_emmen.sensor.room_number = CAST (@roomNumber AS VARCHAR)
															",
															new List<string> { 
																"room_count",
															},
															new Dictionary<string, string>()
															{
																["roomNumber"] = roomNumber.ToString()
															});
			return result;
		}


		//Check if directory exits in the projects
		private string CheckDirectory(string path)
		{
			bool exists = Directory.Exists(path);

			if (!exists)
			{
				Directory.CreateDirectory(path);
			}

			return path;
		}

		//Sanitize the file name of a file
		private string SanitizeFilename(string filename)
		{
			string invalidChars = Regex.Escape(new string(Path.GetInvalidFileNameChars()));
			string invalidRegStr = string.Format(@"([{0}]*\.+$)|([{0}]+)", invalidChars);

			return Regex.Replace(filename, invalidRegStr, "_");
		}


		//Upload the image to file path
		private string UploadImage(IFormFile uploadedFile, string destinationDirectory)
		{
			if (uploadedFile != null && uploadedFile.Length > 0)
			{
				// Get the filename from the uploaded file
				string fileName = Path.GetFileName(SanitizeFilename(uploadedFile.FileName));

				// Create the destination path by combining the destination directory and the filename
				string destinationPath = Path.Combine(destinationDirectory, fileName);
				// Save the uploaded file to the destination path
				using (var stream = new FileStream(destinationPath, FileMode.Create))
				{
					if (uploadedFile.ContentType == "image/png" || uploadedFile.ContentType == "image/jpeg" || uploadedFile.ContentType == "image/jpg")
					{
						//get byte array
						long length = uploadedFile.Length;
						using var fileStream = uploadedFile.OpenReadStream();
						byte[] bytes = new byte[length];

						//read bytes from file
						fileStream.Read(bytes, 0, (int)uploadedFile.Length);

						//compress image
						using (MagickImage image = new MagickImage(bytes))
						{
							image.Format = image.Format; // Get or Set the format of the image
							if (uploadedFile.ContentType == "image/png")
							{
								image.Quality = 90;
							}
							else
							{
								image.Quality = 75;
							}
							// Write file to DIR
							image.Write(stream);
						}
					}
					else
					{
						uploadedFile.CopyTo(stream);
					}

				}

				return fileName;
			}
			else
			{
				return null;
			}
		}

		//Get all the room Data
		public List<Dictionary<string, string>> GetAllRoomData(int buildingId, string roomNum)
		{
			List<Dictionary<string, string>> data = db.SelectQueryPs(@"
                                                                    SELECT building_id, room_number, coordinates, name
                                                                    FROM dt_emmen.room
                                                                    WHERE dt_emmen.room.building_id = CAST (@building_id AS INTEGER)
                                                                    AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING)
                                                                    ",
																	 new List<string>
																	 {
																		"building_id",
																		"room_number",
																		"coordinates",
																		"name"
																	 },
																	 new Dictionary<string, string>()
																	 {
																		 ["building_id"] = buildingId.ToString(),
																		 ["room_number"] = roomNum
																	 });
			return data;
		}

		//Update the rooms information
		public void UpdateRoom(int buildingId, string roomNum, IFormCollection collection)
		{
			db.ExecuteQuery(@"
            UPDATE dt_emmen.room
            SET coordinates = @coordinates, name = @name
            WHERE dt_emmen.room.building_id = CAST (@building_id AS INTEGER) 
            AND dt_emmen.room.room_number = CAST (@room_number AS CHARACTER VARYING) 
            ",
			new Dictionary<string, string>()
			{
				["building_id"] = buildingId.ToString(),
				["name"] = collection["name"],
				["coordinates"] = collection["coordinates"],
				["room_number"] = roomNum
			});

			if (collection.Files["image"] != null)
			{
				string filePath = CheckDirectory("/images/rooms/" + roomNum + "/");

				if (File.Exists(rootpath + filePath + collection.Files["image"].FileName))
				{
					File.Delete(rootpath + filePath + collection.Files["image"].FileName);
				}

				string upload = UploadImage(collection.Files["image"], rootpath + filePath);

				if (!string.IsNullOrEmpty(upload))
				{
					db.ExecuteQuery(@"
                            UPDATE dt_emmen.room 
                            SET image_path = @path 
                            WHERE dt_emmen.room.room_number = @room_number
                            ",
								new Dictionary<string, string>()
								{
									["room_number"] = roomNum,
									["path"] = filePath + upload
								});
				}
			}
		}

		//Gets the Map image url from the buildings
		public List<Dictionary<string, string>> GetMapFromBuilding(int id)
		{
			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
							SELECT map_path
							FROM dt_emmen.building
							WHERE dt_emmen.building.id = CAST (@id AS INTEGER);",
							new List<string>
							{
							"map_path"
							},
							new Dictionary<string, string>()
							{
								["id"] = id.ToString()
							});

			return result;
		}
	}
}
