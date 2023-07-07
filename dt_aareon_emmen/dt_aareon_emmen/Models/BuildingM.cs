using Microsoft.Extensions.Logging;
using dt_aareon_emmen.Controllers;
using System.Collections.Generic;
using MySqlX.XDevAPI.Common;
using NuGet.Protocol.Plugins;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using System.Text.Json;
using System.Diagnostics;
using Microsoft.AspNetCore.Hosting.Server;
using System.IO;
using System.Collections;
using static System.Net.Mime.MediaTypeNames;
using System.Security;
using System.Reflection.Metadata.Ecma335;
using ImageMagick;

namespace dt_aareon_emmen.Models;
public class BuildingM
{
	// LOGGER to log on different log levels, configuration which contains everything there is in appsettings.json, used in both constructors
	private readonly ILogger<Building> _logger;
	private readonly IConfiguration _configuration;

	// private fields
	private string name;
	private string type;
	private string company;
	private Database db;

	private const string rootpath = "./wwwroot";

	// creating an instance with getters and setters from company class
	public BuildingM(string name, string type, string company, ILogger<Building> _logger, IConfiguration _configuration)
	{
		this.Name = name;
		this.Type = type;
		this.Company = company;

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

	// for creating an instance without the setters/getters - only the logger and configuration details
	public BuildingM(ILogger<Building> _logger, IConfiguration _configuration)
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

	// set && get Name
	public string Name
	{
		get
		{
			return this.name;
		}
		set
		{
			if (value.Length <= 50)
			{
				this.name = value;
			}
			else
			{
				this._logger.LogError($"Unable to set name in building class. Max length is 50, current length is {value.Length}!");
			}
		}
	}

	// set && get Type
	public string Type
	{
		get
		{
			return this.type;
		}
		set
		{
			if (value.Length <= 50)
			{
				this.type = value;
			}
			else
			{
				this._logger.LogError($"Unable to set type in building class. Max length is 50, current length is {value.Length}!");
			}
		}
	}

	// set && get Company
	public string Company
	{
		get
		{
			return this.company;
		}
		set
		{
			if (value.Length <= 20)
			{
				this.company = value;
			}
			else
			{
				this._logger.LogError($"Unable to set type in building class. Max length is 20, current length is {value.Length}!");
			}
		}
	}

	// start other methods

	/** getBuildings()
     * 
     * retrieve all available buildings from the building table
     * for returning format, check the assets/database.cs file
     * 
     */
	public List<Dictionary<string, string>> GetBuildings()
	{
		// Query to select building information and count of active motion and CO2 sensors.
		string query = @"
			SELECT
				building.id,
				building.name,
				building.type,
				building.company,
				building.retention_period,
				COUNT(DISTINCT CASE WHEN sensor_motion_data_zigbee.state = true THEN sensor.friendlyname END) AS active_motion_sensors,
				COUNT(DISTINCT CASE WHEN sensor_co2_data_zigbee.state = true THEN sensor.friendlyname END) AS active_co2_sensors,
				building.image_path AS path
			FROM
				dt_emmen.building
				LEFT JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id
				LEFT JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
				LEFT JOIN dt_emmen.sensor_motion_data_zigbee ON sensor_motion_data_zigbee.friendlyname = sensor.friendlyname
				LEFT JOIN dt_emmen.sensor_co2_data_zigbee ON sensor.friendlyname = sensor_co2_data_zigbee.friendlyname
			GROUP BY
				building.id, building.name, building.type, building.company, building.retention_period, building.image_path;
		";

		// Execute the query and retrieve the results into a list of dictionaries.
		// Each dictionary represents a row of building information.
		// The keys in the dictionary correspond to the column names in the query result.
		List<Dictionary<string, string>> data = this.db.SelectQuery(query, new List<string> { "id", "name", "type", "company", "retention_period", "active_motion_sensors", "active_co2_sensors", "path" });

		// Return the list of building data.
		return data;
	}

	// Removes a building from the database based on the provided ID.
	public void RemoveBuilding(int id)
	{
		// Query to delete a building with the specified ID.
		string query = @"
			DELETE FROM dt_emmen.building
			WHERE dt_emmen.building.id = CAST(@id AS INTEGER)
		";

		// Parameter dictionary to provide the ID value for the query.
		Dictionary<string, string> parameters = new Dictionary<string, string>()
		{
			["id"] = id.ToString()
		};

		// Execute the query with the provided parameters to remove the building.
		db.ExecuteQuery(query, parameters);
	}

	// Updates the information of a building in the database based on the provided form collection data.
	public void EditBuilding(IFormCollection collection)
	{
	// Update query to modify the building's information.
		string updateQuery = @"
			UPDATE dt_emmen.building
			SET name = @name,
				type = @type,
				company = @company,
				retention_period = CAST(@retention AS INTEGER)
			WHERE dt_emmen.building.id = CAST(@id AS INTEGER)
		";

		// Parameters dictionary to provide the values for the query.
		Dictionary<string, string> parameters = new Dictionary<string, string>()
		{
			["id"] = collection["id"],
			["name"] = collection["name"],
			["type"] = collection["type"],
			["company"] = collection["company"],
			["retention"] = Convert.ToInt16(collection["retention"]) > 0 ? collection["retention"] : "0",
		};

		// Execute the update query with the provided parameters to modify the building's information.
		db.ExecuteQuery(updateQuery, parameters);

		// Check if an image file is uploaded for the building.
		if (collection.Files["image"] != null)
		{
			string filePath = rootpath + "/images/buildings/" + collection["id"] + "/";

			// Delete the existing image file if it already exists.
			if (File.Exists(filePath + collection.Files["image"].FileName))
			{
				File.Delete(filePath + collection.Files["image"].FileName);
				UploadImage(collection.Files["image"], filePath);
			}
			else
			{
				UploadImage(collection.Files["image"], filePath);
			}

			// Update the image_path field in the database with the new image path.
			db.ExecuteQuery(@"
				UPDATE dt_emmen.building
				SET image_path = @path
				WHERE dt_emmen.building.id = CAST(@id AS INTEGER)
			",
			new Dictionary<string, string>()
			{
				["id"] = collection["id"],
				["path"] = "/images/buildings/" + collection["id"] + "/" + collection.Files["image"].FileName
			});
		}

		// Check if a map image file is uploaded for the building.
		if (collection.Files["mapimage"] != null)
		{
			string filePath = "/images/maps/" + collection["id"] + "/";

			// Delete the existing map image file if it already exists.
			if (File.Exists(rootpath + filePath + collection.Files["mapimage"].FileName))
			{
				File.Delete(rootpath + filePath + collection.Files["mapimage"].FileName);
			}

			UploadImage(collection.Files["mapimage"], rootpath + filePath);

			// Update the map_path field in the database with the new map image path.
			db.ExecuteQuery(@"
				UPDATE dt_emmen.building
				SET map_path = @path
				WHERE dt_emmen.building.id = CAST(@id AS INTEGER)
			",
			new Dictionary<string, string>()
			{
				["id"] = collection["id"],
				["path"] = filePath + collection.Files["mapimage"].FileName
			});
		}
	}

	// Retrieves the information of a single building from the database based on the provided ID.
	public List<Dictionary<string, string>> EditGetSingleBuilding(int id)
	{
// Query to select the building information.
		string selectQuery = @"
			SELECT id, name, type, company, retention_period
			FROM dt_emmen.building
			WHERE id = CAST(@id AS INTEGER)
		";

		// List of column names to retrieve from the database.
		List<string> columns = new List<string>
		{
			"id",
			"name",
			"type",
			"company",
			"retention_period"
		};

		// Parameters dictionary to provide the value for the query.
		Dictionary<string, string> parameters = new Dictionary<string, string>()
		{
			["id"] = id.ToString()
		};

		// Execute the select query with the provided parameters to retrieve the building information.
		List<Dictionary<string, string>> building = db.SelectQueryPs(selectQuery, columns, parameters);

		return building;
	}

	// Retrieves the ID of a building from the database based on the provided ID.
	public List<Dictionary<string, string>> GetBuildingId(int id)
	{
		// Query to select the building ID.
		string selectQuery = @"
			SELECT id
			FROM dt_emmen.building
			WHERE id = CAST(@id AS INTEGER)
		";

		// List of column names to retrieve from the database.
		List<string> columns = new List<string>
		{
			"id"
		};

		// Parameters dictionary to provide the value for the query.
		Dictionary<string, string> parameters = new Dictionary<string, string>
		{
			["id"] = id.ToString()
		};

		// Execute the select query with the provided parameters to retrieve the building ID.
		List<Dictionary<string, string>> building = db.SelectQueryPs(selectQuery, columns, parameters);

		return building;
	}

	// Checks if a building with the provided ID exists in the database.
	public bool BuildingIdExists(int id)
	{
		// Retrieve the building with the specified ID.
		List<Dictionary<string, string>> building = GetBuildingId(id);

		// Check if the building list contains any records.
		// If it does, it means a building with the provided ID exists in the database.
		return (building.Count > 0);
	}

	// Adds a new building to the database with the provided information.
	public bool AddBuilding(IFormCollection collection, bool companyImageAllowed)
	{
	// Execute the query to insert the building into the database and retrieve the newly generated ID.
		ArrayList result = db.ExecuteQueryWithResult(@"
							INSERT INTO dt_emmen.building(name, type, company, retention_period) 
							VALUES (@name, @type, @company, CAST (@retention_period AS INTEGER) );
							SELECT currval('dt_emmen.building_id_seq') 
							",
							new Dictionary<string, string>()
							{
								["name"] = collection["name"],
								["type"] = collection["type"],
								["company"] = collection["company"],
								["retention_period"] = collection["retention_period"]
							});

		if (result.Count > 0)
		{
			string path = CheckDirectory(rootpath + "/images/buildings/" + result[0].ToString() + "/");
			
			// Check if adding a company image is allowed and upload the image if it exists.
			if (companyImageAllowed)
			{
				if (UploadImage(collection.Files["image"], path))
				{
					string imagePath = path.Replace("./wwwroot", "") + collection.Files["image"].FileName;

					// Update the building record with the image path.
					db.ExecuteQuery(@"
							UPDATE dt_emmen.building 
							SET image_path = @path 
							WHERE dt_emmen.building.id = CAST (@id AS INTEGER)
							",
							new Dictionary<string, string>()
							{
								["id"] = result[0].ToString(),
								["path"] = imagePath
							});
				}
			}
			
			string mappath = CheckDirectory(rootpath + "/images/maps/" + result[0].ToString() + "/");
			
			// Upload the map image if it exists.
			if (UploadImage(collection.Files["mapimage"], mappath))
			{
				string imagePath = mappath.Replace("./wwwroot", "") + collection.Files["mapimage"].FileName;

				// Update the building record with the map image path.
				db.ExecuteQuery(@"
						UPDATE dt_emmen.building 
						SET map_path = @path 
						WHERE dt_emmen.building.id = CAST (@id AS INTEGER)
						",
						new Dictionary<string, string>()
						{
							["id"] = result[0].ToString(),
							["path"] = imagePath
						});
			}
			else
			{
				return false;
			}

			return true;
		}
		else
		{
			return false;
		}
	}

	// Retrieves the map path associated with the specified building ID.
	public List<Dictionary<string, string>> GetMapFromBuilding(int id)
	{
		// Execute the query to select the map path from the building table.
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

	/** getRoomsByBuildingId()
	 * 
	 * @param id - building Id
	 *
	 * return all rooms that are associated with a specific building
	 **/
	public List<Dictionary<string, string>> GetRoomsByBuildingId(int id)
	{
		List<Dictionary<string, string>> result = db.SelectQueryPs(@"
        SELECT
    subquery.building_id,
    subquery.room_number,
    subquery.coordinates,
    subquery.name,
    CASE WHEN MAX(subquery.occupied::int) > 0 THEN true ELSE false END AS occupied,
    MAX(subquery.motion_state) AS motion_state,
    MAX(subquery.motion_battery_percentage) AS motion_battery_percentage,
    CASE WHEN MAX(subquery.co2_battery_low::int) > 0 THEN true ELSE false END AS co2_battery_low,
    CASE WHEN MAX(subquery.co2_battery::int) > 0 THEN true ELSE false END AS co2_battery,
    MAX(subquery.temperature) AS temperature,
    MAX(subquery.huminity) AS humidity,
    MAX(subquery.co2) AS co2,
    MAX(subquery.co2_state) AS co2_state
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
            SUM(CASE WHEN scd.state THEN 1 ELSE 0 END) AS co2_state
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
            dt_emmen.building.id = CAST(@id AS INTEGER)
        GROUP BY
            building.id,
            room.room_number,
            room.coordinates,
            room.name,
            sensor_motion_data_zigbee.occupied,
            sensor_motion_data_zigbee.battery_percentage,
            scd.battery_low,
            scd.temperature,
            scd.huminity,
            scd.co2
    ) AS subquery
GROUP BY
    subquery.building_id,
    subquery.room_number,
    subquery.coordinates,
    subquery.name;
            ",
			new List<string>
			{
				"building_id",
				"room_number",
				"coordinates",
				"name",
				"occupied",
				"motion_state",
				"motion_battery_percentage",
				"co2_battery_low",
				"co2_battery",
				"temperature",
				"humidity",
				"co2",
				"co2_state"
			},
			new Dictionary<string, string>()
			{
				["id"] = id.ToString()
			});

		return result;
	}


	/** getRoomNumNameById()
	 * 
	 * @param id - building Id
	 *
	 * return all the rooms 
	 **/
	public List<string> GetRoomNumNameById(int id)
	{

		List<Dictionary<string, string>> result = db.SelectQueryPs(@"SELECT room_number, coordinates, room.name as name
                                                                   FROM dt_emmen.room
                                                                   INNER JOIN dt_emmen.building 
                                                                   ON dt_emmen.room.building_id = dt_emmen.building.id
                                                                   WHERE dt_emmen.building.id = CAST (@id AS INTEGER)",
																   new List<string>
																   {
																	   "room_number",
																	   "coordinates",
																	   "name"
																   },
																   new Dictionary<string, string>()
																   {
																	   ["id"] = id.ToString()
																   });

		return FormatRoomName(result);
	}

	// Get the room number, coordinates, and name for a specific building ID
	public List<Dictionary<string, string>> GetRoomCoordinatesName(int id)
	{
		// Execute the query to retrieve the room number, coordinates, name, and building ID for a specific building ID
		List<Dictionary<string, string>> result = db.SelectQueryPs(
			@"
			SELECT room_number, coordinates, room.name as name, room.building_id
			FROM dt_emmen.room
			INNER JOIN dt_emmen.building ON dt_emmen.room.building_id = dt_emmen.building.id
			WHERE dt_emmen.building.id = CAST (@id AS INTEGER)
			",
			new List<string>
			{
				"room_number",
				"coordinates",
				"name",
				"building_id"
			},
			new Dictionary<string, string>()
			{
				["id"] = id.ToString()
			}
		);

		// Return the result, which contains a list of dictionaries with column-value pairs
		return result;
	}

	/** FormatRoomName()
	 * 
	 * used by getRoomNumNameById() method, convert list<dict<string, string>> to list<string>
	 * 
	 */
	private List<string> FormatRoomName(List<Dictionary<string, string>> dbResult)
	{

		// create the roomNumNames variable
		List<string> roomNumName = new List<string>();
		if (dbResult != null)
		{
			foreach (Dictionary<string, string> record in dbResult)
			{
				// Check if the name value is empty
				if (record["name"].Equals(""))
				{
					// Format the room name as "<room_number>-flex" and add it to the list
					roomNumName.Add($"{record["room_number"]}-flex".ToString());
				}
				else
				{
					// Format the room name as "<room_number>-<name>" and add it to the list
					roomNumName.Add($"{record["room_number"]}-{record["name"]}".ToString());
				}
			}
		}
		
		// Return the list of formatted room names
		return roomNumName;
	}

	// Check if the specified directory exists, and create it if it does not
	private string CheckDirectory(string path)
	{
		// Check if the directory specified by the 'path' parameter exists
		bool exists = Directory.Exists(path);

		// If the directory does not exist
		if (!exists)
		{
			// Create the directory
			Directory.CreateDirectory(path);
		}

		// Return the original 'path' parameter
		// If the directory already existed, it will be returned as is
		// If the directory did not exist and was created, the same 'path' will be returned
		return path;
	}

	// Upload an image file to the specified destination directory
	private bool UploadImage(IFormFile uploadedFile, string destinationDirectory)
	{
		// Check if the uploaded file is not null and has content
		if (uploadedFile != null && uploadedFile.Length > 0)
		{
			
			// Get the filename from the uploaded file
			string fileName = Path.GetFileName(uploadedFile.FileName);

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
						else {
							image.Quality = 75;
						}
						 //Write file to DIR
						image.Write(stream);
					}
				}
				else {
					uploadedFile.CopyTo(stream);
				}
				
			}

			// Return true to indicate successful upload
			return true;
		}
		else
		{
			// Return false to indicate failed upload (either the file is null or has no content)
			return false;
		}
	}

	// Get a specific building name based on the ID
	public List<Dictionary<string, string>> GetBuildingName(int id)
	{
		// Execute a select query to retrieve the name of a building with the specified ID
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

		// Return the result containing the name of the building
		return result;
	}

	// get all the motion data between 2 dates
	public List<Dictionary<string, string>> GetHistoryMotionInBetween(int buildingId, string startDate, string endDate)
	{
		List<Dictionary<string, string>> data = db.SelectQueryPs(@"
																SELECT 
																SUM(CASE WHEN sensor_motion_data_zigbee.occupied THEN 1 ELSE 0 END) AS occupied, 
																sensor_motion_data_zigbee.date, dt_emmen.room.room_number
																FROM dt_emmen.building 

																INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id 
																INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number 
																AND dt_emmen.sensor.building_id = dt_emmen.room.building_id 
																INNER JOIN dt_emmen.sensor_motion_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_motion_data_zigbee.friendlyname 

																WHERE 
																dt_emmen.building.id = CAST(:id AS INTEGER)
																AND dt_emmen.sensor_motion_data_zigbee.date BETWEEN :startDate::timestamp AND :endDate::timestamp

																GROUP BY 
																sensor_motion_data_zigbee.date, 
																dt_emmen.room.room_number
																ORDER BY 
																sensor_motion_data_zigbee.date ASC
																",
																new List<string> { "occupied", "date", "room_number" },
																new Dictionary<string, string>()
																{
																	["id"] = buildingId.ToString(),
																	["startDate"] = startDate,
																	["endDate"] = endDate
																});

		return data;
	}
	
	// get all the CO2 data between 2 dates
	public List<Dictionary<string, string>> GetHistoryCo2InBetween(int buildingId, string startDate, string endDate)
	{
		List<Dictionary<string, string>> data = db.SelectQueryPs(@"
																SELECT 
																sensor_co2_data_zigbee.date,
																sensor_co2_data_zigbee.co2,
																sensor_co2_data_zigbee.huminity,
																sensor_co2_data_zigbee.temperature,
																dt_emmen.room.room_number
																FROM 
																dt_emmen.building 
																INNER JOIN dt_emmen.room ON dt_emmen.building.id = dt_emmen.room.building_id 
																INNER JOIN dt_emmen.sensor ON dt_emmen.room.room_number = dt_emmen.sensor.room_number
																AND dt_emmen.sensor.building_id = dt_emmen.room.building_id 
																INNER JOIN dt_emmen.sensor_co2_data_zigbee ON dt_emmen.sensor.friendlyname = dt_emmen.sensor_co2_data_zigbee.friendlyname  
																WHERE 
																dt_emmen.building.id = CAST(:id AS INTEGER)
																AND dt_emmen.sensor_co2_data_zigbee.date BETWEEN :startDate::timestamp AND :endDate::timestamp
																GROUP BY 
																sensor_co2_data_zigbee.date,
																sensor_co2_data_zigbee.co2,
																sensor_co2_data_zigbee.huminity,
																sensor_co2_data_zigbee.temperature,
																dt_emmen.room.room_number
																ORDER BY 
																sensor_co2_data_zigbee.date ASC
																",
																new List<string> { "date", "co2", "huminity", "temperature", "room_number" },
																new Dictionary<string, string>()
																{
																	["id"] = buildingId.ToString(),
																	["startDate"] = startDate,
																	["endDate"] = endDate
																});

		return data;
	}
}
